import 'package:flutter/material.dart';
import 'package:ui_tableview/ui_tableview.dart';

void main() {
  runApp(MyApp());
}

const List _sections = ['星标', 'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z',];

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: Scaffold(
        body: SafeArea(child: _contacts()),
      ),
    );
  }

  UITableView _contacts(){
    int _numberOfRowsInSection(context, index){
      return 4;
    }

    int _numberOfSections(context){
      return _sections.length + 1;
    }

    Widget _itemForRowAtIndexPath(context, UIIndexPath indexPath){
      String text;

      if (indexPath.section == 0) {
        if (indexPath.row == 0) {
          text = '新的朋友';
        } else if (indexPath.row == 1) {
          text = '群聊';
        } else if (indexPath.row == 2) {
          text = '周边的人';
        } else if (indexPath.row == 3) {
          text = '视频会议';
        }
      } else {
        text = "小小  ${_sections[indexPath.section - 1]} - ${indexPath.row}";
      }

      return Stack(
        children: [
          Container(color: Colors.white,),
          Row(
            children: [
              Padding(padding: EdgeInsets.only(left: 20)),
              Image.network('https://gss0.bdstatic.com/6LZ1dD3d1sgCo2Kml5_Y_D3/sys/portrait/item/tb.1.2c0e048.VFUJtjrbQl4EwWKNr0H0GA?t=1497799370'),
              Padding(padding: EdgeInsets.only(left: 10)),
              Text( text, style: TextStyle( fontSize: 18, ), )
            ],
          ),
          Positioned(child: Divider(height: 2,),bottom: 0, left: 15,right: 0,),
        ],
      );
    }

    Widget _widgetForHeaderInSection(context, section){
      if (section == 0) return Container();

      return Container(
        alignment: Alignment.centerLeft,
        color: Color.fromRGBO(234, 234, 234, 1),
        padding: EdgeInsets.only(left: 20),
        child: Text("${_sections[section - 1]}"),
      );
    }

    Widget _widgetForHoverHeader(context, section){
      if (section == 0) return Container();

      return Container(
        alignment: Alignment.centerLeft,
        color: Color.fromRGBO(234, 234, 234, 1),
        padding: EdgeInsets.only(left: 20),
        child: Text("${_sections[section - 1]}", style: TextStyle(color: Colors.green),),
      );
    }

    double _heightForHeaderInSection(context, section){
      if (section == 0) return 0;
      return 30;
    }

    return UITableView(
      numberOfRowsInSection: _numberOfRowsInSection,
      numberOfSections: _numberOfSections,
      itemForRowAtIndexPath: _itemForRowAtIndexPath,
      widgetForHeaderInSection: _widgetForHeaderInSection,

      heightForHeaderInSection: _heightForHeaderInSection,
      widgetForHoverHeader: _widgetForHoverHeader,
    );
  }
}

