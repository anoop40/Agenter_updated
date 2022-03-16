import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class messages extends StatefulWidget {
  final _accountant_name;
  final _phone;

  messages(this._accountant_name, this._phone);

  _messages createState() => _messages();
}

class _messages extends State<messages> {
  late Future str;
  var messages_all;
  final _reply_messg = new TextEditingController();
  var _channel_id;

  get_messaage_data() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print("token is : " + prefs.getString('token').toString());
    var response = await http.get(
        Uri.parse("https://books.sambiya.com/book-keeping/book-keeper"),
        headers: {
          "Accept": "application/json",
          "Cookie": 'gate_token=${prefs.getString('token').toString()}'
        });
    //print("Response : " + response.body.toString());
    var resultCon = json.decode(response.body);
    print(
        "accountant id : " + resultCon['data'][0]['accountant_id'].toString());

    var response1 = await http.post(
        Uri.parse(
            "https://books.sambiya.com/messenger/channel/connect/${resultCon['data'][0]['accountant_id'].toString()}"),
        headers: {
          "Accept": "application/json",
          "Cookie": 'gate_token=${prefs.getString('token').toString()}'
        });
    //print("Response123 : " + response1.body.toString());
    var resultCon1 = json.decode(response1.body);
    //print("id is : " + resultCon1['data']['id'].toString());
    setState(() {
     _channel_id =  resultCon1['data']['id'].toString();
    });
    var response2 = await http.get(
        Uri.parse(
            "https://books.sambiya.com/messenger/message/${resultCon1['data']['id'].toString()}?limit=25&totime=&is_unread"),
        headers: {
          "Accept": "application/json",
          "Cookie": 'gate_token=${prefs.getString('token').toString()}'
        });
    print("response2 : " + response2.body.toString());
    messages_all = json.decode(response2.body);
    return true;
  }

  @override
  void initState() {
    super.initState();
    str = get_messaage_data();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(
          color: Colors.black, //change your color here
        ),
        title: Padding(
          padding: EdgeInsets.only(
              top: MediaQuery.of(context).size.height * 0.02,
              bottom: MediaQuery.of(context).size.height * 0.02),
          child: ListTile(
            leading: ChoiceChip(
              backgroundColor: Colors.blue,
              label: Text(
                widget._accountant_name[0],
                style: TextStyle(color: Colors.black),
              ),
              selected: true,
            ),
            title: Text(widget._accountant_name),
            subtitle: Text("Active now"),
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(
              Icons.call,
              color: Colors.black,
            ),
            tooltip: 'Increase volume by 10',
            onPressed: () async {
              await launch('tel:${widget._phone.toString()}');
            },
          ),
          IconButton(
            icon: const Icon(
              Icons.star,
              color: Colors.blue,
            ),
            tooltip: 'Increase volume by 10',
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: FutureBuilder(
          future: str,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Column(
                children: <Widget>[
                  ListView.builder(
                    itemCount: messages_all['data'].length,
                    shrinkWrap: true,
                    padding: EdgeInsets.only(top: 10, bottom: 10),
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return Container(
                        padding: EdgeInsets.only(
                            left: 14, right: 14, top: 10, bottom: 10),
                        child: Align(
                          alignment:
                              (messages_all['data'][index]['ctype'] == "out"
                                  ? Alignment.topRight
                                  : Alignment.topLeft),
                          // alignment: Alignment.topRight,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              //color: (messages[index].messageType  == "receiver"?Colors.grey.shade200:Colors.blue[200]),
                              color: Colors.grey.shade200,
                            ),
                            padding: EdgeInsets.all(16),
                            //child: Text(messages[index].messageContent, style: TextStyle(fontSize: 15),),
                            child: Text(
                              messages_all['data'][index]['message'].toString(),
                              style: TextStyle(fontSize: 15),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  Container(
                      alignment: Alignment.bottomCenter, // align the row
                      padding: EdgeInsets.all(16.0),
                      child: Row(
                        children: <Widget>[
                          Flexible(
                              child: TextFormField(
                                controller: _reply_messg,
                            decoration: InputDecoration(
                              suffixIcon: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                // added line
                                mainAxisSize: MainAxisSize.min,
                                // added line
                                children: <Widget>[
                                  IconButton(
                                    icon: Icon(Icons.attach_file),
                                    onPressed: () {},
                                  ),
                                  CircleAvatar(
                                    radius: 22,
                                    backgroundColor: Colors.blue[900],
                                    child: IconButton(
                                      icon: FaIcon(FontAwesomeIcons.paperPlane, size: 16,),
                                      onPressed: () async {
                                        print("_channel_id : " + _channel_id.toString());
                                        print("content is : " +_reply_messg.text);
                                        showDialog(barrierDismissible: false,
                                          context:context,
                                          builder:(BuildContext context){
                                            return AlertDialog(
                                              content: new Row(
                                                children: [
                                                  CircularProgressIndicator(),
                                                  Container(margin: EdgeInsets.only(left: 7),child:Text(" Sending..." )),
                                                ],),
                                            );
                                          },
                                        );
                                        SharedPreferences prefs = await SharedPreferences.getInstance();
                                        var response = await http.post(
                                            Uri.parse("https://books.sambiya.com/messenger/message"),
                                            body: {
                                              'channel_id' : _channel_id.toString(),
                                              'message' : _reply_messg.text,

                                            },
                                            headers: {
                                              "Accept": "application/json",
                                              "Cookie": 'gate_token=${prefs.getString('token').toString()}'
                                            });

                                        print("Response : " + response.body.toString());
                                        var resultCon = json.decode(response.body);
                                        if(resultCon['data']['ctype'] == "out"){
                                         await get_messaage_data();
                                          Navigator.pop(context);
                                          Fluttertoast.showToast(
                                              msg: "Message successfully send",
                                              toastLength: Toast.LENGTH_SHORT,
                                              gravity: ToastGravity.CENTER,
                                              timeInSecForIosWeb: 1,
                                              backgroundColor: Colors.red,
                                              textColor: Colors.white,
                                              fontSize: 16.0
                                          );

                                        }
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              /*
                              suffixIcon: CircleAvatar(
                                radius: 11,
                                backgroundColor: Colors.blue[900],
                                child: IconButton(
                                  icon: FaIcon(FontAwesomeIcons.paperPlane, size: 18,),
                                  onPressed: () {},
                                ),
                              ),
                              */
                              border: UnderlineInputBorder(),
                              labelText: 'Enter your username',
                            ),
                          ))
                        ],
                      ))
                ],
              );
            } else {
              return Center(
                child: Padding(
                  padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.4),
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
