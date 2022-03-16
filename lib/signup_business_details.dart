import 'dart:convert';

import 'package:agenter_updated/roll_update.dart';
import 'package:currency_picker/currency_picker.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'accordition.dart';

class signup_business_details extends StatefulWidget {
  _signup_business_details createState() => _signup_business_details();
}

class _signup_business_details extends State<signup_business_details> {
  final _formKey = GlobalKey<FormState>();
  final RoundedLoadingButtonController _btnController =
      RoundedLoadingButtonController();
  bool _business_registered_for_gst = false;
  bool _agree_terms_and = false;
  String _currency = "Select currency";
  String _time_zone = "Select time zone";
  final _business_name = new TextEditingController();
  final _business_email = new TextEditingController();
  final _business_address1 = new TextEditingController();
  final _business_address2 = new TextEditingController();
  final _business_city = new TextEditingController();
  final _business_zip = new TextEditingController();
  final _business_country = new TextEditingController();
  final _business_timezone = new TextEditingController();
  final _curr_sel = new TextEditingController();
  String _state_union = "Select state/union/territory";
  String _country = "Select country";
  late String countryValue;
  late String stateValue;
  late String cityValue;
  late String _gst_number = "0";
  String dropdownValue = "Asia/Kolkata";
  late List _states  ;
  late String _selected_state;
  //final _state_selected = new TextEditingController();
  List<String> drop_down_array = ['Select state/union/territory'];

  var _gst_or_vat_number_field;
  var _currency_selected;
  var _time_zone_selected;
  var _tax_enabled = 0;
  var _tax_name;

  List<DropdownMenuItem<String>> _countries_list = [
    DropdownMenuItem(child: Text("Select country"), value: "Select country"),
    DropdownMenuItem(child: Text("INDIA"), value: "IN"),
    DropdownMenuItem(child: Text("UAE"), value: "UAE"),
  ];
  var _selected_currency = "Not selected";
  late Future str;

