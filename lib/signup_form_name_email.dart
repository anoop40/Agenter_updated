import 'dart:convert';

import 'package:agenter_updated/signup_business_details.dart';
import 'package:country_list_pick/country_list_pick.dart';
import 'package:country_list_pick/country_selection_theme.dart';
import 'package:country_list_pick/support/code_country.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Color.dart';

class signup_form_name_email extends StatefulWidget {
  _signup_form_name_email createState() => _signup_form_name_email();
}

class _signup_form_name_email extends State<signup_form_name_email> {
  final _formKey = GlobalKey<FormState>();
  final _email = new TextEditingController();
  final _userName = new TextEditingController();
  final _mobile_number = new TextEditingController();
  final _password = new TextEditingController();
  late List _countries;
  late String _selected_country;
  late Future str;
  final RoundedLoadingButtonController _btnController =
      RoundedLoadingButtonController();
  String _country = "IN";
  List<DropdownMenuItem<String>> _countries_list = [
    DropdownMenuItem(child: Text("Select country"), value: "Select country"),
    DropdownMenuItem(child: Text("INDIA"), value: "IN"),
    DropdownMenuItem(child: Text("UAE"), value: "UAE"),
  ];

  bool isChecked = false;

  get_session_data() async {
    final prefs = await SharedPreferences.getInstance();
    _email.text = prefs.getString('user_email').toString();

    var serverUrlfinal = "https://books.sambiya.com/api/localization";

    var response1 = await http.get(Uri.parse(serverUrlfinal), headers: {
      "Accept": "application/json",
      "Cookie": 'gate_token=${prefs.getString('token').toString()}'
    });
    print("From server is : " + response1.body.toString());
    var res2 = json.decode(response1.body);
   // print("res2['data'][0]['country'] : " +res2['data'][0]['country'].toString());
    setState(() {
      _countries = res2['data'];
      _selected_country = res2['data'][0]['country'];
    });


    return true;
  }

  @override
  void initState() {
    super.initState();
    str = get_session_data();
  }

