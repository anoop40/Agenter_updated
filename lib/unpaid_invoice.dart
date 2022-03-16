import 'package:flutter/material.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
class unpaid_invoices extends StatefulWidget{
  _unpaid_invoices createState() => _unpaid_invoices();
}
class _unpaid_invoices extends State<unpaid_invoices>{
  String dropdownValue = '1-Apr-2020 to 1-May-2021';
  final RoundedLoadingButtonController _btnController = RoundedLoadingButtonController();
  DateTime selectedDate = DateTime.now();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text("Unpaid invoices", style: TextStyle(color: Colors.black),),

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
                    onPressed: (){
                      showModalBottomSheet<void>(
                        context: context,
                        builder: (BuildContext context) {
                          return Container(
                            height: 800,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.01),
                                  child: SizedBox(
                                    width: MediaQuery.of(context).size.width * 0.8,
                                    child: Row(

                                      children: <Widget>[
                                        Text("Date Range", style: TextStyle(fontSize: 17),),
                                        TextButton(

                                          child: Text("Cancel"),
                                          onPressed: (){
                                            Navigator.pop(context);
                                          },
                                        )
                                      ],
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    ),
                                  ),
                                ),
                                Divider(),
                                Padding(
                                  padding: EdgeInsets.zero,
                                  child: Container(
                                    width: MediaQuery.of(context).size.width * 0.9,
                                    child:  Wrap(

                                      children: <Widget>[
                                        InputChip(
                                          label: Text('Today'),
                                          onSelected: (bool value) {},
                                        ),
                                        InputChip(
                                          label: Text('This week'),
                                          onSelected: (bool value) {},
                                        ),
                                        InputChip(
                                          label: Text('This month'),
                                          onSelected: (bool value) {},
                                        ),
                                        InputChip(
                                          label: Text('This quarter'),
                                          onSelected: (bool value) {},
                                        ),
                                        InputChip(
                                          label: Text('This year'),
                                          onSelected: (bool value) {},
                                        ),
                                        InputChip(
                                          label: Text('Year to date'),
                                          onSelected: (bool value) {},
                                        ),
                                        InputChip(
                                          label: Text('Yesterday '),
                                          onSelected: (bool value) {},
                                        ),
                                        InputChip(
                                          label: Text('Previous year'),
                                          onSelected: (bool value) {},
                                        ),
                                        InputChip(
                                          label: Text('Previous month'),
                                          onSelected: (bool value) {},
                                        ),
                                        InputChip(
                                          label: Text('Previous quarter'),
                                          onSelected: (bool value) {},
                                        ),
                                        InputChip(
                                          label: Text('Custom'),
                                          onSelected: (bool value) {},
                                        ),
                                      ],
                                      spacing: 16.00,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.02),
                                  child: SizedBox(
                                    width: MediaQuery.of(context).size.width * 0.8,
                                    child: Column(
                                      children: <Widget>[
                                        Row(

                                          children: <Widget>[
                                            Text("Start date : "),
                                            SizedBox(
                                              width: MediaQuery.of(context).size.width * 0.5,
                                              child: TextField(

                                                decoration: InputDecoration(

                                                  hintText: 'Select date',
                                                  suffixIcon: IconButton(
                                                    onPressed: (){
                                                      _selectDate(context);
                                                    },
                                                    icon: Icon(Icons.calendar_today, size: 20,),
                                                  ),
                                                ),
                                              ),
                                            )
                                          ],
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        ),
                                        Row(

                                          children: <Widget>[
                                            Text("End date : "),
                                            SizedBox(
                                              width: MediaQuery.of(context).size.width * 0.5,
                                              child: TextField(

                                                decoration: InputDecoration(

                                                  hintText: 'Select date',
                                                  suffixIcon: IconButton(
                                                    onPressed: (){
                                                      _selectDate(context);
                                                    },
                                                    icon: Icon(Icons.calendar_today, size: 20,),
                                                  ),
                                                ),
                                              ),
                                            )
                                          ],
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.02),
                                          child: RoundedLoadingButton(
                                            color: Colors.blue[800],
                                            width: MediaQuery.of(context).size.width,
                                            borderRadius: 7.00,
                                            child: Text('APPLY', style: TextStyle(color: Colors.white)),
                                            controller: _btnController,
                                            onPressed: (){},
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )

                              ],
                            ),
                          );
                        },
                      );
                    },
                    icon: Icon(Icons.list_alt_sharp),
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
                            Text("Invoice no : "),
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
                            Text("Invoice date : "),
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
                            Text("Invoice no : "),
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
                            Text("Invoice date : "),
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