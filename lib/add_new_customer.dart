import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class add_new_customer extends StatefulWidget{
  _add_new_customer createState() => _add_new_customer();
}
class _add_new_customer extends State<add_new_customer>{
  late Future str;
  DateTime currentDate = DateTime.now();
  final _controller_from_date = new TextEditingController();
  final _controller_to_date = new TextEditingController();
  var activities;
  final _formKey = GlobalKey<FormState>();
  final RoundedLoadingButtonController _btnController = RoundedLoadingButtonController();
  final _customer_name = new TextEditingController();
  @override
  initState(){
    super.initState();
    //str = getData();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text("Add new customer", style: TextStyle(color: Colors.black),),

        ),

        body: SingleChildScrollView(
          child: Center(
            child: Column(
              children: <Widget>[
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.5,
                  child: Padding(
                    padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.03),
                    child: Image.asset('assets_files/add_new_user.png'),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.03),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.9,
                    child: Form(

                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextFormField(
                            controller: _customer_name,
                            decoration: InputDecoration(
                                hintText: 'Customer Name'
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter customer name';
                              }
                              return null;
                            },
                          ),

                          Center(
                            child: Padding(
                              padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.06),
                              child: RoundedLoadingButton(
                                color: Colors.blue[900],
                                borderRadius: 7.1,
                                child: const Text('SUBMIT', style: TextStyle(color: Colors.white)),
                                controller: _btnController,
                                onPressed: () async {
                                  FocusScope.of(context).requestFocus(FocusNode());
                                  // Validate returns true if the form is valid, or false otherwise.
                                  if (_formKey.currentState!.validate()) {
                                    final prefs = await SharedPreferences.getInstance();

                                    var serverUrlfinal = "https://books.sambiya.com/api/customer";

                                    var response1 = await http.post(Uri.parse(serverUrlfinal), headers: {
                                      "Accept": "application/json",
                                      "Cookie": 'gate_token=${prefs.getString('token').toString()}'
                                    },
                                    body: {
                                      'type' : 'customer',
                                      'name' : _customer_name.text,
                                    }
                                    );
                                    print("From server is : " + response1.body.toString());
                                    var res2 = json.decode(response1.body);
                                    if(res2['success'] == true){
                                      Fluttertoast.showToast(
                                          msg: "Successfully added",
                                          toastLength: Toast.LENGTH_SHORT,
                                          gravity: ToastGravity.CENTER,
                                          timeInSecForIosWeb: 1,
                                          backgroundColor: Colors.red,
                                          textColor: Colors.white,
                                          fontSize: 16.0
                                      );
                                      _btnController.reset();
                                    }
                                  }
                                  else{
                                    _btnController.reset();
                                  }
                                },
                              ),
                            ),
                          ),
                        ],
                      ),

                    ),
                  ),
                ),
              ],
            ),
          )
        )
    );
  }
}