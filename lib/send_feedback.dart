import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import 'feedback_success.dart';
class send_feedback extends StatefulWidget{
  _send_feedback createState() => _send_feedback();
}
class _send_feedback extends State<send_feedback>{
  final RoundedLoadingButtonController _btnController = RoundedLoadingButtonController();
  final message = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      backgroundColor: Colors.white,
          iconTheme: IconThemeData(
            color: Colors.black, //change your color here
          ),
      title : Text("Send feedback", style: TextStyle(color: Colors.black),),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.04),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: TextField(
controller: message,
                    maxLines: 20,
                    keyboardType: TextInputType.multiline,

                    decoration: InputDecoration(
                      border: new OutlineInputBorder(),
                      hintText: "Feedback",
                    ),

                  ),
                ),
              ),
              Padding(

                padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.02),
                child: RoundedLoadingButton(
                  color: Colors.blue[900],
                  borderRadius: 6.00,
                  width: MediaQuery.of(context).size.width * 0.3,
                  child: Text('Send', style: TextStyle(color: Colors.white)),
                  controller: _btnController,
                  onPressed: () async {
                    SharedPreferences prefs = await SharedPreferences.getInstance();
                    print("token is : " + prefs.getString('token').toString());
                    var response = await http.post(
                        Uri.parse("https://books.sambiya.com/book-keeping/feedback"),
                        body: {
                          'message' : message.text.toString()
                        },
                        headers: {
                          "Accept": "application/json",
                          "Cookie": 'gate_token=${prefs.getString('token').toString()}'
                        });
                    print("Response : " + response.body.toString());
                    var resultCon = json.decode(response.body);

                    resultCon['data']['id'].toString().isEmpty ?  Text("Not found") :

                    //Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) =>  feedback_success()),
                    );
                    Fluttertoast.showToast(
                        msg: "Message successfully sent.",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.CENTER,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.red,
                        textColor: Colors.white,
                        fontSize: 16.0
                    );
                    /*

                    if(resultCon['data']['id'].toString().isEmpty ?? false ){
                      Navigator.pop(context);
                      Fluttertoast.showToast(
                          msg: "Message successfully sent.",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.CENTER,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.red,
                          textColor: Colors.white,
                          fontSize: 16.0
                      );
                    }
                    */
                  }),
                )
            ],
          )
        ),
      ),
    );
  }
}