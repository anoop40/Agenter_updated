import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../bank_balance.dart';
import '../cash_balance.dart';
import '../customers.dart';
import '../over_due_bills.dart';
import '../over_due_invoices.dart';
import '../unpaid_bills.dart';
import '../unpaid_invoice.dart';
import 'package:http/http.dart' as http;

import '../vendors.dart';
class dashboard extends StatefulWidget {
  _user_dashboard createState() => _user_dashboard();
}

class _user_dashboard extends State<dashboard> {
  String dropdownValue = '1-Apr-2020 to 1-May-2021';
  var _vendor_amount;
  var _customer_amount;
  var _cash_amount;
  var _bank_amount;
  var _invoice_overdue_count;
  var _invoice_overdue_amount;
  var _invoice_unpaid_count;
  var _invoice_unpaid_amount;
  var _bill_overdue_count;
  var _bill_overdue_amount;
  var _bill_unpaid_count;
  var _bill_unpaid_amount;
  var _today_due_count;
  var _today_due_amount;
  var _today_unpaid_count;
  var _today_unpaid_amount;
  final _controller = new TextEditingController();
  final _controller_from_date = new TextEditingController();
  final _controller_to_date = new TextEditingController();
  DateTime currentDate = DateTime.now();
  getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    var serverUrlfinal = "https://books.sambiya.com/reports/lite/dashboard";

    var response = await http.get(Uri.parse(serverUrlfinal), headers: {
      "Accept": "application/json",
      "Cookie": 'gate_token=${prefs.getString('token').toString()}'
    });

    print("Response body dashboard : " + response.body.toString());
    var received_data = json.decode(response.body);

