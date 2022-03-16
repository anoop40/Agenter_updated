import 'package:flutter/material.dart';
class cash_balance extends StatefulWidget{
  _cash_balance createState() => _cash_balance();
}
class _cash_balance extends State<cash_balance>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: TextField(
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: 'Search cash',
            prefixIcon: IconButton(
              onPressed: (){},
              icon: Icon(Icons.search),
            ),

          ),
        ),

      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.04),
              child: Container(
                width: MediaQuery.of(context).size.width * 0.9,
                child: Text("Cash balance", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 19),),
              ),
            ),
            Divider(),
            ListTile(
              title: Text("Cash"),
              trailing: Text("₹ -100.00"),

            ),
            Divider(),
            ListTile(
              title: Text("Petty cash"),
              trailing: Text("₹ 100.0"),

            ),
          ],
        ),
      ),
    );
  }
}