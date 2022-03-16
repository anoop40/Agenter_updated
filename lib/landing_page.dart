import 'dart:convert';

import 'package:agenter_updated/sign_in_page.dart';
import 'package:agenter_updated/sign_up.dart';
import 'package:agenter_updated/user_dashboard.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'Color.dart';
class landing_page extends StatefulWidget{
  _landing_page createState() => _landing_page();
}
class _landing_page extends State<landing_page>{
  final RoundedLoadingButtonController _btnController = RoundedLoadingButtonController();
  final RoundedLoadingButtonController _btnController1 = RoundedLoadingButtonController();
  var _login_status = "no";
  var _name;
  var _email;
  late Future str;
  check_sesion() async {
    final prefs = await SharedPreferences.getInstance();
    if(prefs.containsKey('already_signed_up')){

      //prefs.setString('user_email', _email.text);
      //prefs.setString('user_password', _password.text);
      prefs.setString('already_signed_up', "yes");
      var response = await http.post(
          Uri.parse(
              "https://books.sambiya.com/id/login?"
                  "&email=${prefs.getString('user_email')}"
                  "&password=${prefs.getString('user_password')}"
                  "&app-id=books"
          ),
          headers: {
            "Accept": "application/json",
          });
      var resultCon = json.decode(response.body);

      if(resultCon['message'] == "The given data was invalid."){
        resultCon['errors']['email'] == "" || resultCon['errors']['email'] == null  ? Text("Not found") :

        Fluttertoast.showToast(
            msg: "${resultCon['errors']['email'].toString()}",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0
        );

        resultCon['errors']['password'] == "" || resultCon['errors']['password'] == null  ? Text("Not found") :

        Fluttertoast.showToast(
            msg: "${resultCon['errors']['password'].toString()}",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0
        );



        _btnController.reset();
      }
      else{
        print("resultCon['token'] : " +resultCon['token'].toString());
        prefs.setString('gate_token', resultCon['token'].toString());
        var response1 = await http.post(
            Uri.parse(
                "https://books.sambiya.com/api/login?"
                    "app-token=${resultCon['token'].toString()}"
            ),
            headers: {
              "Accept": "application/json",
            });

        var resultCon1 = json.decode(response1.body);
        if(resultCon1['is_client'] == true){
          prefs.setString('token', resultCon1['token']);
          /* get profile data */
          var response2 = await http.get(
              Uri.parse(
                  "https://books.sambiya.com/api/profile"
              ),
              headers: {
                "Accept": "application/json",
                "Cookie": 'gate_token=${resultCon1['token'].toString()}'
              });
          //print("response2.tostring : " +response2.body.toString());
          /* ends here */
          var profile_person_data = json.decode(response2.body);

          //print("User name 12 : "+profile_person_data['data']['name'].toString());

          setState(() {
            _login_status = "yes";
            _name = profile_person_data['data']['name'].toString();
            _email = profile_person_data['data']['email'].toString();
          });
          /*
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => user_dashboard(profile_person_data['data']['name'].toString(),profile_person_data['data']['email'].toString())),
          );
          */
        }
        else{
          Fluttertoast.showToast(
              msg: "Account not found",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0
          );
        }
      }

      /*
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => user_dashboard()),
                                );
                                */


    }
    return true;
  }
@override
  void initState() {
    super.initState();
    str = check_sesion();
  }
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: str,
      builder: (context,snapshot){
        if(snapshot.hasData){
          print("_login_status : " +_login_status.toString());
          if(_login_status == "no") {
            return Scaffold(
              body: SingleChildScrollView(
                child: Center(
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(top: MediaQuery
                            .of(context)
                            .size
                            .height * 0.2),
                        child: SizedBox(
                          width: MediaQuery
                              .of(context)
                              .size
                              .width * 0.53,
                          child: Image(
                              image: AssetImage('assets_files/logo.png')),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: MediaQuery
                            .of(context)
                            .size
                            .height * 0.03),
                        child: SizedBox(
                          width: MediaQuery
                              .of(context)
                              .size
                              .width * 0.53,
                          child: Image(image: AssetImage(
                              'assets_files/sign in_sign up_forgot password_business registration.png')),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: MediaQuery
                            .of(context)
                            .size
                            .height * 0.03),
                        child: Text("Track your books", style: TextStyle(
                            fontSize: 28, fontWeight: FontWeight.bold),),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: MediaQuery
                            .of(context)
                            .size
                            .height * 0.01),
                        child: Text(
                          "Manage invoices, bills, payments", style: TextStyle(
                          fontSize: 19,),),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: MediaQuery
                            .of(context)
                            .size
                            .height * 0.05),
                        child: RoundedLoadingButton(
                          color: HexColor("#092e60"),
                          child: Text('Create account',
                              style: TextStyle(color: Colors.white)),
                          controller: _btnController1,
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => sign_up()),
                            );
                            _btnController1.reset();
                          },
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: MediaQuery
                            .of(context)
                            .size
                            .height * 0.04),
                        child: RoundedLoadingButton(
                          color: HexColor("#07b690"),
                          child: Text(
                              'Sign in', style: TextStyle(color: Colors.white)),
                          controller: _btnController,
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => sign_in_page()),
                            );

                            _btnController.reset();
                          },
                        ),
                      ),

                    ],
                  ),
                ),
              ),
            );
          }
          else{
            print("else part 12");
            return user_dashboard(_name.toString(),_email.toString());
            /*
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => user_dashboard(_name.toString(),_email.toString())),
            );
            */
          }
        }
        else{
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
        return Text("");
      },
    );
  }
}