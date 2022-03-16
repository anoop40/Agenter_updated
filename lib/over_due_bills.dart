import 'package:flutter/material.dart';
class over_due_bills extends StatefulWidget{
  _over_due_bills createState() => _over_due_bills();
}
class _over_due_bills extends State<over_due_bills>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text("Overdue bills", style: TextStyle(color: Colors.black),),

      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                  border: Border(left: BorderSide(color: Colors.red,width: 11.00))
              ),
              child: Padding(
                padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.04),
                child: Column(
                  children: <Widget>[

                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.92,
                      child: Padding(
                        padding: EdgeInsets.only(left: 8.00),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text("ABC ltd", style: TextStyle(fontWeight: FontWeight.bold),),
                            Text("₹ 25,000.00",style: TextStyle(fontWeight: FontWeight.bold)),

                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.01,left: 8.00,right: 8.00),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.92,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text("Bill no : "),
                            Text("INV5676"),

                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.01,left: 8.00,right: 8.00),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.92,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text("Bill date : "),
                            Text("23/05/2021"),

                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.01,left: 8.00,right: 8.00),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.92,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text("Activity no : "),
                            Text("786789098"),

                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            Divider(),
            Container(
              decoration: BoxDecoration(
                  border: Border(left: BorderSide(color: Colors.red,width: 11.00))
              ),
              child: Padding(
                padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.04),
                child: Column(
                  children: <Widget>[

                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.92,
                      child: Padding(
                        padding: EdgeInsets.only(left: 8.00),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text("John", style: TextStyle(fontWeight: FontWeight.bold),),
                            Text("₹ 55,000.00",style: TextStyle(fontWeight: FontWeight.bold)),

                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.01,left: 8.00,right: 8.00),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.92,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text("Bill no : "),
                            Text("INV50986"),

                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.01,left: 8.00,right: 8.00),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.92,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text("Bill date : "),
                            Text("23/05/2021"),

                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.01,left: 8.00,right: 8.00),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.92,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text("Activity no : "),
                            Text("789765343"),

                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }
}