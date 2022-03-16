import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Color.dart';

class forgot_password extends StatefulWidget {
  _forgot_password createState() => _forgot_password();
}

class _forgot_password extends State<forgot_password> {
  final _formKey = GlobalKey<FormState>();
  final RoundedLoadingButtonController _btnController =
      RoundedLoadingButtonController();
  final _email = new TextEditingController();
  final _password = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: HexColor("#092e60"),
        title: Text("Back"),
        elevation: 0.0,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.2),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.6,
                  child:
                      Image(image: AssetImage('assets_files/black_logo.png')),
                ),
              ),
              Divider(),
              Text(
                "Forgotten password ?",
                style: TextStyle(fontSize: 22),
              ),
              Padding(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.03),
                child: Center(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.9,
                    child: Text(
                      "Enter your registered phone number or email and we'll find your account",
                      style: TextStyle(height: 1.5),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 10.00),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: Text(
                    "Please enter your registered email/mobile number and password",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 0.00),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextFormField(
                          controller: _email,
                          decoration: InputDecoration(
                            labelText: "Email/Mobile number",
                            //label: Text("Label"),

                            border: OutlineInputBorder(
                              borderSide: const BorderSide( width: 2.0),
                              borderRadius: BorderRadius.circular(25.0),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter some text';
                            }
                            return null;
                          },
                        ),
                        Padding(
                            padding: EdgeInsets.only(
                                top: MediaQuery.of(context).size.height * 0.04),
                            child: RoundedLoadingButton(
                                child: Text('Continue',
                                    style: TextStyle(color: Colors.white)),
                                controller: _btnController,
                                color: Colors.blue[800],
                                onPressed: () async {

                                })),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
