import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:ui_tableview/ui_tableview.dart';

void main() {

  runApp(MaterialApp());
}

class TestApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return UITableView(
      numberOfRowsInSection: (context, index) {
        return 10;
      },
      numberOfSections: (context) {
        return 3;
      },
      itemForRowAtIndexPath: (context, indexPath){
        return Card(
          elevation: 8.0,
          margin: new EdgeInsets.symmetric(horizontal: 10.0),
          child: Container(
            height: 100,
            alignment: Alignment.center,
            child: ListTile(
              contentPadding:
              EdgeInsets.symmetric(horizontal: 20.0),
              leading: Icon(Icons.account_circle),
              title: Text("indexPath section = ${indexPath.section}, row = ${indexPath.row}"),
              trailing: Icon(Icons.arrow_forward),
            ),
          ),
        );
      },
      widgetForHeaderInSection: (context, section){
        print("section");
        return Container(
          alignment: Alignment.center,
          color: Colors.brown,
          child: Text("Header $section"),
        );
      },

      heightForHeaderInSection: (context, section){
        return 50;
      },
      heightForRowAtIndexPath: (context, indexPath){
        return 60;
      },
    );
  }
}
