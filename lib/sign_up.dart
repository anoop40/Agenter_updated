import 'package:agenter_updated/signup_form_name_email.dart';
import 'package:flutter/material.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'Color.dart';

class sign_up extends StatefulWidget {
  _sign_up createState() => _sign_up();
}

class _sign_up extends State<sign_up> {
  final _formKey = GlobalKey<FormState>();
  final _email = new TextEditingController();
  final RoundedLoadingButtonController _btnController =
      RoundedLoadingButtonController();

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
                        TextFormField(
                          controller: _email,
                          style: TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            labelText: "Email or phone number",
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
                        Padding(
                            padding: EdgeInsets.only(
                                top: MediaQuery.of(context).size.height * 0.04),
                            child: RoundedLoadingButton(
                                child: Text('Get start',
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
                                    print("_email.text : " +
                                        _email.text.toString());
                                    if (_formKey.currentState!.validate()) {
                                      prefs.setString(
                                          'user_email', _email.text);
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                signup_form_name_email()),
                                      );
                                      _btnController.reset();
                                    } else {
                                      _btnController.reset();
                                    }
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
      ),
    );
  }
}
