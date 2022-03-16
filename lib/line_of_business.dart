import 'package:flutter/material.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'company_size.dart';
class line_of_business extends StatefulWidget{
  _line_of_business createState() => _line_of_business();
}
class _line_of_business extends State<line_of_business>{
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
                title: Text("What is your lien of business?", style: TextStyle(fontSize: 25),),

                leading: Icon(Icons.verified_user_sharp),

              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.05),
              child: ListTile(
                selected: _selectedIndex == 1,
                tileColor: _selectedIndex == 1 ? Colors.blue : null,
                title: Text("Manufacturer"),
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
              title: Text("Distributer"),
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
              title: Text("Retailer"),
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
              title: Text("Trader"),
              onTap: (){
                print("_selectedIndex  : " +_selectedIndex.toString());
                setState(() {
                  _selectedIndex = 4;
                });
              },

            ),
            Divider(),
            ListTile(
              selected: _selectedIndex == 5,
              tileColor: _selectedIndex == 5 ? Colors.blue : null,
              title: Text("Chartered Accountant"),
              onTap: (){
                print("_selectedIndex  : " +_selectedIndex.toString());
                setState(() {
                  _selectedIndex = 5;
                });
              },

            ),
            Divider(),
            ListTile(
              selected: _selectedIndex == 6,
              tileColor: _selectedIndex == 6 ? Colors.blue : null,
              title: Text("Professional"),
              onTap: (){
                print("_selectedIndex  : " +_selectedIndex.toString());
                setState(() {
                  _selectedIndex = 6;
                });
              },

            ),
            Divider(),
            ListTile(
              selected: _selectedIndex == 7,
              tileColor: _selectedIndex == 7 ? Colors.blue : null,
              title: Text("Services"),
              onTap: (){
                print("_selectedIndex  : " +_selectedIndex.toString());
                setState(() {
                  _selectedIndex = 7;
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
              prefs.setString('line_of_business', 'Manufacturer');
            }
            break;

            case 2: {
              prefs.setString('line_of_business', 'Distributer');
            }
            break;
            case 3: {
              prefs.setString('line_of_business', 'Retailer');
            }
            break;
            case 4: {
              prefs.setString('line_of_business', 'Trader');
            }
            break;
            case 5: {
              prefs.setString('line_of_business', 'Chartered Accountant');
            }
            break;
            case 6: {
              prefs.setString('line_of_business', 'Chartered Accountant');
            }
            break;

            default: {
              prefs.setString('line_of_business', 'Services');
            }
            break;
          }
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => company_size()),
          );
          /*
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => company_size()),
          );
          */
        },
      ),
    );
  }
}