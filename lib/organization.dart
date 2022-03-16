import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import 'feedback_success.dart';
class organization extends StatefulWidget{
  _organization createState() => _organization();
}
class _organization extends State<organization>{

  final message = new TextEditingController();
  late Future str;
  final _business_name = new TextEditingController();
  final _email = new TextEditingController();
  final _country = new TextEditingController();
  final _state_union = new TextEditingController();
  final _street1 = new TextEditingController();
  final _street2 = new TextEditingController();
  final _city = new TextEditingController();
  final _zipcode = new TextEditingController();
  final _timezone = new TextEditingController();
  final _currency = new TextEditingController();
  final _formKey = GlobalKey<FormState>();
  var _timezoneVari;
  var _company_id;
  late List _countries;
  late List _states_list;
  late String _selected_country;
  late String _selected_state;
  final _currency_selected = new TextEditingController();
  get_data() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var response = await http.get(
        Uri.parse(
            "https://books.sambiya.com/api/company"
        ),
        headers: {
          "Accept": "application/json",
          "Cookie": 'gate_token=${prefs.getString('token').toString()}'
        },


    );
    var records = json.decode(response.body);
   // print("records['data'][0]['id'].toString() : " +records['data'][0]['id'].toString());
    setState(() {
      _business_name.text = records['data'][0]['name'].toString();
      _email.text = records['data'][0]['email'].toString();
      _country.text = records['data'][0]['country'].toString();
      _selected_state = records['data'][0]['state'].toString();
      _street1.text = records['data'][0]['street1'].toString();
      _street2.text = records['data'][0]['street2'].toString();
      _city.text = records['data'][0]['city'].toString();
      _zipcode.text = records['data'][0]['zipcode'].toString();
      _timezone.text = records['data'][0]['timezone'].toString();
      _timezoneVari = records['data'][0]['timezone'].toString();
      _currency.text = records['data'][0]['currency'].toString();
      _company_id = records['data'][0]['id'].toString();
      _selected_country = records['data'][0]['country'].toString();
      _currency.text = records['data'][0]['currency_precision'].toString();
    });
    print("company currency id is : " +records['data'][0]['currency_precision'].toString());

    var serverUrlfinal = "https://books.sambiya.com/api/location/countries";

    var response1 = await http.get(Uri.parse(serverUrlfinal), headers: {
      "Accept": "application/json",
      "Cookie": 'gate_token=${prefs.getString('token').toString()}'
    });
    var res2 = json.decode(response1.body);
    setState(() {
      _countries = res2['data'];
    });

    var serverUrlfinal3 = "https://books.sambiya.com/api/location/states/${records['data'][0]['country'].toString()}";

    var response3 = await http.get(Uri.parse(serverUrlfinal3), headers: {
      "Accept": "application/json",
      "Cookie": 'gate_token=${prefs.getString('token').toString()}'
    });
    print("States : " +response3.body.toString());
    var res3 = json.decode(response3.body);
    setState(() {
      _states_list = res3['data'];
      _selected_state = res3['data'][0]['id'];
    });

    var serverUrlfinal4 = "https://books.sambiya.com/api/location/states/${records['data'][0]['country'].toString()}";

    var response4 = await http.get(Uri.parse(serverUrlfinal4), headers: {
      "Accept": "application/json",
      "Cookie": 'gate_token=${prefs.getString('token').toString()}'
    });
    var res4 = json.decode(response4.body);
    setState(() {
      _states_list = res4['data'];
      _selected_state = res4['data'][0]['id'];
    });


