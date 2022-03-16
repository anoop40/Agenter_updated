import 'dart:convert';


import 'package:agenter_updated/reffereal_dash.dart';
import 'package:agenter_updated/registered_user/dashboard.dart';
import 'package:agenter_updated/reports.dart';
import 'package:agenter_updated/send_feedback.dart';
import 'package:agenter_updated/subscription_details.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'activities.dart';
import 'add_new_activity.dart';
import 'my_book_keeper.dart';
import 'my_book_keeper_initial.dart';
import 'organization.dart';

class user_dashboard extends StatefulWidget {
  final user_name;
  final email;
  user_dashboard(this.user_name, this.email);
  _user_dashboard createState() => _user_dashboard();
}

class _user_dashboard extends State<user_dashboard> {

  int _selectedIndex = 0;
  static  List<Widget> _widgetOptions = <Widget>[
    dashboard(),
    reports(),
    activities(),
    //messages(),
    my_book_keeper()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
  bottom_sheet_load_subscription(){
    return showModalBottomSheet<void>(
      shape: RoundedRectangleBorder(
        borderRadius: new BorderRadius.only(
            topLeft: const Radius.circular(15.0),
            topRight: const Radius.circular(15.0)),
      ),
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        return subscription_details(widget.email,widget.user_name);
      },
    );
  }


bottom_sheet_load(){
    return showModalBottomSheet<void>(
      shape: RoundedRectangleBorder(
        borderRadius: new BorderRadius.only(
            topLeft: const Radius.circular(15.0),
            topRight: const Radius.circular(15.0)),
      ),
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.9,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Align(
                alignment: Alignment.topRight,
                child: TextButton(
                  onPressed: (){
                    Navigator.pop(context);
                  },
                  child: Text("Done"),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.01),
                child: ChoiceChip(
                  backgroundColor: Colors.greenAccent,
                  label: Text(widget.user_name[0],
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: MediaQuery.of(context).size.width * 0.1),
                  ),
                  selected: true,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.01),
                child: Text(widget.user_name,
                  style: TextStyle(fontSize: 19),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.01),
                child: Text(
                  "Email : ${widget.email}",
                  style: TextStyle(fontSize: 16, color: Colors.black45),
                ),
              ),
              Divider(),
              ListTile(
                leading: FaIcon(FontAwesomeIcons.building, color: Colors.blue[900],),
                title: Text("Organization"),
                trailing: Icon(Icons.navigate_next),
                onTap: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) =>  organization()),
                  );
                },
              ),
              Divider(),
              ListTile(
                leading:Icon(Icons.verified_user,color: Colors.blue[900]),
                title: Text("My bookkeeper"),
                trailing: Icon(Icons.navigate_next),
                onTap: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) =>  my_book_keeper_initial()),
                  );
                },
              ),
              Divider(),
              ListTile(
                leading:FaIcon(FontAwesomeIcons.idBadge,color: Colors.blue[900]),
                title: Text("Refferal"),
                trailing: Icon(Icons.navigate_next),
                onTap: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) =>  reffereal_dash()),
                  );
                },
              ),
              Divider(),
              ListTile(
                leading:FaIcon(FontAwesomeIcons.crown,color: Colors.blue[900]),
                title: Text("Subsciption"),
                trailing: Icon(Icons.navigate_next),
                onTap: (){

                  Navigator.pop(context);
                  return bottom_sheet_load_subscription();


                },
              ),
              Divider(),
              ListTile(
                leading:FaIcon(FontAwesomeIcons.sms,color: Colors.blue[900]),
                title: Text("Send feedback"),
                trailing: Icon(Icons.navigate_next),
                onTap: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) =>  send_feedback()),
                  );
                },
              ),
              Divider(),
              ListTile(
                leading:FaIcon(FontAwesomeIcons.database,color: Colors.blue[900]),
                title: Text("Backup"),
                trailing: Icon(Icons.navigate_next),
              ),
              Divider(),
              ListTile(
                leading:Icon(Icons.logout),
                title: Text("Logout"),
                onTap: (){
                  showDialog<String>(
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                      title: const Text('Are you sure?'),
                      content: const Text('This will close application'),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () => Navigator.pop(context, 'Cancel'),
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () async {
                            SharedPreferences prefs = await SharedPreferences.getInstance();
                            await prefs.clear();
                            Navigator.pop(context);
                            SystemNavigator.pop();
                          },
                          child: const Text('OK'),
                        ),
                      ],
                    ),
                  );
                },
              )
            ],
          ),
        );
      },
    );
}
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        setState(() {
          _selectedIndex = 0;

        });
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: GestureDetector(
            onTap: (){
              bottom_sheet_load();
            },
            child: ChoiceChip(
              backgroundColor: Colors.blue,
              label: Text(widget.user_name[0], style: TextStyle(color: Colors.black),),
              selected: true,
            ),
          ),
          title: GestureDetector(
            onTap: (){
              bottom_sheet_load();
            },
            child: Text(
              widget.user_name,
              style: TextStyle(color: Colors.black),
            ),
          ),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.notifications_outlined,color: Colors.black,),
              tooltip: 'Increase volume by 10',
              onPressed: () {

              },
            ),
          ],
        ),
        body: _widgetOptions.elementAt(_selectedIndex),
        /*
      body: ,
      */
        bottomNavigationBar: BottomNavigationBar(
          type : BottomNavigationBarType.fixed,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Dashboard',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.business,),
              label: 'Reports',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.school),
              label: 'Activity',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.message),
              label: 'Messages',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.amber[800],
          //unselectedItemColor: Colors.black,

          onTap: _onItemTapped,
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => add_new_activity()),
            );
          },
          backgroundColor: Colors.blue[800],
          child: const Icon(Icons.add),
        ),
      ),
    );

  }
}
