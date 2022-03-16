import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
class bank_details extends StatefulWidget{
  _bank_details createState() => _bank_details();
}
class _bank_details extends State<bank_details>{
  final _account_name = new TextEditingController();
  final _formKey = GlobalKey<FormState>();
  late Future str;
  var details_all;
  final _account_number = new TextEditingController();
  final _bank_name = new TextEditingController();
  final _branch_name = new TextEditingController();
  final _branch_code = new TextEditingController();
  getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    var serverUrlfinal = "https://books.sambiya.com/book-keeping/banking/account";

    var response = await http.get(Uri.parse(serverUrlfinal), headers: {
      "Accept": "application/json",
      "Cookie": 'gate_token=${prefs.getString('token').toString()}'
    });
    print("welcome all");
    print("Response body12 : " + response.body.toString());
    setState(() {
      details_all = json.decode(response.body) ;
      _account_name.text = details_all['data'][0]['account_name'].toString();
      _account_number.text = details_all['data'][0]['account_number'].toString();
      _bank_name.text = details_all['data'][0]['bank_name'].toString();
      _branch_name.text = details_all['data'][0]['branch_name'].toString();
      _branch_code.text = details_all['data'][0]['ifsc'].toString();
    });
    return true;

  }
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
          return Padding(
            padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.03),
            child: Form(
              key: _formKey,
              child: Column(

                children: <Widget>[
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.9,
                    child: TextField(
        controller: _account_name,
                      decoration: InputDecoration(
                          label: Text("Account name")
                      ),

                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.02),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.9,
                      child: TextField(
controller: _account_number,
                        decoration: InputDecoration(
                            label: Text("Account number")
                        ),

                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.02),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.9,
                      child: TextField(
controller: _bank_name,
                        decoration: InputDecoration(
                            hintText: 'Enter a search term',
                            label: Text("Bank name")
                        ),

                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.02),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.9,
                      child: TextField(
controller: _branch_name,
                        decoration: InputDecoration(
                            hintText: 'Enter a search term',
                            label: Text("Branch name")
                        ),

                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.02),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.9,
                      child: TextField(
controller: _branch_code,
                        decoration: InputDecoration(
                            hintText: 'Enter a search term',
                            label: Text("Bank/Branch code")
                        ),

                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.04),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.9,
                      child: ElevatedButton(
                        onPressed: () async {

                          SharedPreferences prefs = await SharedPreferences.getInstance();

                          var serverUrlfinal = "https://books.sambiya.com/book-keeping/banking/account";

                          var response = await http.post(Uri.parse(serverUrlfinal),
                            body: {
                            'account_name' : _account_name.text,
                              'bank_name' : _bank_name.text,
                              'branch_name' : _branch_name.text,
                              'ifsc' : _branch_code.text,
                              'account_number' : _account_number.text
                            },

                            headers: {
                            "Accept": "application/json",
                            "Cookie": 'gate_token=${prefs.getString('token').toString()}'
                          },

                          );
                          print("welcome all");
                          print("Response body12 : " + response.body.toString());
                          var resp_da = json.decode(response.body) ;
                          print("resp_da['data']['id'].toString() : " +resp_da['data']['id'].toString());
                          if(resp_da['data']['id'].toString().isNotEmpty){
                            Fluttertoast.showToast(
                                msg: "Successfully updated",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.CENTER,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.red,
                                textColor: Colors.white,
                                fontSize: 16.0
                            );
                          }
                        },
                        child: Text("UPDATE"),
                      ),
                    ),
                  )
                ],
              ),
            ),
            /*
      child: Column(
        children: <Widget>[
          TextField(

            decoration: InputDecoration(
                hintText: 'Enter a search term',
                label: Text("Account name")
            ),

          ),
        ],
      ),
      */
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