  get_session_data() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      countryValue = prefs.getString('country_selected')!;
    });
    print("Country selectd : " + countryValue.toString());

    var serverUrlfinal = "https://books.sambiya.com/api/location/states/${countryValue.toString()}";

    var response = await http.get(Uri.parse(serverUrlfinal), headers: {
      "Accept": "application/json",
      "Cookie": 'gate_token=${prefs.getString('token').toString()}'
    });
    var res = json.decode(response.body);
    setState(() {
      _states = res['data'];
      _selected_state = _states[0]['id'];
      _business_email.text = prefs.getString('user_email').toString();
    });

    var serverUrlfinal1 = "https://books.sambiya.com/api/localization/${countryValue.toString()}";

    var response2 = await http.get(Uri.parse(serverUrlfinal1), headers: {
      "Accept": "application/json",
      "Cookie": 'gate_token=${prefs.getString('token').toString()}'
    });
    print("From server is localization : " + response2.body.toString());
    var res2 = json.decode(response2.body);

    //print("currency selected : " +res2['data']['currency'].toString());
    setState(() {
      _curr_sel.text = res2['data']['currency'].toString();
      _business_timezone.text = res2['data']['timezone'].toString();

    });

    return true;
  }

  @override
  void initState() {
    super.initState();
    str = get_session_data();
    _gst_or_vat_number_field = Text("");
  }
  load_gst_text_field(){
    return Center(
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.9,
        child : TextFormField(
          decoration: InputDecoration(
            label: Text("GST number"),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter some text';
            }
            return null;
          },
          controller: _business_zip,
        ),
      ),
    );
  }
  load_vat_text_field(){
    return Center(
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.9,
        child : TextFormField(
          decoration: InputDecoration(
            label: Text("VAT number"),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter some text';
            }
            return null;
          },
          controller: _business_zip,
        ),
      ),
    );
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
      return Colors.black;
    }




    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0.0,
        iconTheme: IconThemeData(
          color: Colors.black, //change your color here
        ),
        backgroundColor: Colors.white,
        title: Text(
          "Back",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: FutureBuilder(
        future: str,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height * 0.02,
                          left: MediaQuery.of(context).size.width * 0.06),
                      child: Text(
                        "BUSINESS DETAILS",
                        style: TextStyle(fontSize: 18, color: Colors.blue[800]),
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.9,
                      child: Padding(
                        padding: EdgeInsets.only(
                            left: MediaQuery.of(context).size.width * 0.06,
                            top: MediaQuery.of(context).size.height * 0.01),
                        child: TextFormField(
                          controller: _business_name,
                          decoration: InputDecoration(
                            label: Text("Business name"),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter some text';
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.9,
                      child: Padding(
                        padding: EdgeInsets.only(
                            left: MediaQuery.of(context).size.width * 0.06,
                            top: MediaQuery.of(context).size.height * 0.01),
                        child: TextFormField(
                          controller: _business_email,
                          decoration: InputDecoration(
                            label: Text("Business email"),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter some text';
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.9,
                      child: Padding(
                        padding: EdgeInsets.only(
                            left: MediaQuery.of(context).size.width * 0.06,
                            top: MediaQuery.of(context).size.height * 0.01),
                        child: TextFormField(
                          readOnly: true,
                          controller: _curr_sel,
                          decoration: InputDecoration(
                            label: Text("Currency"),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter some text';
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.9,
                      child: Padding(
                        padding: EdgeInsets.only(
                            left: MediaQuery.of(context).size.width * 0.06,
                            top: MediaQuery.of(context).size.height * 0.01),
                        child: TextFormField(
                          readOnly: true,
                          controller: _business_timezone,
                          decoration: InputDecoration(
                            label: Text("Time zone"),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter some text';
                            }
                            return null;
                          },
                        ),
                      ),
                    ),

                    Padding(
                      padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.03, left: MediaQuery.of(context).size.height * 0.03),
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.8,
                        child: DropdownButtonFormField<String>(
                          isExpanded: true,
                          value: _selected_state,
                          icon: const Icon(Icons.arrow_downward),
                          elevation: 16,
                          style: const TextStyle(color: Colors.deepPurple),
                          decoration: InputDecoration(
                              labelText: 'State / Region',
                              contentPadding: EdgeInsets.only(bottom: 2.0)
                          ),
                          onChanged: (String? newValue) {
                            setState(() {
                              _selected_state = newValue!;
                            });
                          },
                          items: _states.map((item) {
                            return new DropdownMenuItem(
                              child: new Text(item['title']),
                              value: item['id'].toString(),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                    _gst_or_vat_number_field,
                    /*
                    Center(
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.9,
                        child : TextFormField(
                          decoration: InputDecoration(
                            label: Text("GST"),
                          ),
                          controller: _business_zip,
                        ),
                      ),
                    )
                     */
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.9,
                      child: Accordion(
                        title: 'Add business address',
                        content: Column(
                          children: <Widget>[
                            TextFormField(
                              decoration: InputDecoration(
                                label: Text("Address 1"),
                              ),
                              controller: _business_address1,
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  top: MediaQuery.of(context).size.height *
                                      0.01),
                              child: TextFormField(
                                decoration: InputDecoration(
                                  label: Text("Address 2"),
                                ),
                                controller: _business_address2,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  top: MediaQuery.of(context).size.height *
                                      0.01),
                              child: TextFormField(
                                decoration: InputDecoration(
                                  label: Text("City"),
                                ),
                                controller: _business_city,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  top: MediaQuery.of(context).size.height *
                                      0.01),
                              child: TextFormField(
                                decoration: InputDecoration(
                                  label: Text("Zip code"),
                                ),
                                controller: _business_zip,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    countryValue.toString() == "IN"
                        ? Padding(
                      padding: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height * 0.03),
                      child: Row(
                        children: <Widget>[
                          Checkbox(
                            checkColor: Colors.white,
                            fillColor: MaterialStateProperty.resolveWith(
                                getColor),
                            value: _business_registered_for_gst,
                            onChanged: (bool? value) {
                              value == true ? _gst_or_vat_number_field = load_gst_text_field() : 
                              _gst_or_vat_number_field = Text("");
                              setState(() {
                                _business_registered_for_gst = value!;

                              });
                            },
                          ),
                          Text(
                            " This business is registered for GST",
                            style: TextStyle(color: Colors.black),
                          )
                        ],
                      ),
                    )
                        : Padding(
                      padding: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height * 0.03),
                      child: Row(
                        children: <Widget>[
                          Checkbox(
                            checkColor: Colors.white,
                            fillColor: MaterialStateProperty.resolveWith(
                                getColor),
                            value: _business_registered_for_gst,
                            onChanged: (bool? value) {
                              value == true ?  _gst_or_vat_number_field = load_vat_text_field() : _gst_or_vat_number_field = Text("");
                              setState(() {
                                _business_registered_for_gst = value!;
                              });
                            },
                          ),
                          Text(
                            " This business is registered for VAT",
                            style: TextStyle(color: Colors.black),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height * 0.01,
                          bottom: MediaQuery.of(context).size.height * 0.04),
                      child: Row(
                        children: <Widget>[
                          Checkbox(
                            checkColor: Colors.white,
                            fillColor:
                                MaterialStateProperty.resolveWith(getColor),
                            value: _agree_terms_and,
                            onChanged: (bool? value) {
                              setState(() {
                                _agree_terms_and = value!;
                              });
                            },
                          ),
                          Text(
                            " I agree to the terms of service and privacy policy",
                            style: TextStyle(color: Colors.black),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              /*
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.02, left: MediaQuery.of(context).size.width * 0.06),
              child: Text("BUSINESS DETAILS", style: TextStyle(fontSize: 18, color: Colors.blue[800]),),
            ),

          ],
        ),
        */
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
      bottomNavigationBar: RoundedLoadingButton(
        width: MediaQuery.of(context).size.width,
        color: Colors.blue[800],
        borderRadius: 1.00,
        child: Text('GET STARTED', style: TextStyle(color: Colors.white)),
        controller: _btnController,
        onPressed: () async {
          if (_formKey.currentState!.validate()) {

            if (_agree_terms_and == false) {
              Fluttertoast.showToast(
                  msg: "Please accept terms and conditions",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.CENTER,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.red,
                  textColor: Colors.white,
                  fontSize: 16.0);
              _btnController.reset();
            } else {
              _btnController.reset();
              SharedPreferences prefs = await SharedPreferences.getInstance();
              print("name : " +_business_name.text +
                  "country :"+ countryValue.toString()+
          "currency : "+ _curr_sel.text +
          "timezone :" + _business_timezone.text+
          "state : " +_selected_state +
          "street1 : "+ _business_address1.text+
          "street2 : "+ _business_address2.text+
          "city : "+_business_city.text+
          "zipcode :"+ _business_zip.text +
          'service_name : book-keeping'
          'tax_enabled : '+ _tax_enabled.toString()+
          'tax_number : '+ _gst_number
              );
              //print("selected curen : " + _currency.toString());

              var serverUrlfinal = "https://books.sambiya.com/api/register";
              var response = await http.post(Uri.parse(serverUrlfinal), body: {
                "app-token":prefs.getString('app-token-from-register').toString(),
                "name": _business_name.text,
                "country": countryValue.toString(),
                "currency": _curr_sel.text,
                "timezone": _business_timezone.text,
                "state": _selected_state,
                "street1": _business_address1.text,
                "street2": _business_address2.text,
                "city": _business_city.text,
                "zipcode": _business_zip.text,
                'service_name': 'book-keeping',
                'tax_enabled' : _tax_enabled,
                'tax_number' : _gst_number,
              }, headers: {
                "Accept": "application/json",
              });

            print(response.body.toString());
              var received_data = json.decode(response.body);
              if (received_data['success'] == true) {

                prefs.setString(
                    'after_regi_token', received_data['token'].toString());
                prefs.setString('username', _business_name.text);

                /*
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => success_page_for_company_details_update()),
                );

               */
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => roll_update()),
                );
              } else {
                Fluttertoast.showToast(
                    msg: received_data['message'].toString(),
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.CENTER,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.red,
                    textColor: Colors.white,
                    fontSize: 16.0);
              }

              _btnController.reset();
            }
          } else {
            _btnController.reset();
          }
        },
      ),
    );
  }
}
