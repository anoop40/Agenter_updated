import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import 'add_new_customer.dart';
class customer_summery extends StatefulWidget{
  _customer_summery createState() => _customer_summery();
}
class _customer_summery extends State<customer_summery>{
  late Future str;
  DateTime currentDate = DateTime.now();
  final _controller_from_date = new TextEditingController();
  final _controller_to_date = new TextEditingController();
  var activities;
  var customers;
  String capitalize(String s) => s[0].toUpperCase() + s.substring(1);
  getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    var serverUrlfinal = "https://books.sambiya.com/api/customer";

    var response = await http.get(Uri.parse(serverUrlfinal), headers: {
      "Accept": "application/json",
      "Cookie": 'gate_token=${prefs.getString('token').toString()}'
    });

    setState(() {
      customers = json.decode(response.body) ;
    });
    return true;
  }
  @override
  initState(){
    super.initState();
    str = getData();
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
          title: Text("Customer summery", style: TextStyle(color: Colors.black),),

        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => add_new_customer()),
            );
          },
          label: const Text('Add new'),
          icon: const Icon(Icons.add),
          backgroundColor: Colors.blue[900],
        ),
        body: FutureBuilder(
          future: str,
          builder: (context,snapshot){
            if(snapshot.hasData){
              return SingleChildScrollView(
                child: Center(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: customers['data'].length,
                    itemBuilder: (context, index) {
                      return Column(
                        children: <Widget>[
                          ListTile(
                            title: Text(capitalize(customers['data'][index]['name'].toString())),
                            subtitle: Padding(
                              padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.01),
                              child: Row(
                                children: <Widget>[
                                  Icon(Icons.email, size: 16,),
                                  Padding(
                                    padding: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.02),
                                    //child: Text(customers['data'][index]['email'].toString()),
                                    child: customers['data'][index]['email'].toString() == "null"  ?  Text("Not found") : Text(customers['data'][index]['email'].toString()),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.05),
                                    child: Icon(Icons.phone, size: 16,),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.02),
                                    child: customers['data'][index]['mobile'].toString() == "null"  ?  Text("Not found") : Text(customers['data'][index]['mobile'].toString()),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Divider(),
                        ],
                      );
                    },
                  ),
                ),
              );
            }
            else{
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        )
    );
  }
}