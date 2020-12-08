# ui_tableview
一个保留了 iOS 相关命名习惯的 flutter 库。

<img src="https://github.com/Maojunhao/ui_tableview/blob/main/images/ui_tableview_indexpath.png" width="300"><img src="https://github.com/Maojunhao/ui_tableview/blob/main/images/ui_tableview_contacts.png" width="300">

## Getting Started

 Add the package to your pubspec.yaml:

 ```yaml
 ui_tableview: ^0.0.3
 ```
 
 In your dart file, import the library:

 ```Dart
import 'package:ui_tableview/ui_tableview.dart';
 ``` 


 Instead of using a `ListView` create a `UITableView` Widget:
 
 
 ```Dart
 const List _sections = ['星标', 'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z',];
 
   UITableView _contacts(){
    int _numberOfRowsInSection(context, index){
      return 4;
    }

    int _numberOfSections(context){
      return _sections.length;
    }

    Widget _itemForRowAtIndexPath(context, indexPath){
      return Row(
        children: [
          Padding(padding: EdgeInsets.only(left: 20)),
          Icon(Icons.account_circle),
          Padding(padding: EdgeInsets.only(left: 15)),
          Text("indexPath section = ${indexPath.section}, row = ${indexPath.row}")
        ],
      );
    }

    Widget _widgetForHeaderInSection(context, section){
      return Container(
        alignment: Alignment.centerLeft,
        color: Color.fromRGBO(220, 220, 220, 1),
        padding: EdgeInsets.only(left: 20),
        child: Text("${_sections[section]}"),
      );
    }

    return UITableView(
      numberOfRowsInSection: _numberOfRowsInSection,
      numberOfSections: _numberOfSections,
      itemForRowAtIndexPath: _itemForRowAtIndexPath,
      widgetForHeaderInSection: _widgetForHeaderInSection,
    );
  }
 ```
 
 上方代码示例：
 
 <img src="https://github.com/Maojunhao/ui_tableview/blob/main/images/ui_tableview_indexpath.gif" width="300">
 
 
 ```Dart
 
 const List _sections = ['星标', 'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z',];

UITableView _contactsForApp(){
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
 
 ```
  
 上方代码示例：
 
 <img src="https://github.com/Maojunhao/ui_tableview/blob/main/images/ui_tableview_contacts.gif" width="300">
 
 

### Parameters:
| Name | Description | Required | Default value |
|----|----|----|----|
|`numberOfSections`| final int Function(BuildContext context) numberOfSections 外部返回几组 | - | - |
|`numberOfRowsInSection` | int Function(BuildContext context, int section) numberOfRowsInSection 外部返回每组生成几行item | required | - |
|`widgetForHeaderInSection` | Widget Function(BuildContext context, int section) widgetForHeaderInSection 外部返回每组对应的 Header | - | - |
|`itemForRowAtIndexPath` | Widget Function(BuildContext context, UIIndexPath indexPath) itemForRowAtIndexPath 外部返回对应IndexPath(section, row)的 widget | required | - |
|`heightForRowAtIndexPath` | double Function(BuildContext context, UIIndexPath indexPath) heightForRowAtIndexPath 外部返回对应IndexPath(section, row)的 widget 的行高  | - | 默认 44 |
|`heightForHeaderInSection` | double Function(BuildContext context, int section) heightForHeaderInSection 外部返回对应 section 的 Header 高度 | - | 默认 30 |
|`needHover` | 上方是否需要悬停条 | - | 默认为 true |
|`widgetForHoverHeader` | Widget Function(BuildContext context, int section) widgetForHoverHeader 外部返回当前 section 对应的悬停条，可根据section自定义不同样式。当 widgetForHoverHeader == null时，会执行 widgetForHeaderInSection 回调来获取悬停条 | - | - |
|`heightForHoverHeaderInSection` | double Function(BuildContext context, int section) heightForHoverHeaderInSection 外部返回当前section对应的悬停条高度。当 heightForHoverHeaderInSection == null 时，执行 heightForHeaderInSection 来获取高度 | - | 默认 30 |
| `scrollViewDidScroll` | double Function(double offset) scrollViewDidScroll，设置 scrollViewDidScroll 后，当页面滚动时，这里会返回对应 offset | - | - |
| `tableViewDidChangeSection` | int Function(int section) tableViewDidChangeSection 处于最上方的section发生改变时回调 | - | - |
| `contentOffset` | 设置初始偏移量 | - | - |

