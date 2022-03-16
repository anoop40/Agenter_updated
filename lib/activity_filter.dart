import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
class activity_filter extends StatefulWidget{
  _activity_filter createState() => _activity_filter();
}
class _activity_filter extends State<activity_filter>{
  bool _list_allValue = true;
  bool _open = false;
  bool _hold = false;
  bool _delete = false;
  bool _reopen = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.01, left: MediaQuery.of(context).size.width * 0.05),
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.9,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text('Activity filter', style: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.05),),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.07,
                  child: IconButton(
                    icon: Icon(Icons.close),
                    onPressed: (){
                      Navigator.pop(context);
                    },
                  ),
                )
              ],
            ),
          ),
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.9,
          child: ListTile(
            title: Text("All"),
            trailing: CupertinoSwitch(
              value: _list_allValue,
              onChanged: (value) async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                prefs.setString('selected_sorting', 'na');
                setState(() {
                  _list_allValue = value;
                  _open = false;
                  _hold = false;
                  _delete = false;
                  _reopen = false;
                });
              },
            ),
          ),
        ),
        Divider(),
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.9,
          child: ListTile(
            title: Text("Open"),
            trailing: CupertinoSwitch(
              value: _open,
              onChanged: (value) async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                prefs.setString('selected_sorting', 'open');
                setState(() {
                  _open = value;
                  _list_allValue = false;
                  _hold = false;
                  _delete = false;
                  _reopen = false;
                });
              },
            ),
          ),
        ),
        Divider(),
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.9,
          child: ListTile(
            title: Text("Hold"),
            trailing: CupertinoSwitch(
              value: _hold,
              onChanged: (value) async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                prefs.setString('selected_sorting', 'hold');
                setState(() {
                  _hold = value;
                  _list_allValue = false;
                  _open = false;
                  _delete = false;
                  _reopen = false;
                });
              },
            ),
          ),
        ),
        Divider(),
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.9,
          child: ListTile(
            title: Text("Delete"),
            trailing: CupertinoSwitch(
              value: _delete,
              onChanged: (value) async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                prefs.setString('selected_sorting', 'closed');
                setState(() {
                 _delete = value;
                 _list_allValue = false;
                 _open = false;
                 _hold = false;
                 _reopen = false;
                });
              },
            ),
          ),
        ),
        Divider(),
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.9,
          child: ListTile(
            title: Text("Re open"),
            trailing: CupertinoSwitch(
              value: _reopen,
              onChanged: (value) async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                prefs.setString('selected_sorting', 'reopened');
                setState(() {
                  _reopen = value;
                  _list_allValue = false;
                  _open = false;
                  _hold = false;
                  _delete = false;
                });
              },
            ),
          ),
        ),


      ],
    );
  }
}