import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
class vendors extends StatefulWidget{
  _vendors createState() => _vendors();
}
class _vendors extends State<vendors>{
  var vendors;
  late Future str;
  getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    var serverUrlfinal = "https://books.sambiya.com/api/vendor";

    var response = await http.get(Uri.parse(serverUrlfinal), headers: {
      "Accept": "application/json",
      "Cookie": 'gate_token=${prefs.getString('token').toString()}'
    });
    print("welcome all");
    print("Response body : " + response.body.toString());
    setState(() {
      vendors = json.decode(response.body) ;
    });
    return true;

  }
  @override
  void initState() {
    print("welcome to vendors");
    super.initState();
    str = getData();
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
        title: TextField(
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: 'Search vendor',
            prefixIcon: IconButton(
              onPressed: (){},
              icon: Icon(Icons.search),
            ),

          ),
        ),

      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Add your onPressed code here!
        },
        label: const Text('Add new'),
        icon: const Icon(Icons.add),
        backgroundColor: Colors.blue[900],
      ),
      body: SingleChildScrollView(
        child: FutureBuilder(
          future: str,
          builder: (context,snapshot){
            if(snapshot.hasData){
              return ListView(
                scrollDirection: Axis.vertical,
                physics: ScrollPhysics(),
                shrinkWrap: true,
                padding: const EdgeInsets.all(8),
                children: List.generate(vendors['data'].length,(index) =>
                /*
                        ListTile(
                          title: Text('Item $index'),
                        )
                    */
                Column(
                  children: <Widget>[
                    ListTile(
                      title: Text(vendors['data'][index]['name']),
                      trailing: Text("${vendors['data'][index]['unpaid_formatted']}"),
                    ),
                    Divider(),
                  ],
                )


                ),
              );
              /*
              return Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.04),
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.9,
                      child: Text("Vendors", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 19),),
                    ),
                  ),
                  Divider(),
                  ListTile(
                    title: Text("Alex"),
                    trailing: Text("₹ 25000.0"),

                  ),
                  Divider(),

                ],
              );
              */
            }
            else{
              return Padding(
                padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.4),
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}