    return true;
  }
  change_country(var country_selected) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var serverUrlfinal3 = "https://books.sambiya.com/api/location/states/${country_selected}";

    var response3 = await http.get(Uri.parse(serverUrlfinal3), headers: {
      "Accept": "application/json",
      "Cookie": 'gate_token=${prefs.getString('token').toString()}'
    });
    print("States : " +response3.body.toString());
    var res3 = json.decode(response3.body);
    setState(() {
      _states_list = res3['data'];

    });
  }
  @override
  void initState() {
    super.initState();
    str = get_data();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(
          color: Colors.black, //change your color here
        ),
        title : Text("Organization", style: TextStyle(color: Colors.black),),
        actions: [
          TextButton(
            style: TextButton.styleFrom(
              textStyle: const TextStyle(fontSize: 20),
            ),
            onPressed: () async {
              if (_formKey.currentState!.validate()) {


                showDialog(barrierDismissible: false,
                  context:context,
                  builder:(BuildContext context){
                    return AlertDialog(
                      content: new Row(
                        children: [
                          CircularProgressIndicator(),
                          Container(margin: EdgeInsets.only(left: 7),child:Text(" Updating...")),
                        ],),
                    );
                  },
                );
                SharedPreferences prefs = await SharedPreferences.getInstance();
                print("_company_id :  " + _company_id.toString());
                var response = await http.put(
                  Uri.parse(
                      "https://books.sambiya.com/api/company/${_company_id}"
                  ),
                  headers: {
                    "Accept": "application/json",
                    "Cookie": 'gate_token=${prefs.getString('token').toString()}'
                  },
                  body: {
                    'email' : _email.text,
                    'name' : _business_name.text,
                    'timezone' : _timezoneVari,
                    'state' : _selected_state,
                    'street1' : _street1.text,
                    'street2' : _street2.text,
                    'city' : _city.text,
                    'zipcode' : _zipcode.text,
                  }


                );
                print("response body : " + response.body.toString());
                var res4 = json.decode(response.body);
                if(res4['success'] == true){
                  Navigator.pop(context);
                  Fluttertoast.showToast(
                      msg: "Successfully updated",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.CENTER,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.green,
                      textColor: Colors.white,
                      fontSize: 16.0
                  );
                }
              }
            },
            child: const Text('Save', style: TextStyle(fontSize: 15),),
          )
        ],
      ),
      body: FutureBuilder(
        future: str,
        builder: (context,snapshot){
          if(snapshot.hasData){
            return SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Center(
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.04),
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width * 0.9,
                            child: TextFormField(

                              controller: _business_name,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter some text';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                  border: new OutlineInputBorder(),
                                  hintText: "Business name",
                                  label: Text("Business name")
                              ),

                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.04),
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width * 0.9,
                            child: TextFormField(
                              controller: _email,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter some text';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                  border: new OutlineInputBorder(),
                                  hintText: "Business email",
                                  label: Text("Business email")
                              ),

                            ),
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.9,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.04),
                                child: SizedBox(
                                  width: MediaQuery.of(context).size.width * 0.4,
                                  /*
                            child: TextFormField(
                              readOnly: true,
                              controller: _country,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter some text';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                border: new OutlineInputBorder(),
                                hintText: "Choose country",
                                label: Text("Choose country"),
                              ),

                            ),
                            */
                                  child: DropdownButtonFormField<String>(
                                    hint: Text("Country"),
                                    isExpanded: true,
                                    value: _selected_country,
                                    icon: const Icon(Icons.arrow_downward),
                                    elevation: 16,
                                    decoration: InputDecoration(
                                      labelText: 'Country',
                                      contentPadding: EdgeInsets.only(bottom: 2.0)
                                    ),

                                    onChanged: (String? newValue) {
                                      setState(() {
                                        _selected_country = newValue!;
                                        change_country(newValue!);
                                      });
                                    },
                                    items: _countries.map((item) {
                                      return new DropdownMenuItem(
                                        child: new Text(item['title']),
                                        value: item['id'].toString(),
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.04),
                                child: SizedBox(
                                  width: MediaQuery.of(context).size.width * 0.4,
                                  /*
                            child: TextFormField(
                              readOnly: true,
                              controller: _country,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter some text';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                border: new OutlineInputBorder(),
                                hintText: "Choose country",
                                label: Text("Choose country"),
                              ),

                            ),
                            */
                                  child: DropdownButtonFormField<String>(
                                    isExpanded: true,
                                    value: _selected_state,
                                    icon: const Icon(Icons.arrow_downward),
                                    elevation: 16,
                                    style: const TextStyle(color: Colors.deepPurple),
                                    decoration: InputDecoration(
                                        labelText: 'State',
                                        contentPadding: EdgeInsets.only(bottom: 2.0)
                                    ),
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        _selected_state = newValue!;
                                      });
                                    },
                                    items: _states_list.map((item) {
                                      return new DropdownMenuItem(
                                        child: new Text(item['title']),
                                        value: item['id'].toString(),
                                      );
                                    }).toList(),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        /*
                        Padding(
                          padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.04),
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width * 0.9,
                            child: TextFormField(
                              controller: _state_union,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter some text';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                border: new OutlineInputBorder(),
                                hintText: "State/Union/Territory",
                                label: Text("State/Union/Territory"),
                              ),

                            ),
                          ),
                        ),
                        */
                        Padding(
                          padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.04),
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width * 0.9,
                            child: TextFormField(
                              readOnly: true,
                              controller: _currency_selected,

                              decoration: InputDecoration(
                                border: new OutlineInputBorder(),
                                hintText: "Currency",
                              ),

                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.04),
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width * 0.9,
                            child: const Text("BUSINESS ADDRESS"),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.02),
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width * 0.9,
                            child: TextFormField(
                              controller: _street1,

                              decoration: InputDecoration(
                                border: new OutlineInputBorder(),
                                hintText: "Street 1",
                                label: Text("Street 1"),
                              ),

                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.02),
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width * 0.9,
                            child: TextFormField(
                              controller: _street2,

                              decoration: InputDecoration(
                                border: new OutlineInputBorder(),
                                hintText: "Street 2",
                                label: Text("Street 2"),
                              ),

                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.02),
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width * 0.9,
                            child: TextFormField(
                              controller: _city,

                              decoration: InputDecoration(
                                border: new OutlineInputBorder(),
                                hintText: "City",
                                label: Text("City"),
                              ),

                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.02),
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width * 0.9,
                            child: TextFormField(
                              controller: _zipcode,

                              decoration: InputDecoration(
                                border: new OutlineInputBorder(),
                                hintText: "ZipCode",
                                label: Text("ZipCode"),
                              ),

                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.02),
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width * 0.9,
                            child: TextFormField(
                              controller: _timezone,

                              decoration: InputDecoration(
                                border: new OutlineInputBorder(),
                                hintText: "Time zone",
                                label: Text("Time zone"),
                              ),

                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.02, bottom: MediaQuery.of(context).size.height * 0.04),
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width * 0.9,
                            child: TextFormField(
                              readOnly: true,
                              controller: _currency,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter some text';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                border: new OutlineInputBorder(),
                                hintText: "Currency",
                                label: Text("Currency"),
                              ),

                            ),
                          ),
                        ),

                      ],
                    )
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