    setState(() {
        _customer_amount = received_data['customer']['balance_amount'];
        _vendor_amount = received_data['customer']['balance_amount'];
        _cash_amount = received_data['cash']['amount'];
        _bank_amount = received_data['bank']['amount'];
        _invoice_overdue_count = received_data['invoice']['overdue_count'];
        _invoice_overdue_amount = received_data['invoice']['overdue_amount'];
        _invoice_unpaid_count = received_data['invoice']['unpaid_count'];
        _invoice_unpaid_amount = received_data['invoice']['unpaid_amount'];
        _bill_overdue_count = received_data['bill']['overdue_count'];
        _bill_overdue_amount = received_data['bill']['overdue_amount'];
        _bill_unpaid_amount = received_data['bill']['unpaid_amount'];
        _bill_unpaid_count= received_data['bill']['unpaid_count'];
        _today_due_count = received_data['bill']['due_count'];
        _today_due_amount = received_data['bill']['due_amount'];
        _today_unpaid_count = received_data['bill']['unpaid_count'];
        _today_unpaid_amount = received_data['bill']['unpaid_amount'];
    });
    return true;
  }
  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Center(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.94,
              child: Padding(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.02),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.4,
                        child: TextField(
                          controller: _controller_from_date,
                          decoration: InputDecoration(
                            hintText: 'From',
                            border: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.white, width: 2.0),
                              borderRadius: BorderRadius.circular(10.0),

                            ),
                            contentPadding: EdgeInsets.only(left: 7.00),
                            suffixIcon: IconButton(
                              onPressed: () async {
                                final DateTime? pickedDate = await showDatePicker(
                                    context: context,
                                    initialDate: currentDate,
                                    firstDate: DateTime(2015),
                                    lastDate: DateTime(2050));
                                if (pickedDate != null && pickedDate != currentDate)
                                  setState(() {
                                    _controller_from_date.text = DateFormat('dd-MM-yyyy').format(pickedDate);
                                  });
                              } ,
                              icon: Icon(Icons.today),
                            ),
                          ),
                        ),
                      ),
                      Text("To"),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.4,
                        child: TextField(
                          controller: _controller_to_date,
                          decoration: InputDecoration(
                            hintText: 'To',
                            border: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.white, width: 2.0),
                              borderRadius: BorderRadius.circular(10.0),

                            ),
                            contentPadding: EdgeInsets.only(left: 7.00),
                            suffixIcon: IconButton(
                              onPressed: () async {

                                final DateTime? pickedDate = await showDatePicker(
                                    context: context,
                                    initialDate: currentDate,
                                    firstDate: DateTime(2015),
                                    lastDate: DateTime(2050));
                                if (pickedDate != null && pickedDate != currentDate)
                                  setState(() {
                                    _controller_to_date.text = DateFormat('dd-MM-yyyy').format(pickedDate);
                                  });

                              },
                              icon: Icon(Icons.today),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

              ),
            ),
          ),
          Divider(),
          Container(
            width: MediaQuery.of(context).size.width * 0.9,
            padding: EdgeInsets.only(
                top: MediaQuery.of(context).size.height * 0.016),
            child: Text("Balances"),
          ),
          Container(
            padding:
                EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.02),
            width: MediaQuery.of(context).size.width * 0.9,
            child: Wrap(
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => vendors()),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    width: MediaQuery.of(context).size.width * 0.4,
                    child: ListTile(
                      title: Text(
                        "₹ ${_vendor_amount.toString()}",
                        style: TextStyle(color: Colors.white),
                      ),
                      subtitle: Text("Vendors ",
                          style: TextStyle(color: Colors.white)),
                      trailing: Icon(
                        Icons.navigate_next,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      left: MediaQuery.of(context).size.width * 0.06),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => customers()),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.orange,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      width: MediaQuery.of(context).size.width * 0.4,
                      child: ListTile(
                        title: Text(
                          "₹ ${_customer_amount.toString()}",
                          style: TextStyle(color: Colors.white),
                        ),
                        subtitle: Text("Customers ",
                            style: TextStyle(color: Colors.white)),
                        trailing: Icon(
                          Icons.navigate_next,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.width * 0.04),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => cash_balance()),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.orange,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      width: MediaQuery.of(context).size.width * 0.4,
                      child: ListTile(
                        title: Text(
                          "₹ ${_cash_amount.toString()}",
                          style: TextStyle(color: Colors.white),
                        ),
                        subtitle: Text("Cash ",
                            style: TextStyle(color: Colors.white)),
                        trailing: Icon(
                          Icons.navigate_next,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.width * 0.04,
                      left: MediaQuery.of(context).size.width * 0.04),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => bank_balance()),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.pink[500],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      width: MediaQuery.of(context).size.width * 0.4,
                      child: ListTile(
                        title: Text(
                          "₹ ${_bank_amount.toString()}",
                          style: TextStyle(color: Colors.white),
                        ),
                        subtitle: Text("Bank ",
                            style: TextStyle(color: Colors.white)),
                        trailing: Icon(
                          Icons.navigate_next,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.9,
            padding: EdgeInsets.only(
                top: MediaQuery.of(context).size.height * 0.016),
            child: Text("Invoices"),
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.9,
            child: Divider(
              color: Colors.yellow[900],
              thickness: 4.00,
            ),
          ),
          Padding(
            padding: EdgeInsets.zero,
            child: Container(
              width: MediaQuery.of(context).size.width * 0.9,
              child: Wrap(
                children: <Widget>[
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.4,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => over_due_invoices()),
                        );
                      },
                      child: Card(
                        child: ListTile(
                          title: Text("₹ ${_invoice_overdue_amount}"),
                          subtitle: Text("${_invoice_overdue_count.toString()} overdues "),
                          trailing: Icon(Icons.navigate_next),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        left: MediaQuery.of(context).size.width * 0.02),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => unpaid_invoices()),
                        );
                      },
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.4,
                        child: Card(
                          child: ListTile(
                            title: Text("₹ ${_invoice_unpaid_amount.toString()}"),
                            subtitle: Text("${_invoice_unpaid_count.toString()} unpaid "),
                            trailing: Icon(Icons.navigate_next),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.9,
            padding:
                EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.02),
            child: Text("Purchase bill"),
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.9,
            child: Divider(
              color: Colors.green[900],
              thickness: 4.00,
            ),
          ),
          Padding(
            padding: EdgeInsets.zero,
            child: Container(
              width: MediaQuery.of(context).size.width * 0.9,
              child: Wrap(
                children: <Widget>[
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.4,
                    child: GestureDetector(
                      onTap: (){
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => over_due_bills()),
                        );
                      },
                      child: Card(
                        child: ListTile(
                          title: Text("₹ ${_bill_overdue_amount.toString()}"),
                          subtitle: Text("${_bill_overdue_count.toString()} overdues "),
                          trailing: Icon(Icons.navigate_next),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        left: MediaQuery.of(context).size.width * 0.02),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.4,
                      child: GestureDetector(
                        onTap: (){
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => unpaid_bills()),
                          );
                        },
                        child: Card(
                          child: ListTile(
                            title: Text("₹ ${_bill_unpaid_amount.toString()}"),
                            subtitle: Text("${_bill_unpaid_count.toString()} unpaid "),
                            trailing: Icon(Icons.navigate_next),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.9,
            padding:
                EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.02),
            child: Text("Due today"),
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.9,
            child: Divider(
              color: Colors.pink[900],
              thickness: 4.00,
            ),
          ),
          Padding(
            padding: EdgeInsets.zero,
            child: Container(
              width: MediaQuery.of(context).size.width * 0.9,
              child: Wrap(
                children: <Widget>[
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.4,
                    child: Card(
                      child: ListTile(
                        title: Text("₹ ${_today_due_amount.toString()}"),
                        subtitle: Text("${_today_due_count.toString()} overdues "),
                        trailing: Icon(Icons.navigate_next),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        left: MediaQuery.of(context).size.width * 0.02),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.4,
                      child: Card(
                        child: ListTile(
                          title: Text("₹ ${_today_unpaid_amount.toString()}"),
                          subtitle: Text("${_today_unpaid_count.toString()} unpaid "),
                          trailing: Icon(Icons.navigate_next),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height * 0.03),
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.9,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black26),
                        borderRadius: BorderRadius.circular(7),
                      ),
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(
                                top: MediaQuery.of(context).size.height * 0.02,
                                left: MediaQuery.of(context).size.height * 0.02,
                                bottom:
                                    MediaQuery.of(context).size.height * 0.01),
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.9,
                              child: Text("PROFIT & LOSS"),
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.8,
                            child: Text("₹ 33,931,410.00"),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.8,
                            padding: EdgeInsets.only(
                                top: MediaQuery.of(context).size.height * 0.01),
                            child: Text("Net profit for the period"),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 10.00, bottom: 10.00),
                            child: ListTile(
                              leading: SizedBox(
                                width: MediaQuery.of(context).size.width * 0.3,
                                child: LinearProgressIndicator(),
                              ),
                              title: Text("₹ 76,906.00"),
                              subtitle: Text("INCOME"),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 10.00, bottom: 10.00),
                            child: ListTile(
                              leading: SizedBox(
                                width: MediaQuery.of(context).size.width * 0.3,
                                child: LinearProgressIndicator(),
                              ),
                              title: Text("₹ 89,987.00"),
                              subtitle: Text("EXPENSE"),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height * 0.02),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black26),
                        borderRadius: BorderRadius.circular(7),
                      ),
                      child: ListTile(
                        leading: Icon(Icons.inventory),
                        title: Text("Inventory Items"),
                        trailing: Icon(Icons.navigate_next),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.02,
                      bottom: MediaQuery.of(context).size.height * 0.04,
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black26),
                        borderRadius: BorderRadius.circular(7),
                      ),
                      child: ListTile(
                        leading: Icon(Icons.manage_accounts),
                        title: Text("View accounting transactions"),
                        trailing: Icon(Icons.navigate_next),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
