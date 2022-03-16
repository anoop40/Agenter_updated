import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
class profit_and_loss_listing extends StatefulWidget{
  _profit_and_loss_listing createState() => _profit_and_loss_listing();
}
class _profit_and_loss_listing extends State<profit_and_loss_listing>{
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
          title: Text("Profit & loss statement", style: TextStyle(color: Colors.black),),

        ),
      body: FutureBuilder(
        future: str,
        builder: (context,snapshot){
          if(snapshot.hasData){
            return SingleChildScrollView(
              child: Center(
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.03),
                      child: Column(
                        children: <Widget>[
                          Text("Report", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 21),),

                        ],
                      ),
                    ),
                    Center(
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.94,
                        child: Padding(
                          padding: EdgeInsets.only(
                              top: MediaQuery.of(context).size.height * 0.02),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.4,
                                child: GestureDetector(
                                  onTap: (){},
                                  child: TextField(
                                    readOnly: true,
                                    controller: _controller_from_date,
                                    decoration: InputDecoration(
                                      hintText: 'From',
                                      border: OutlineInputBorder(
                                        borderSide: const BorderSide(color: Colors.white, width: 2.0),
                                        borderRadius: BorderRadius.circular(10.0),

                                      ),
                                      contentPadding: EdgeInsets.only(left: 7.00),
                                      suffixIcon: IconButton(
                                        onPressed: () async {
                                          final DateTime? pickedDate = await showDatePicker(
                                              context: context,
                                              initialDate: currentDate,
                                              firstDate: DateTime(2015),
                                              lastDate: DateTime(2050));
                                          if (pickedDate != null && pickedDate != currentDate)
                                            setState(() {
                                              _controller_from_date.text = DateFormat('dd-MM-yyyy').format(pickedDate);
                                            });
                                        } ,
                                        icon: Icon(Icons.today),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Text("To"),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.4,
                                child: TextField(
                                  readOnly: true,
                                  controller: _controller_to_date,
                                  decoration: InputDecoration(
                                    hintText: 'To',
                                    border: OutlineInputBorder(
                                      borderSide: const BorderSide(color: Colors.white, width: 2.0),
                                      borderRadius: BorderRadius.circular(10.0),

                                    ),
                                    contentPadding: EdgeInsets.only(left: 7.00),
                                    suffixIcon: IconButton(
                                      onPressed: () async {

                                        final DateTime? pickedDate = await showDatePicker(
                                            context: context,
                                            initialDate: currentDate,
                                            firstDate: DateTime(2015),
                                            lastDate: DateTime(2050));
                                        if (pickedDate != null && pickedDate != currentDate)
                                          setState(() {
                                            _controller_to_date.text = DateFormat('dd-MM-yyyy').format(pickedDate);
                                          });

                                      },
                                      icon: Icon(Icons.today),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),

                        ),
                      ),
                    ),
                    Padding(padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.05),
                    child: Container(
                      padding:
                      EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.02),
                      width: MediaQuery.of(context).size.width * 0.9,
                      child: Wrap(
                        children: <Widget>[
                          GestureDetector(
                            onTap: () {

                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.blue,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              width: MediaQuery.of(context).size.width * 0.4,
                              child: ListTile(
                                title: Text(
                                  "${activities['income']['total_formatted'].toString()}",
                                  style: TextStyle(color: Colors.white),
                                ),
                                subtitle: Text("Income",
                                    style: TextStyle(color: Colors.white)),
                                trailing: Icon(
                                  Icons.navigate_next,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                left: MediaQuery.of(context).size.width * 0.06),
                            child: GestureDetector(
                              onTap: () {},
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.orange,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                width: MediaQuery.of(context).size.width * 0.4,
                                child: ListTile(
                                  title: Text(
                                    "${activities['expense']['total_formatted'].toString()}",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  subtitle: Text("Expence ",
                                      style: TextStyle(color: Colors.white)),
                                  trailing: Icon(
                                    Icons.navigate_next,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),


                        ],
                      ),
                    ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          top: MediaQuery.of(context).size.width * 0.04),
                      child: GestureDetector(
                        onTap: () {},
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.orange,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          width: MediaQuery.of(context).size.width * 0.6,
                          child: ListTile(
                            title: Text(
                              "${activities['net_profit_loss']['total_formatted'].toString()}",
                              style: TextStyle(color: Colors.white),
                            ),
                            subtitle: Text("Net Profit & Loss",
                                style: TextStyle(color: Colors.white)),
                            trailing: Icon(
                              Icons.navigate_next,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
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