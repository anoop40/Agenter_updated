
import 'package:agenter_updated/user_dashboard.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class success_page_for_company_details_update extends StatefulWidget {
  _success_page_for_company_details_update createState() =>
      _success_page_for_company_details_update();
}

class _success_page_for_company_details_update
    extends State<success_page_for_company_details_update> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.4),
              child: Icon(
                Icons.check_circle_outline,
                size: MediaQuery.of(context).size.width * 0.26,
                color: Colors.green,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.02),
              child: Text(
                "Thank you for your time",
                style: TextStyle(fontSize: 19),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.01),
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.8,
                child: Text(
                  "Your company setup is complete. Now you can add and view the company data",
                  style: TextStyle(
                    height: 1.6,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.03),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.blue[900]
                ),
                onPressed: () async {
                  SharedPreferences prefs = await SharedPreferences.getInstance();
                  Navigator.pop(context);
                  Navigator.pop(context);
                  Navigator.pop(context);
                  Navigator.pop(context);
                  Navigator.pop(context);
                  Navigator.pop(context);
                  Navigator.pop(context);

                  Navigator.push(
                    context,
                    //MaterialPageRoute(builder: (context) => user_dashboard(profile_person_data['data']['name'].toString(),profile_person_data['data']['email'].toString())),
                    MaterialPageRoute(builder: (context) => user_dashboard(prefs.getString('username'),prefs.getString('user_email'))),
                  );

                },
                child: Text("DASH BOARD"),
              ),
            )
          ],
        ),
      ),
    );
  }
}
