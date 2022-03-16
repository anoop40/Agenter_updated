import 'dart:convert';

import 'package:agenter_updated/registered_user/messages.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class my_book_keeper_initial extends StatefulWidget {
  _my_book_keeper_initial createState() => _my_book_keeper_initial();
}

class _my_book_keeper_initial extends State<my_book_keeper_initial> {
  late Future str;
  late var _account_name;
  late var _email;
  late var _phone;
  late var _status;
  final _reson_to_change = new TextEditingController();
  final _country = new TextEditingController();
  get_messaage_data() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print("token is : " + prefs.getString('token').toString());
    var response = await http.get(
        Uri.parse("https://books.sambiya.com/book-keeping/book-keeper"),
        headers: {
          "Accept": "application/json",
          "Cookie": 'gate_token=${prefs.getString('token').toString()}'
        });
    //print("Response : " + response.body.toString());
    var resultCon = json.decode(response.body);
    print(
        "accountant id : " + resultCon['data'][0]['accountant_id'].toString());

    var response2 = await http.get(
        Uri.parse(
            "https://books.sambiya.com/api/profile/${resultCon['data'][0]['accountant_id'].toString()}"),
        headers: {
          "Accept": "application/json",
          "Cookie": 'gate_token=${prefs.getString('token').toString()}'
        });
    print("response2.body : " + response2.body.toString());
    var resultCon1 = json.decode(response2.body);
    // print("resultCon1['data'][0]['name'].toString() : " +resultCon1['data']['name'].toString());
    setState(() {
      _account_name = resultCon1['data']['name'].toString();
      _email = resultCon1['data']['email'].toString();
      _phone = resultCon1['data']['mobile_phone_number'].toString();
      _country.text = resultCon1['data']['country'].toString();
    });
    return true;
  }

  @override
  void initState() {
    super.initState();
    str = get_messaage_data();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(
          color: Colors.black, //change your color here
        ),
        title : Text("My bookkeeper", style: TextStyle(color: Colors.black),),
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
                      padding: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height * 0.1),
                      child: ChoiceChip(
                        backgroundColor: Colors.greenAccent,
                        label: Text(
                          _account_name[0],
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: MediaQuery.of(context).size.width * 0.1),
                        ),
                        selected: true,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height * 0.03),
                      child: Text(
                        _account_name,
                        style: TextStyle(fontSize: 23),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height * 0.01),
                      child: Text(
                        "Email : ${_email.toString()}",
                        style: TextStyle(fontSize: 14, color: Colors.black45),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height * 0.01),
                      child: Text(
                        "Mob : ${_phone.toString()}",
                        style: TextStyle(fontSize: 14, color: Colors.black45),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height * 0.02),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.5,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Column(
                              children: <Widget>[
                                CircleAvatar(
                                  radius: 30,
                                  backgroundColor: Colors.blue[900],
                                  child: IconButton(
                                    icon: Icon(
                                      Icons.message,
                                      color: Colors.white,
                                    ),
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) => messages(_account_name,_phone)),
                                      );
                                    },
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.01),
                                  child: Text("Chat"),
                                ),
                              ],
                            ),
                            Column(
                              children: <Widget>[
                                CircleAvatar(
                                  radius: 30,
                                  backgroundColor: Colors.blue[900],
                                  child: IconButton(
                                    icon: Icon(
                                      Icons.call,
                                      color: Colors.white,
                                    ),
                                    onPressed: () async {
                                      await launch('tel:${_phone.toString()}');
                                    },
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.01),
                                  child: Text("Call"),
                                ),
                              ],
                            )
                            ,
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.03),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.9,
                        child: Column(
                          children: <Widget>[
                            TextField(
                              decoration: InputDecoration(
                                hintText: 'Status',
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.02),
                              child: TextField(
                                controller: _country,
                                decoration: InputDecoration(
                                    label: Text("Location")
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.02),
                              child: TextField(
                                decoration: InputDecoration(
                                  hintText: 'Bookkeeper notes',
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.02),
                      child: ListTile(
                        title: Text("Request to change tutor"),
                        leading: FaIcon(FontAwesomeIcons.questionCircle),
                        trailing: Icon(Icons.navigate_next),
                        onTap: (){
                          showModalBottomSheet<void>(
                            isScrollControlled: true,
                            context: context,
                            builder: (BuildContext context) {
                              return Container(
                                height: MediaQuery.of(context).size.height * 0.7,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    Padding(
                                      padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.01),
                                      child: ListTile(
                                        title: Text("Change request"),
                                        leading : TextButton(
                                          onPressed: (){
                                            Navigator.pop(context);
                                          },
                                          child: Text("< Back"),
                                        ),
                                        trailing: TextButton(
                                          onPressed: () async {
                                            showDialog(barrierDismissible: false,
                                              context:context,
                                              builder:(BuildContext context){
                                                return AlertDialog(
                                                  content: new Row(
                                                    children: [
                                                      CircularProgressIndicator(),
                                                      Container(margin: EdgeInsets.only(left: 7),child:Text(" Sending..." )),
                                                    ],),
                                                );
                                              },
                                            );
                                            SharedPreferences prefs = await SharedPreferences.getInstance();
                                            var response2 = await http.post(
                                                Uri.parse(
                                                    "https://books.sambiya.com/book-keeping/book-keeper/change"),
                                                body : {
                                                  'reason' : _reson_to_change.text
                                                },
                                                headers: {
                                                  "Accept": "application/json",
                                                  "Cookie": 'gate_token=${prefs.getString('token').toString()}'
                                                });
                                            print("response2.body : " + response2.body.toString());
                                            var resultCon1 = json.decode(response2.body);
                                            if(resultCon1['data']['status'].toString() == "change-request"){
                                              Navigator.pop(context);
                                              Navigator.pop(context);
                                              Fluttertoast.showToast(
                                                  msg: "Request successfully posted",
                                                  toastLength: Toast.LENGTH_SHORT,
                                                  gravity: ToastGravity.CENTER,
                                                  timeInSecForIosWeb: 1,
                                                  backgroundColor: Colors.red,
                                                  textColor: Colors.white,
                                                  fontSize: 16.0
                                              );

                                            }
                                          },
                                          child: Text("Submit"),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width * 0.9,
                                      child: TextFormField(
                                        controller : _reson_to_change,
                                        decoration: InputDecoration(

                                          border: OutlineInputBorder(),
                                          hintText: 'Reason to change',
                                          contentPadding: EdgeInsets.only(left: 7.00, top: MediaQuery.of(context).size.height * 0.03),
                                        ),
                                        maxLines: 10,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        },
                      ),
                    )
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