  @override
  Widget build(BuildContext context) {
    Color getColor(Set<MaterialState> states) {
      const Set<MaterialState> interactiveStates = <MaterialState>{
        MaterialState.pressed,
        MaterialState.hovered,
        MaterialState.focused,
      };
      if (states.any(interactiveStates.contains)) {
        return Colors.blue;
      }
      return Colors.white;
    }

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
                          top: MediaQuery.of(context).size.height * 0.12),
                      child: Image(image: AssetImage('assets_files/logo_white.png')),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 10.00),
                      child: Text(
                        "Create your agenter account",
                        style: TextStyle(color: Colors.white),
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
                              /*
                        Theme(
                          data: new ThemeData(
                              canvasColor: Colors.blue[900],
                              primaryColor: Colors.black,
                              hintColor: Colors.black),
                          child: DropdownButton<String>(
                              value: _country,
                              icon: const Icon(Icons.arrow_downward),
                              elevation: 16,
                              style: const TextStyle(color: Colors.white),
                              underline: Container(
                                height: 2,
                                color: Colors.white,
                              ),
                              onChanged: (String? newValue) {
                                setState(() {
                                  _country = newValue!;
                                });
                              },
                              items: _countries_list),
                        ),
                        */
                              // _load_country_picker(),
                              Container(

                                child: DropdownButtonFormField<String>(
                                  dropdownColor: Colors.black54,
                                  iconEnabledColor: Colors.white,

                                  hint: Text("Country", style: TextStyle(color: Colors.white),),
                                  isExpanded: true,
                                  value: _selected_country,
                                  icon: const Icon(Icons.arrow_downward),
                                  elevation: 16,
                                  decoration: InputDecoration(
                                    labelText: 'Country',
                                    contentPadding: EdgeInsets.only(bottom: 2.0),
                                  ),

                                  onChanged: (String? newValue) async {
                                    SharedPreferences prefs = await SharedPreferences.getInstance();
                                    setState(() {
                                      _selected_country = newValue!;
                                      _country = newValue;

                                    });
                                    //print("Selected curr : " + .toString());
                                  },
                                  items: _countries.map((item) {
                                    return new DropdownMenuItem(
                                      child: new Text(item['country'], style: TextStyle(color: Colors.white),),
                                      value: item['country'].toString(),
                                    );
                                  }).toList(),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                    top: MediaQuery.of(context).size.height * 0.03),
                                child: TextFormField(
                                  controller: _userName,
                                  style: TextStyle(color: Colors.white),
                                  decoration: InputDecoration(
                                    labelText: "Name",
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
                                    top: MediaQuery.of(context).size.height * 0.03),
                                child: TextFormField(
                                  controller: _email,
                                  style: TextStyle(color: Colors.white),
                                  decoration: InputDecoration(
                                    labelText: "Email",
                                    labelStyle: TextStyle(color: Colors.white),
                                    border: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          color: Colors.white, width: 2.0),
                                      borderRadius: BorderRadius.circular(25.0),
                                    ),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Enter a valid email';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                    top: MediaQuery.of(context).size.height * 0.03),
                                child: TextFormField(
                                  obscureText: true,
                                  controller: _password,
                                  style: TextStyle(color: Colors.white),
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
                                    top: MediaQuery.of(context).size.height * 0.03),
                                child: Row(
                                  children: <Widget>[
                                    Checkbox(
                                      checkColor: Colors.black,
                                      fillColor:
                                      MaterialStateProperty.resolveWith(getColor),
                                      value: isChecked,
                                      onChanged: (bool? value) {
                                        setState(() {
                                          isChecked = value!;
                                        });
                                      },
                                    ),
                                    Text(
                                      " I agree to the terms of service and privacy policy",
                                      style: TextStyle(color: Colors.white),
                                    )
                                  ],
                                ),
                              ),
                              Padding(
                                  padding: EdgeInsets.only(
                                      top: MediaQuery.of(context).size.height * 0.04),
                                  child: RoundedLoadingButton(
                                      child: Text('Create an account',
                                          style: TextStyle(color: Colors.white)),
                                      controller: _btnController,
                                      color: HexColor("#07b690"),
                                      onPressed: () async {
                                        if (_formKey.currentState!.validate()) {
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
                                            if (isChecked == false) {
                                              Fluttertoast.showToast(
                                                  msg:
                                                  "Please accept our terms and privacy policy",
                                                  toastLength: Toast.LENGTH_SHORT,
                                                  gravity: ToastGravity.CENTER,
                                                  timeInSecForIosWeb: 1,
                                                  backgroundColor: Colors.red,
                                                  textColor: Colors.white,
                                                  fontSize: 16.0);
                                              _btnController.reset();
                                            } else {
                                              showDialog(
                                                barrierDismissible: false,
                                                context: context,
                                                builder: (BuildContext context) {
                                                  return AlertDialog(
                                                      content: new Row(
                                                        children: [
                                                          CircularProgressIndicator(),
                                                          Container(
                                                              margin: EdgeInsets.only(
                                                                  left: 7),
                                                              child: Text(
                                                                  " Please wait...")),
                                                        ],
                                                      ));
                                                },
                                              );
                                              prefs.setString('country_selected',
                                                  _country.toString());
                                              var response1 = await http.post(
                                                  Uri.parse(
                                                      "https://books.sambiya.com/id/register"),
                                                  headers: {
                                                    "Accept": "application/json",
                                                  },
                                                  body: {
                                                    "type": "email",
                                                    "email": _email.text,
                                                    "display_name": _userName.text,
                                                    "password": _password.text,
                                                    "country": _country,
                                                    "app-id": "books"
                                                  });
                                              print("From server : " +
                                                  response1.body.toString());
                                              var resultCon1 =
                                              json.decode(response1.body);

                                              prefs.setString(
                                                  'app-token-from-register',
                                                  resultCon1['token'].toString());
                                              prefs.setString(
                                                  'user_email', _email.text);

                                              if (resultCon1['token'] == null) {
                                                Fluttertoast.showToast(
                                                    msg: resultCon1['message']
                                                        .toString(),
                                                    toastLength: Toast.LENGTH_SHORT,
                                                    gravity: ToastGravity.CENTER,
                                                    timeInSecForIosWeb: 1,
                                                    backgroundColor: Colors.red,
                                                    textColor: Colors.white,
                                                    fontSize: 16.0);
                                                _btnController.reset();
                                                Navigator.pop(context);
                                              } else {
                                                /*
                                          Fluttertoast.showToast(
                                              msg: resultCon1['message']
                                                  .toString(),
                                              toastLength: Toast.LENGTH_SHORT,
                                              gravity: ToastGravity.CENTER,
                                              timeInSecForIosWeb: 1,
                                              backgroundColor: Colors.red,
                                              textColor: Colors.white,
                                              fontSize: 16.0);
                                          */

                                                _btnController.reset();
                                                Navigator.pop(context);

                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            signup_business_details()));
                                                /*
                                        if(resultCon2['ttl'] == 84600) {
                                          _btnController.reset();
                                          Navigator.pop(context);

                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      signup_business_details()));
                                        }
                                        */

                                              }
                                            }
                                          }
                                        } else {
                                          _btnController.reset();
                                        }
                                      })),
                              Padding(
                                padding: EdgeInsets.only(
                                    top: MediaQuery.of(context).size.height * 0.01),
                                child: Center(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Text(
                                        "Already have an account ?",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      TextButton(
                                        style: TextButton.styleFrom(
                                          padding: const EdgeInsets.all(16.0),
                                          primary: Colors.blue,
                                          textStyle:
                                          const TextStyle(color: Colors.blue),
                                        ),
                                        onPressed: () {},
                                        child: const Text('Sign in'),
                                      )
                                    ],
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
  }
}
