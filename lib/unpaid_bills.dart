import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
class unpaid_bills extends StatefulWidget{
  _unpaid_bills createState() => _unpaid_bills();
}
class _unpaid_bills extends State<unpaid_bills>{
  String dropdownValue = '1-Apr-2020 to 1-May-2021';

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text("Unpaid bills", style: TextStyle(color: Colors.black),),

      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width * 0.94,
              child: Padding(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.02),
                child: ListTile(


                  title: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.3,
                    child: GestureDetector(
                      onTap: () async {

                      },
                      child: Text("01 March 2018 - 01 April 2018"),
                    ),

                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.list_alt_sharp),
                    onPressed: (){
                      showModalBottomSheet<void>(
                        context: context,
                        builder: (BuildContext context) {
                          return Container(
                            height: 900,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Container(
                                  width: MediaQuery.of(context).size.width * 0.8,

                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text("Date Range", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 19),),
                                      ElevatedButton(

                                        child: const Text('Cancel'),
                                        onPressed: () => Navigator.pop(context),
                                      )
                                    ],
                                  ) ,
                                ),
                                ElevatedButton(
                                  child: const Text('Close BottomSheet'),
                                  onPressed: () => Navigator.pop(context),
                                )
                              ],
                            ),
                          );
                        },
                      );
                    },
                  ),
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