import 'dart:convert';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'dart:io' show Platform;
class refferal_code extends StatefulWidget{
  _refferal_code createState() => _refferal_code();
}
class _refferal_code extends State<refferal_code>{
  var vendors;
  late Future str;
  getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    var serverUrlfinal = "https://books.sambiya.com/book-keeping/referral";

    var response = await http.get(Uri.parse(serverUrlfinal), headers: {
      "Accept": "application/json",
      "Cookie": 'gate_token=${prefs.getString('token').toString()}'
    });
    print("welcome all");
    print("Response body : " + response.body.toString());
    setState(() {
      vendors = json.decode(response.body) ;
    });
    return true;

  }
  @override
  void initState() {
    super.initState();
    str = getData();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: str,
      builder: (context,snapshot){
        if(snapshot.hasData){
          return Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.05),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text("Copy and paste this code at"),
                      TextButton(onPressed:(){}, child: Text("your browser"))
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.001),
                child: Image.asset("assets_files/settings_referal_3.png"),
              ),
              Padding(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.02),
                child: Text("REFFERAL CODE", style: TextStyle(
                  fontSize: 15,
                  color: Colors.black38,
                ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.02),
                child: DottedBorder(
                  dashPattern: [6, 3, 2, 3],
                  color: Colors.black,
                  strokeWidth: 1,
                  child: Padding(
                    padding: EdgeInsets.all(15.00),
                    child: Text("${vendors['code'].toString()}", style: TextStyle(fontSize: 22),),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.03),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.6,
                  child: ElevatedButton(

                    style: ElevatedButton.styleFrom(
                      primary: Colors.blue[900],

                    ),
                    onPressed: (){
                      showModalBottomSheet<void>(
                        shape: RoundedRectangleBorder(
                          borderRadius: new BorderRadius.only(
                              topLeft: const Radius.circular(15.0),
                              topRight: const Radius.circular(15.0)),
                        ),
                        isScrollControlled: true,
                        context: context,
                        builder: (BuildContext context) {
                          return Container(
                            height: MediaQuery.of(context).size.height * 0.3,
                            padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.02),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[

                                Padding(
                                  padding: EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.03),
                                  child: SizedBox(
                                    width: MediaQuery.of(context).size.width * 0.8,
                                    child: Row(

                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Text("Share link to", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
                                        TextButton(
                                          onPressed: (){
                                            Navigator.pop(context);
                                          },
                                          child: Text("Cancel"),
                                        )
                                      ],
                                    ),
                                  ),
                                ),

                                SizedBox(
                                  width: MediaQuery.of(context).size.width * 0.9,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      GestureDetector(
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(8.0),
                                          child: Column(
                                            children: <Widget>[
                                              Image.asset(
                                                'assets_files/WhatsApp.png',
                                                height: MediaQuery.of(context).size.height * 0.06,
                                                fit: BoxFit.fill,
                                              ),
                                              Padding(
                                                padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.01),
                                                child: Text("Whatsapp"),
                                              )
                                            ],
                                          ),
                                        ),
                                        onTap: () async {
                                        },
                                      ),
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(8.0),
                                        child: Column(
                                          children: <Widget>[
                                            Image.asset(
                                              'assets_files/2021_Facebook_icon.png',
                                              height: MediaQuery.of(context).size.height * 0.06,
                                              fit: BoxFit.fill,
                                            ),
                                            Padding(
                                              padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.01),
                                              child: Text("Facebook"),
                                            )
                                          ],
                                        ),
                                      ),
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(8.0),
                                        child: Column(
                                          children: <Widget>[
                                            Image.asset(
                                              'assets_files/gmail.png',
                                              height: MediaQuery.of(context).size.height * 0.06,
                                              fit: BoxFit.fill,
                                            ),
                                            Padding(
                                              padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.01),
                                              child: Text("Gmail"),
                                            )
                                          ],
                                        ),
                                      ),
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(8.0),
                                        child: Column(
                                          children: <Widget>[
                                            Image.asset(
                                              'assets_files/twitter_logo.png',
                                              height: MediaQuery.of(context).size.height * 0.06,
                                              fit: BoxFit.fill,
                                            ),
                                            Padding(
                                              padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.01),
                                              child: Text("Twitter"),
                                            )
                                          ],
                                        ),
                                      ),


                                    ],
                                  ),
                                )

                              ],
                            ),
                          );
                        },
                      );
                    },
                    child: const Text("Refer Now"),

                  ),
                ),

              ),
              Padding(
                padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.005),
                /*
          child: OutlinedButton(
            onPressed: (){},
            child: Text("Track Registration"),
          ),
          */
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.6,
                  child: OutlinedButton(
                    onPressed: (){},
                    child: Text("Track Registration"),
                  ),
                ),
              ),
            ],
          );
        }
        else{
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}