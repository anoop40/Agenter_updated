import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '_refferal_code.dart';
import 'bank_details.dart';

class reffereal_dash extends StatefulWidget {
  _reffereal_dash createState() => _reffereal_dash();
}

class _reffereal_dash extends State<reffereal_dash> with SingleTickerProviderStateMixin{
  late Future str;
  late var _account_name;
  late var _email;
  late var _phone;
  late var _status;
  final _reson_to_change = new TextEditingController();
  final _country = new TextEditingController();
  late TabController _controller;
  var vendors;
  getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    var serverUrlfinal = "https://books.sambiya.com/book-keeping/referral";

    var response = await http.get(Uri.parse(serverUrlfinal), headers: {
      "Accept": "application/json",
      "Cookie": 'gate_token=${prefs.getString('token').toString()}'
    });
    print("welcome all");
    print("Response body12 : " + response.body.toString());
    setState(() {
      vendors = json.decode(response.body) ;
    });
    return true;

  }

  @override
  void initState() {
    super.initState();
    str = getData();
    _controller = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(
          color: Colors.black, //change your color here
        ),
        title : Text("Refferal", style: TextStyle(color: Colors.black),),
          actions: <Widget>[
            IconButton(
              icon: FaIcon(FontAwesomeIcons.questionCircle, color: Colors.black,),
              tooltip: 'Increase volume by 10',
              onPressed: () {

              },
            ),
          ]
      ),
      body: FutureBuilder(
        future: str,
        builder: (context,snapshot){
          if(snapshot.hasData){
            return SingleChildScrollView(
              child: Center(
                child: Column(
                  children: <Widget>[
                    Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        color: Colors.blue[600],

                      ),
                      child: Center(
                        child: Padding(
                          padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.06, bottom: MediaQuery.of(context).size.height * 0.06, ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[


                              Column(
                                children: <Widget>[
                                  Text("${vendors['total_credits'].toString()}", style: TextStyle(color: Colors.white, fontSize: 24),),
                                  Text("Total credits available", style: TextStyle(color: Colors.white),)
                                ],
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.09),
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    primary: Colors.white
                                  ),
                                  onPressed: (){},
                                  child: Text("Claim Now", style: TextStyle(color: Colors.black),),
                                ),
                              ),


                            ],
                          ),
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.03),
                      child: TabBar(
                        labelColor: Colors.black,
                        controller: _controller,
                        tabs: const <Widget>[
                          Tab(
                            text: "Reffereral code",
                          ),
                          Tab(
                            text: "Transactions",
                          ),
                          Tab(
                            text: "Bank details",
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.8,
                      child: TabBarView(
                        controller: _controller,
                        children: <Widget>[
                          refferal_code(),
                          Card(
                            child: new ListTile(
                              leading: const Icon(Icons.location_on),
                              title: new Text('Latitude: 48.09342\nLongitude: 11.23403'),
                              trailing: new IconButton(icon: const Icon(Icons.my_location), onPressed: () {}),
                            ),
                          ),
                          bank_details(),
                        ],
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
      ),
    );
    /*
    return FutureBuilder(
      future: str,
      builder: (context,snapshot){
        if(snapshot.hasData){
          return ;
        }
        else{
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },

    );
    */
  }
}
