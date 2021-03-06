import 'dart:async';

import 'package:flutter/material.dart';

const double default_header_height = 30;

const double default_item_height = 44;


class UITableView<T> extends StatefulWidget {

  /*------------------------------
    数量控制
  -------------------------------*/

  // 组数
  final int Function(BuildContext context) numberOfSections;

  // 每组对应 行数
  final int Function(BuildContext context, int section) numberOfRowsInSection;

  /*------------------------------
    构造相关
  -------------------------------*/

  // 每组的 Header 构建函数
  final Widget Function(BuildContext context, int section) widgetForHeaderInSection;

  // 每行的 Item 构建函数
  final Widget Function(BuildContext context, UIIndexPath indexPath) itemForRowAtIndexPath;

  /*------------------------------
    高度控制相关
  -------------------------------*/

  // item 高度，默认 44
  final double Function(BuildContext context, UIIndexPath indexPath) heightForRowAtIndexPath;

  // section 高度，默认 30
  final double Function(BuildContext context, int section) heightForHeaderInSection;

  /*------------------------------
    顶部悬停相关属性
  -------------------------------*/

  // 是否需要 hover， 默认为 true
  final bool needHover;

  // Hover Header Builder 函数
  final Widget Function(BuildContext context, int section) widgetForHoverHeader;

  // Hover Header Height
  final double Function(BuildContext context, int section) heightForHoverHeaderInSection;

  /*-------------------------------
    滑动事件
  ---------------------------------*/

  // 滑动过程中实时返回偏移量
  final double Function(double offset) scrollViewDidScroll;

  // 滑动过程中，当前处于最上方的 section 发生改变，只有 needHover = true 时有效
  final int Function(int section) tableViewDidChangeSection;

  /*-------------------------------
    位置初始化
  ---------------------------------*/

  // 设置当前滑动停留的位置
  final double contentOffset;


  const UITableView({
    Key key,
    this.numberOfSections,
    @required this.numberOfRowsInSection,
    @required this.itemForRowAtIndexPath,
    this.heightForRowAtIndexPath,
    this.widgetForHeaderInSection,
    this.heightForHeaderInSection,
    this.widgetForHoverHeader,
    this.heightForHoverHeaderInSection,
    this.needHover = true,
    this.scrollViewDidScroll,
    this.tableViewDidChangeSection,
    this.contentOffset,
  }) : super(key: key);

  @override
  UITableViewState createState() => UITableViewState();
}

class UITableViewState<T> extends State <UITableView<T>> {
  UIDataSource _items = UIDataSource();

  ScrollController _controller;

  StreamController<double> _streamController = StreamController<double>();
  double _offsetY = 0.0;
  int _section = 0;

  @override
  void initState() {
    // TODO: implement initState
    _configDataSource();
    _configScrollController();

    super.initState();
  }

  @override
  void dispose(){
    _controller?.dispose();
    _streamController?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    ListView listView = ListView.builder(
      itemCount: _items.count,
      itemBuilder: (context, index){
        UIRowModel rowModel = _items.rowModelWithIndex(index);

        // 创建 Header
        if(rowModel.indexPath.row == -1) {
          return _buildHeader(context, rowModel.indexPath.section);
        }
        // 创建 Item
        return _buildItem(context, rowModel.indexPath);
      },
      controller: _controller,
    );

    Widget hoverHeader = widget.needHover ? StreamBuilder<double>(
      stream: _streamController.stream,
      initialData: _offsetY,
      builder: (context, snapshot){
        return _builderHoverHeader(context);
      },
    ) : null;

    return Stack(
      children: [
        listView,
        hoverHeader,
      ],
    );
  }

  // 创建 Header
  Container _buildHeader(context, int section){
    return Container(
      height: widget.heightForHeaderInSection == null ? default_header_height : widget.heightForHeaderInSection(context, section),
      child: widget.widgetForHeaderInSection == null ? null : widget.widgetForHeaderInSection(context, section),
    );
  }

  // 创建 Item
  Container _buildItem(context, UIIndexPath indexPath){
    return Container(
      height: widget.heightForRowAtIndexPath == null ? default_item_height : widget.heightForRowAtIndexPath(context, indexPath),
      child: widget.itemForRowAtIndexPath(context, indexPath),
    );
  }

