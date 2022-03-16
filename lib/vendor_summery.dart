import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
class vendor_summery extends StatefulWidget{
  _vendor_summery createState() => _vendor_summery();
}
class _vendor_summery extends State<vendor_summery>{
  late Future str;
  DateTime currentDate = DateTime.now();
  final _controller_from_date = new TextEditingController();
  final _controller_to_date = new TextEditingController();
  var activities;
  getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    var serverUrlfinal = "https://books.sambiya.com/reports/widget/profit_and_loss";

    var response = await http.get(Uri.parse(serverUrlfinal), headers: {
      "Accept": "application/json",
      "Cookie": 'gate_token=${prefs.getString('token').toString()}'
    });

    print("Response body : " + response.body.toString());
    setState(() {
      activities = json.decode(response.body) ;
    });
    print("income is : " + activities['income']['total_formatted'].toString());
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
          title: Text("Vendor summery", style: TextStyle(color: Colors.black),),

        ),
        body: FutureBuilder(
          future: str,
          builder: (context,snapshot){
            if(snapshot.hasData){
              return SingleChildScrollView(
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.4),
                    child: Text("Nothing found"),
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