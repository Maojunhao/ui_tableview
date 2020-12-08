# ui_tableview
一个保留了 iOS 相关命名习惯的 flutter 库。

<img src="https://github.com/Maojunhao/ui_tableview/blob/main/images/ui_tableview_indexpath.gif" width="300"><img src="https://github.com/Maojunhao/ui_tableview/blob/main/images/ui_tableview_contacts.gif" width="300">

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
