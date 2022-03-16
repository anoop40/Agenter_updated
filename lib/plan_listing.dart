import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
class plan_listing extends StatefulWidget{
  _plan_listing createState() => _plan_listing();
}
class _plan_listing extends State<plan_listing>{
  late Future str;
  var records;
  getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    var serverUrlfinal = "https://books.sambiya.com/subscription/plans/book-keeping";

    var response = await http.get(Uri.parse(serverUrlfinal), headers: {
      "Accept": "application/json",
      "Cookie": 'gate_token=${prefs.getString('token').toString()}'
    });
    print("welcome all");
    print("Response body12 : " + response.body.toString());
    setState(() {
      records = json.decode(response.body) ;
    });
    print("Plans : "+records['plans'].toString());
    //print("Plans details : "+records['plans'][1].toString());
    return true;

  }
  @override
  void initState() {
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
          title: Text("Plans",style: TextStyle(color: Colors.black),),

        ),
      body: SingleChildScrollView(
        child: Center(
          child: Container(

            padding: EdgeInsets.all(5),
            width: MediaQuery.of(context).size.width * 0.8,
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.03),
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.9,
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.black12)
                    ),
                    child: Column(

                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.02),
                          child: Text("Basic", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.pink),),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.01),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text("INR 2000", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 23),),
                              Text(" /month")
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.03),
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width * 0.96,
                            child: Text("Ideal for businesses with 1- 100 monthly transactions and 1-3 bank accounts."),
                          ),
                        ),
                        Divider(),
                        Padding(
                          padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.03),
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width * 0.96,
                            child: Text(" Includes", style: TextStyle(fontWeight: FontWeight.bold),),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.01),
                          child: SizedBox(
                              width: MediaQuery.of(context).size.width * 0.96,
                              child: Row(
                                children: <Widget>[
                                  Icon(Icons.check, color: Colors.green,),
                                  Text(" Monthly transaction size : 100/month")
                                ],
                              )
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.01),
                          child: SizedBox(
                              width: MediaQuery.of(context).size.width * 0.96,
                              child: Row(
                                children: <Widget>[
                                  Icon(Icons.check, color: Colors.green,),
                                  Text(" Free on boarding : 1 week")
                                ],
                              )
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.01),
                          child: SizedBox(
                              width: MediaQuery.of(context).size.width * 0.96,
                              child: Row(
                                children: <Widget>[
                                  Icon(Icons.check, color: Colors.green,),
                                  Text(" Month end close : Yes")
                                ],
                              )
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.01),
                          child: SizedBox(
                              width: MediaQuery.of(context).size.width * 0.96,
                              child: Row(
                                children: <Widget>[
                                  Icon(Icons.check, color: Colors.green,),
                                  Text(" Cashflow statement : Yes")
                                ],
                              )
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.01),
                          child: SizedBox(
                              width: MediaQuery.of(context).size.width * 0.96,
                              child: Row(
                                children: <Widget>[
                                  Icon(Icons.check, color: Colors.green,),
                                  Text(" Reports : Yes")
                                ],
                              )
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.01),
                          child: SizedBox(
                              width: MediaQuery.of(context).size.width * 0.96,
                              child: Row(
                                children: <Widget>[
                                  Icon(Icons.check, color: Colors.green,),
                                  Text(" Reports schedule: Custom")
                                ],
                              )
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.01),
                          child: SizedBox(
                              width: MediaQuery.of(context).size.width * 0.96,
                              child: Row(
                                children: <Widget>[
                                  Icon(Icons.check, color: Colors.green,),
                                  Text(" Real time business dashboards: Yes")
                                ],
                              )
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.01),
                          child: SizedBox(
                              width: MediaQuery.of(context).size.width * 0.96,
                              child: Row(
                                children: <Widget>[
                                  Icon(Icons.check, color: Colors.green,),
                                  Text(" Qualified dedicated account manager: Yes")
                                ],
                              )
                          ),
                        ),

                        Padding(
                          padding: EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.01),
                          child: ElevatedButton(

                            onPressed: (){},
                            child: Text("Pay Now"),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.03),
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.9,
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.black12)
                    ),
                    child: Column(

                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.02),
                          child: Text("Basic", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.pink),),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.01),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text("\$395", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 23),),
                              Text(" /month")
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.03),
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width * 0.96,
                            child: Text("Ideal for businesses with 1- 100 monthly transactions and 1-3 bank accounts."),
                          ),
                        ),
                        Divider(),
                        Padding(
                          padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.03),
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width * 0.96,
                            child: Text("Includes", style: TextStyle(fontWeight: FontWeight.bold),),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.01),
                          child: SizedBox(
                              width: MediaQuery.of(context).size.width * 0.96,
                              child: Row(
                                children: <Widget>[
                                  Icon(Icons.check, color: Colors.green,),
                                  Text("Cash basic account")
                                ],
                              )
                          ),
                        ),

                        Padding(
                          padding: EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.01),
                          child: ElevatedButton(

                            onPressed: (){},
                            child: Text("Pay Now"),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),

/*
        child: GridView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.02),
            physics: ScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
            ),
            itemCount: 10,
            itemBuilder: (BuildContext context, int index) {
              return Container(
                width: MediaQuery.of(context).size.width * 0.4,
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.blueAccent)
                ),
                child: Column(

                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.02),
                      child: Text("Basic", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.pink),),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.01),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text("\$395", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 23),),
                          Text(" /month")
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.03),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.6,
                        child: Text("Ideal for businesses with 1- 100 monthly transactions and 1-3 bank accounts."),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.zero,
                      child: ElevatedButton(

                        onPressed: (){},
                        child: Text("Pay Now"),
                      ),
                    ),
                  ],
                ),
              );
            }
        ),
        */



        /*
        child: Card(
          child: InkWell(
            splashColor: Colors.blue.withAlpha(30),
            onTap: () {
              debugPrint('Card tapped.');
            },
            child: const SizedBox(
              width: 300,
              height: 100,
              child: Text('A card that can be tapped'),
            ),
          ),
        ),
        */
      ),
    );
  }
}