  // 创建悬停 Header
  Widget _builderHoverHeader(context){
    // 顶部下拉不展示悬浮
    if (_offsetY < 0) { return Container(); }

    if (widget.widgetForHoverHeader == null && widget.widgetForHeaderInSection == null) {
      return Container();
    }

    // 获取悬浮 Header 高度
    double height = widget.heightForHoverHeaderInSection == null ? null : widget.heightForHoverHeaderInSection(context, _section);
    if (height == null) {
      height = widget.heightForHeaderInSection == null ? default_header_height : widget.heightForHeaderInSection(context, _section);
    }

    // 计算偏移量，展示当前 section
    double offset = 0;
    int currentSection = _section;
    for (int section = 0; section < _items.sections.length; section++){
      UISectionModel sectionModel = _items.sections[section];
      if (_offsetY >= sectionModel.start && _offsetY <= sectionModel.end) {
//        print('offset = $offset, _offsetY = $_offsetY, start = ${sectionModel.start}, end = ${sectionModel.end}');
        currentSection = sectionModel.section;
        // 根据偏移量计算，当 Header 替换的阶段做一个上推的动效
        double topOffset = sectionModel.end - _offsetY;
        if (topOffset >= 0 && topOffset <= height){
          offset = topOffset - height;
          break;
        }
      }
    }

    if (_section != currentSection && widget.tableViewDidChangeSection != null) {
      widget.tableViewDidChangeSection(currentSection);
    }
    _section = currentSection;

    // 获取悬浮 Header
    Widget header = widget.widgetForHoverHeader == null ? null : widget.widgetForHoverHeader(context, _section);
    if (header == null) {
      header = widget.widgetForHeaderInSection == null ? null : widget.widgetForHeaderInSection(context, _section);
    }

    /*
    * top 根据计算展示是否需要动效
    * height 设置了 heightForHoverHeaderInSection，则使用 heightForHoverHeaderInSection，否则使用 heightForHeaderInSection，都没有时，为 0
    * Header 设置了 widgetForHoverHeader，则使用 widgetForHoverHeader，否则使用 widgetForHeaderInSection，都没有是，为一个不显示的空容器
    */
    return Positioned(
      left: 0,
      right: 0,
      top: offset,
      height: height,
      child: header,
    );
  }

  // 初始化数据源，设定 IndexPath 属性
  void _configDataSource(){
    _items.clear();

    int sections = widget.numberOfSections(context);

    double start = 0;

    for(int section = 0; section < sections; section++){
      UISectionModel sectionModel = UISectionModel();
      sectionModel.section = section;
      sectionModel.height = widget.heightForHeaderInSection == null ? default_header_height : widget.heightForHeaderInSection(context, section);
      sectionModel.start = start;

      UIRowModel headerModel = UIRowModel();
      headerModel.indexPath = UIIndexPath(section: section, row: -1);
      headerModel.height = sectionModel.height;
      sectionModel.rows.add(headerModel);
      start += headerModel.height;

      int rows = widget.numberOfRowsInSection(context, section);
      for(int row = 0; row < rows; row++){
        UIRowModel rowModel = UIRowModel();
        rowModel.indexPath = UIIndexPath(section: section, row: row);
        rowModel.height = widget.heightForRowAtIndexPath == null ? default_item_height : widget.heightForRowAtIndexPath(context, rowModel.indexPath);
        start += rowModel.height;
        sectionModel.rows.add(rowModel);
      }
      sectionModel.end = start;
      _items.sections.add(sectionModel);
    }
  }

  // ScrollController 滑动监听
  void _configScrollController(){
    if (!widget.needHover && widget.scrollViewDidScroll == null) return;
    _controller?.dispose();
    _controller = ScrollController(initialScrollOffset: widget.contentOffset == null ? 0 : widget.contentOffset);
    _controller.addListener(() {
      if (widget.scrollViewDidScroll != null) {
        widget.scrollViewDidScroll(_controller.offset);
      }
      if(!widget.needHover) { return; }
      _streamController.add(
          _offsetY = _controller.offset
      );
    });
  }

}

class UIIndexPath{
  final int section;
  final int row;

  UIIndexPath({
    this.section,
    this.row,
  });
}

class UIDataSource{
  List<UISectionModel> _sections = [];
  List<UISectionModel> get sections => _sections;

  int _count;
  int get count{
    int count = 0;
    _sections.forEach((UISectionModel sectionModel) {
      sectionModel.rows.forEach((row) {
        count++;
      });
    });
    _count = count;
    return count;
  }

  UIRowModel rowModelWithIndex(int index){
    if(index >= this.count){
      return null;
    }

    UIRowModel rowModel;

    int current = 0;
    for(int section = 0; section < _sections.length; section++){
      UISectionModel sectionModel = _sections[section];
      int next = current + sectionModel.rows.length;

      if(next > index){
        rowModel = sectionModel.rows[index - current];
        break;
      }

      current = next;
    }
    return rowModel;
  }

  void clear(){
    _sections.clear();
    _count = 0;
  }
}

class UISectionModel{
  int section;
  double height;

  double start;
  double end;

  List <UIRowModel> rows = [];
}

class UIRowModel {
  UIIndexPath indexPath;
  double height;
}