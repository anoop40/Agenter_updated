import 'dart:convert';

import 'package:agenter_updated/success_page_for_company_details_update.dart';
import 'package:flutter/material.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
class company_size extends StatefulWidget{
  _company_size createState() => _company_size();
}
class _company_size extends State<company_size>{
  bool isChecked = false;
  int _selectedIndex = 0;
  final RoundedLoadingButtonController _btnController = RoundedLoadingButtonController();
  @override
  Widget build(BuildContext context) {
    Color getColor(Set<MaterialState> states) {
      const Set<MaterialState> interactiveStates = <MaterialState>{
        MaterialState.pressed,
        MaterialState.hovered,
        MaterialState.focused,
      };
      if (states.any(interactiveStates.contains)) {
        return Colors.blue;
      }
      return Colors.red;
    }
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[

            Padding(
              padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.1),
              child: ListTile(
                title: Text("What is your company size?", style: TextStyle(fontSize: 23),),

                leading: Icon(Icons.verified_user_sharp),

              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.05),
              child: ListTile(
                selected: _selectedIndex == 1,
                tileColor: _selectedIndex == 1 ? Colors.blue : null,
                title: Text("0 to 1"),
                onTap: (){
                  print("_selectedIndex  : " +_selectedIndex.toString());
                  setState(() {
                    _selectedIndex = 1;
                  });
                },
              ),
            ),
            Divider(),
            ListTile(
              selected: _selectedIndex == 2,
              tileColor: _selectedIndex == 2 ? Colors.blue : null,
              title: Text("2 to 5"),
              onTap: (){
                print("_selectedIndex  : " +_selectedIndex.toString());
                setState(() {
                  _selectedIndex = 2;
                });
              },

            ),
            Divider(),
            ListTile(
              selected: _selectedIndex == 3,
              tileColor: _selectedIndex == 3 ? Colors.blue : null,
              title: Text("6 to 10"),
              onTap: (){
                print("_selectedIndex  : " +_selectedIndex.toString());
                setState(() {
                  _selectedIndex = 3;
                });
              },

            ),
            Divider(),
            ListTile(
              selected: _selectedIndex == 4,
              tileColor: _selectedIndex == 4 ? Colors.blue : null,
              title: Text("10+"),
              onTap: (){
                print("_selectedIndex  : " +_selectedIndex.toString());
                setState(() {
                  _selectedIndex = 4;
                });
              },

            ),

          ],
        ),
      ),
      bottomNavigationBar: RoundedLoadingButton(
        width: MediaQuery.of(context).size.width,
        color: Colors.blue[800],
        borderRadius: 1.00,
        child: Text('NEXT', style: TextStyle(color: Colors.white)),
        controller: _btnController,
        onPressed: () async {

          final prefs = await SharedPreferences.getInstance();
          switch(_selectedIndex) {
            case 1: {
              prefs.setString('company_size', '1');
            }
            break;

            case 2: {
              prefs.setString('company_size', '5');
            }
            break;
            case 3: {
              prefs.setString('company_size', '10');
            }
            break;



            default: {
              prefs.setString('company_size', '10');
            }
            break;
          }

          var serverUrlfinal = "https://books.sambiya.com/api/company/profile";
          var response = await http.post(Uri.parse(serverUrlfinal),

              body: {
                "employee_size"  : prefs.getString('company_size').toString(),
                "business_line"  : prefs.getString('line_of_business').toString(),
                "business_role"  : prefs.getString('your_roll').toString(),
              },

              headers: {
                "Accept": "application/json",
               "Cookie": 'gate_token=${prefs.getString('after_regi_token').toString()}'
              });
          print("response.body 12 : " +response.body.toString());
          var received_data = json.decode(response.body);
          print("received_data['success'] : " +received_data['success'].toString());
          if(received_data['success'] == true){
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => success_page_for_company_details_update()),
            );
          }
          _btnController.reset();
        },
      ),
    );
  }
}