
import 'package:agenter_updated/profit_and_loss_listing.dart';
import 'package:agenter_updated/trial_balance.dart';
import 'package:agenter_updated/vendor_summery.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import 'balance_sheet.dart';
import 'customer_summery.dart';
import 'day_book.dart';
import 'ledgers.dart';
class reports extends StatefulWidget{
  _reports createState() => _reports();
}
class _reports extends State<reports>{
  String dropdownValue = '1-Apr-2020 to 1-May-2021';

  @override
  Widget build(BuildContext context) {
    return Scaffold(


      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            ListTile(
              title: Text("Profit & loss statement"),
              trailing: Icon(Icons.navigate_next),
              onTap: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => profit_and_loss_listing()),
                );
              },
            ),
            Divider(),
            ListTile(
              title: Text("Balance sheet"),
              trailing: Icon(Icons.navigate_next),
              onTap: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => balance_sheet()),
                );
              },
            ),
            Divider(),
            ListTile(
              title: Text("Day book"),
              trailing: Icon(Icons.navigate_next),
              onTap: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => day_book()),
                );
              },
            ),
            Divider(),
            ListTile(
              title: Text("Customer summery"),
              trailing: Icon(Icons.navigate_next),
              onTap: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => customer_summery()),
                );
              },
            ),
            Divider(),
            ListTile(
              title: Text("Vendor summery"),
              trailing: Icon(Icons.navigate_next),
              onTap: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => vendor_summery()),
                );
              },
            ),
            Divider(),
            ListTile(
              title: Text("Trial balance"),
              trailing: Icon(Icons.navigate_next),
              onTap: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => trial_balance()),
                );
              },
            ),
            Divider(),
            ListTile(
              title: Text("Ledgers"),
              trailing: Icon(Icons.navigate_next),
              onTap: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ledgers()),
                );
              },
            ),
            Divider(),
          ],
        ),
      ),
    );
  }
}