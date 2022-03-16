import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'activity_details.dart';
import 'package:http/http.dart' as http;

import 'activity_filter.dart';
class activities extends StatefulWidget {
  _activities createState() => _activities();
}

class _activities extends State<activities> {
  bool isChecked = false;
  late var activities;
  late Future str2;

  Future<bool> getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    var serverUrlfinal = "https://books.sambiya.com/book-keeping/task?na";

    var response = await http.get(Uri.parse(serverUrlfinal), headers: {
      "Accept": "application/json",
      "Cookie": 'gate_token=${prefs.getString('token').toString()}'
    });

    print("Response body : " + response.body.toString());
    setState(() {
      activities = json.decode(response.body) ;
    });
    return true;
  }
  @override
  void initState() {
    super.initState();
    str2 = getData();
    print("str : " + str2.toString());
  }
  @override
  Widget build(BuildContext context) {
    Color getColor(Set<MaterialState> states) {
      const Set<MaterialState> interactiveStates = <MaterialState>{
        MaterialState.pressed,
        MaterialState.hovered,
        MaterialState.focused,
      };
      if (states.any(interactiveStates.contains)) {
        return Colors.blue;
      }
      return Colors.red;
    }

    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet<void>(
            isScrollControlled: true,
            isDismissible: false,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.0),
                topRight: Radius.circular(20.0),
              ),
            ),
            context: context,
            builder: (BuildContext context) {
              return Container(
                height: MediaQuery.of(context).size.height * 0.6,
                child: Column(
                  children: <Widget>[
                    activity_filter(),
                    Center(
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.4,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              primary: Colors.blue[800]
                          ),
                          child: Text("Sort records"),
                          onPressed: (){
                            getData();
                            Navigator.pop(context);
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
        /*
        Center(
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.4,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  primary: Colors.blue[800]
              ),
              child: Text("Sort records"),
              onPressed: (){
                Navigator.pop(context);
              },
            ),
          ),
        )
         */
        backgroundColor: Colors.blue[800],
        child: const Icon(Icons.list),
      ),
      body: FutureBuilder(
        future: str2,
        builder: (context, snapshot){
          print("snap shot : " +snapshot.toString());
          if(snapshot.hasData){
            // print("Data  :"+activities['data'].toString());
            //   print("Data  1 :"+activities['data'][1].toString());
            print("length 124 : " + activities['data'].length.toString());
            if(activities['data'].length > 0 ) {
              return RefreshIndicator(
                onRefresh: getData,
                child: ListView(
                  scrollDirection: Axis.vertical,
                  physics: ScrollPhysics(),
                  shrinkWrap: true,
                  padding: const EdgeInsets.all(8),
                  children: List.generate(
                      activities['data'].length, (index) =>
                  /*
                        ListTile(
                          title: Text('Item $index'),
                        )
                    */
                  Column(
                    children: <Widget>[
                      ListTile(
                        leading: Checkbox(
                          checkColor: Colors.white,
                          fillColor: MaterialStateProperty.resolveWith(
                              getColor),
                          value: isChecked,
                          onChanged: (bool? value) {
                            setState(() {
                              isChecked = value!;
                            });
                          },
                        ),
                        title: Text(
                            activities['data'][index]['description']
                                .toString()),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(
                                  top: 4.00, bottom: MediaQuery
                                  .of(context)
                                  .size
                                  .height * 0.001),
                              child: Text(
                                  "ACTIVITY : ${activities['data'][index]['id']
                                      .toString()}"),
                            ),


                            activities['data'][index]['document_status']
                                .toString() == "na" ||
                                activities['data'][index]['document_status']
                                    .toString() == "open" ?
                            Chip(
                              backgroundColor: Colors.green,
                              label: const Text('OPEN',
                                style: TextStyle(color: Colors.white),),
                            ) : Text("")

                          ],
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    activity_details(
                                        activities['data'][index]['id'])),
                          );
                        },
                      ),
                      Divider(),
                    ],
                  )


                  ),
                ),
              );
            }
            else{
              return Center(
                child: Padding(
                  padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.4),
                  child: Text("No data found"),
                ),
              );
            }



          }
          else{
            print("no data");
            return Padding(
              padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.3),
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
          return Text("");

        },

      ),
    );
  }
}
