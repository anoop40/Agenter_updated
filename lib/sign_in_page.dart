import 'dart:convert';

import 'package:agenter_updated/user_dashboard.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'Color.dart';
import 'forgot_password.dart';

class sign_in_page extends StatefulWidget {
  _sign_in_page createState() => _sign_in_page();
}

class _sign_in_page extends State<sign_in_page> {
  final _formKey = GlobalKey<FormState>();
  final RoundedLoadingButtonController _btnController =
      RoundedLoadingButtonController();
  final _email = new TextEditingController();
  final _password = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: HexColor("#092e60"),
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
                    top: MediaQuery.of(context).size.height * 0.12),
                child: Image(image: AssetImage('assets_files/logo_white.png')),
              ),
              Padding(
                padding: EdgeInsets.only(top: 10.00),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: Text(
                    "Please enter your registered email/mobile number and password",
                    style: TextStyle(color: Colors.white, height: 1.5),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 40.00),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextFormField(
                          controller: _email,
                          style: TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            labelText: "Email/Mobile number",
                            labelStyle: TextStyle(color: Colors.white),
                            border: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Colors.white, width: 2.0),
                              borderRadius: BorderRadius.circular(25.0),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Email is required';
                            }
                            return null;
                          },
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              top: MediaQuery.of(context).size.height * 0.04),
                          child: TextFormField(
                            controller: _password,
                            style: TextStyle(color: Colors.white),
                            obscureText: true,
                            decoration: InputDecoration(
                              labelText: "Password",
                              labelStyle: TextStyle(color: Colors.white),
                              border: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: Colors.white, width: 2.0),
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
                        ),
                        Padding(
                            padding: EdgeInsets.only(
                                top: MediaQuery.of(context).size.height * 0.04),
                            child: RoundedLoadingButton(
                                child: Text('Login',
                                    style: TextStyle(color: Colors.white)),
                                controller: _btnController,
                                color: HexColor("#07b690"),
                                onPressed: () async {
                                  var email = _email.text;
                                  bool emailValid = RegExp(
                                          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                      .hasMatch(email);
                                  if (emailValid != true) {
                                    Fluttertoast.showToast(
                                        msg: "Enter a valid email",
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.CENTER,
                                        timeInSecForIosWeb: 1,
                                        backgroundColor: Colors.red,
                                        textColor: Colors.white,
                                        fontSize: 16.0);
                                    _btnController.reset();
                                  } else {
                                    SharedPreferences prefs =
                                        await SharedPreferences.getInstance();
                                    FocusManager.instance.primaryFocus
                                        ?.unfocus();
                                    if (double.tryParse(
                                            _email.text.toString()) !=
                                        null) {
                                      if (_formKey.currentState!.validate()) {
                                        prefs.setString(
                                            'mobile_number', _email.text);
                                        prefs.setString(
                                            'user_password', _password.text);
                                        prefs.setString(
                                            'already_signed_up', "yes");
                                        var response = await http.post(
                                            Uri.parse(
                                                "https://books.sambiya.com/id/login-mobile?"
                                                "&mobile_number=${_email.text}"
                                                "&country=IN"
                                                "&password=${_password.text}"
                                                "&app-id=books"),
                                            headers: {
                                              "Accept": "application/json",
                                            });
                                        var resultCon =
                                            json.decode(response.body);
                                        if (resultCon['message'] ==
                                            "The given data was invalid.") {
                                          resultCon['errors']['email'] == "" ||
                                                  resultCon['errors']
                                                          ['email'] ==
                                                      null
                                              ? Text("Not found")
                                              : Fluttertoast.showToast(
                                                  msg:
                                                      "${resultCon['errors']['email'].toString()}",
                                                  toastLength:
                                                      Toast.LENGTH_SHORT,
                                                  gravity: ToastGravity.CENTER,
                                                  timeInSecForIosWeb: 1,
                                                  backgroundColor: Colors.red,
                                                  textColor: Colors.white,
                                                  fontSize: 16.0);

                                          resultCon['errors']['password'] ==
                                                      "" ||
                                                  resultCon['errors']
                                                          ['password'] ==
                                                      null
                                              ? Text("Not found")
                                              : Fluttertoast.showToast(
                                                  msg:
                                                      "${resultCon['errors']['password'].toString()}",
                                                  toastLength:
                                                      Toast.LENGTH_SHORT,
                                                  gravity: ToastGravity.CENTER,
                                                  timeInSecForIosWeb: 1,
                                                  backgroundColor: Colors.red,
                                                  textColor: Colors.white,
                                                  fontSize: 16.0);

                                          _btnController.reset();
                                        } else {
                                          print("resultCon['token'] : " +
                                              resultCon['token'].toString());
                                          prefs.setString('app_token',
                                              resultCon['token'].toString());
                                          var response1 = await http.post(
                                              Uri.parse(
                                                  "https://books.sambiya.com/api/login?"
                                                  "app-token=${resultCon['token'].toString()}"),
                                              headers: {
                                                "Accept": "application/json",
                                              });

                                          var resultCon1 =
                                              json.decode(response1.body);
                                          if (resultCon1['is_client'] == true) {
                                            prefs.setString(
                                                'token', resultCon1['token']);
                                            /* get profile data */
                                            var response2 = await http.get(
                                                Uri.parse(
                                                    "https://books.sambiya.com/api/profile"),
                                                headers: {
                                                  "Accept": "application/json",
                                                  "Cookie":
                                                      'gate_token=${resultCon1['token'].toString()}'
                                                });
                                            //print("response2.tostring : " +response2.body.toString());
                                            /* ends here */
                                            var profile_person_data =
                                                json.decode(response2.body);

                                            print("User name : " +
                                                profile_person_data['data']
                                                        ['name']
                                                    .toString());

                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      user_dashboard(
                                                          profile_person_data[
                                                                      'data']
                                                                  ['name']
                                                              .toString(),
                                                          profile_person_data[
                                                                      'data']
                                                                  ['email']
                                                              .toString())),
                                            );
                                          } else {
                                            Fluttertoast.showToast(
                                                msg: "Account not found",
                                                toastLength: Toast.LENGTH_SHORT,
                                                gravity: ToastGravity.CENTER,
                                                timeInSecForIosWeb: 1,
                                                backgroundColor: Colors.red,
                                                textColor: Colors.white,
                                                fontSize: 16.0);
                                          }
                                        }

                                        /*
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => user_dashboard()),
                                );
                                */
                                        _btnController.reset();
                                      } else {
                                        _btnController.reset();
                                      }
                                    } else {
                                      print("Email found");
                                      if (_formKey.currentState!.validate()) {
                                        prefs.setString(
                                            'user_email', _email.text);
                                        prefs.setString(
                                            'user_password', _password.text);
                                        prefs.setString(
                                            'already_signed_up', "yes");
                                        var response = await http.post(
                                            Uri.parse(
                                                "https://books.sambiya.com/id/login?"
                                                "&email=${_email.text}"
                                                "&password=${_password.text}"
                                                "&app-id=books"),
                                            headers: {
                                              "Accept": "application/json",
                                            });
                                        var resultCon =
                                            json.decode(response.body);
                                        if (resultCon['message'] ==
                                            "The given data was invalid.") {
                                          resultCon['errors']['email'] == "" ||
                                                  resultCon['errors']
                                                          ['email'] ==
                                                      null
                                              ? Text("Not found")
                                              : Fluttertoast.showToast(
                                                  msg:
                                                      "${resultCon['errors']['email'].toString()}",
                                                  toastLength:
                                                      Toast.LENGTH_SHORT,
                                                  gravity: ToastGravity.CENTER,
                                                  timeInSecForIosWeb: 1,
                                                  backgroundColor: Colors.red,
                                                  textColor: Colors.white,
                                                  fontSize: 16.0);

                                          resultCon['errors']['password'] ==
                                                      "" ||
                                                  resultCon['errors']
                                                          ['password'] ==
                                                      null
                                              ? Text("Not found")
                                              : Fluttertoast.showToast(
                                                  msg:
                                                      "${resultCon['errors']['password'].toString()}",
                                                  toastLength:
                                                      Toast.LENGTH_SHORT,
                                                  gravity: ToastGravity.CENTER,
                                                  timeInSecForIosWeb: 1,
                                                  backgroundColor: Colors.red,
                                                  textColor: Colors.white,
                                                  fontSize: 16.0);

                                          _btnController.reset();
                                        } else {
                                          print("resultCon['token'] : " +
                                              resultCon['token'].toString());
                                          prefs.setString('app_token',
                                              resultCon['token'].toString());
                                          var response1 = await http.post(
                                              Uri.parse(
                                                  "https://books.sambiya.com/api/login?"
                                                  "app-token=${resultCon['token'].toString()}"),
                                              headers: {
                                                "Accept": "application/json",
                                              });
                                          print("response1.body after toke : " +
                                              response1.body.toString());
                                          var resultCon1 =
                                              json.decode(response1.body);
                                          if (resultCon1['is_client'] == true) {
                                            prefs.setString(
                                                'token', resultCon1['token']);
                                            /* get profile data */
                                            var response2 = await http.get(
                                                Uri.parse(
                                                    "https://books.sambiya.com/api/profile"),
                                                headers: {
                                                  "Accept": "application/json",
                                                  "Cookie":
                                                      'gate_token=${resultCon1['token'].toString()}'
                                                });
                                            //print("response2.tostring : " +response2.body.toString());
                                            /* ends here */
                                            var profile_person_data =
                                                json.decode(response2.body);

                                            print("User name : " +
                                                profile_person_data['data']
                                                        ['name']
                                                    .toString());

                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      user_dashboard(
                                                          profile_person_data[
                                                                      'data']
                                                                  ['name']
                                                              .toString(),
                                                          profile_person_data[
                                                                      'data']
                                                                  ['email']
                                                              .toString())),
                                            );
                                          } else {
                                            Fluttertoast.showToast(
                                                msg: "Enter valid credentials",
                                                toastLength: Toast.LENGTH_SHORT,
                                                gravity: ToastGravity.CENTER,
                                                timeInSecForIosWeb: 1,
                                                backgroundColor: Colors.red,
                                                textColor: Colors.white,
                                                fontSize: 16.0);
                                          }
                                        }

                                        /*
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => user_dashboard()),
                                );
                                */
                                        _btnController.reset();
                                      } else {
                                        _btnController.reset();
                                      }
                                    }
                                  }
                                })),
                        Padding(
                          padding: EdgeInsets.only(
                              top: MediaQuery.of(context).size.height * 0.01),
                          child: Center(
                            child: TextButton(
                              style: TextButton.styleFrom(
                                padding: const EdgeInsets.all(16.0),
                                primary: Colors.blue,
                                textStyle: const TextStyle(color: Colors.blue),
                              ),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => forgot_password()),
                                );
                              },
                              child: const Text('Forgot password'),
                            ),
                          ),
                        )
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
