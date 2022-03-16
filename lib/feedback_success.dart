import 'package:flutter/material.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
class feedback_success extends StatefulWidget{
  _feedback_success createState() => _feedback_success();
}
class _feedback_success extends State<feedback_success>{
  final RoundedLoadingButtonController _btnController = RoundedLoadingButtonController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(
            color: Colors.black, //change your color here
          ),
          title : Text("Success", style: TextStyle(color: Colors.black),),
        ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.25),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.2,
                  child: Image(image: AssetImage('assets_files/sucess.png')),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.03),
                child: Text("Thank you for your feedback", style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),),
              ),
              Padding(
                padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.03),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: Text("We will review the feedback and look forward to implement it",),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.06),
                child: RoundedLoadingButton(
                    color: Colors.blue[900],
                    borderRadius: 6.00,
                    width: MediaQuery.of(context).size.width * 0.3,
                    child: Text('Done', style: TextStyle(color: Colors.white)),
                    controller: _btnController,
                    onPressed: () async {
                      Navigator.pop(context);
                      Navigator.pop(context);
                    }),
              )
            ],
          ),
        ),
      ),
    );
  }
}