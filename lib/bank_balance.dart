import 'package:flutter/material.dart';
class bank_balance extends StatefulWidget{
  _bank_balance createState() => _bank_balance();
}
class _bank_balance extends State<bank_balance>{
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
            hintText: 'Search bank',
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
                child: Text("Bank balance", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 19),),
              ),
            ),
            Divider(),
            ListTile(
              title: Text("Federal bank"),
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