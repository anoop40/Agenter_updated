import 'dart:async';
import 'dart:io';

import 'package:agenter_updated/takephoto.dart';
import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

class add_new_activity extends StatefulWidget {
  _add_new_activity createState() => _add_new_activity();
}

class _add_new_activity extends State<add_new_activity> {
  final RoundedLoadingButtonController _btnController =
      RoundedLoadingButtonController();
  String dropdownValue = "Invoice";
  late var camera;
  late var image_file;
  var _token_get;
  late Future str;
  final _description = new TextEditingController();
  var _uploaded_image_file;
  final _activity_summery = new TextEditingController();
  final _formKey = GlobalKey<FormState>();

  get_session_data() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _token_get = prefs.getString('token');
    });
    /*
    FirebaseFirestore.instance.collection('uploaded_camera_photos')
        .where('token' ,prefs.getString('token'))
        .delete()
        .then((value) => print("User's Property Deleted"))
        .catchError((error) => print("Failed to delete user's property: $error"));
    */
    final QuerySnapshot result  = await FirebaseFirestore.instance.collection('uploaded_camera_photos')
        .where('token', isEqualTo: prefs.getString('token'))
        .limit(1)
        .get();
    final List<DocumentSnapshot> documents = result.docs;
    print("documents.length : " +documents.length.toString());
    if(documents.length > 0){
      //print("Document id ; " + documents.id.toString());
      FirebaseFirestore.instance
          .collection('uploaded_camera_photos')
          .where('token', isEqualTo: prefs.getString('token'))
          .get()
          .then((QuerySnapshot querySnapshot) {
        querySnapshot.docs.forEach((doc) async{
          //print("Doc id"+doc.id);
          await FirebaseFirestore.instance.collection('uploaded_camera_photos')
              .doc(doc.id)
              .delete()
              .then((value) => print("User Deleted"))
              .catchError((error) => print("Failed to delete user: $error"));
        });
      });
    }
    return true;
  }

// Get the Stream

  @override
  void initState() {
    super.initState();
    str = get_session_data();
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
        title: Text(
          "Add activity",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: FutureBuilder(
        future: str,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return SingleChildScrollView(
              child: Center(
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(
                            top: MediaQuery.of(context).size.height * 0.03),
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.9,
                          child: TextFormField(
                            controller: _activity_summery,
                            maxLines: 8,
                            decoration: new InputDecoration(
                              hintText: "Activity summery",
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter some text';
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            top: MediaQuery.of(context).size.height * 0.03),
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.9,
                          child: TextField(
                            controller: _description,
                            maxLines: 8,
                            decoration: new InputDecoration(
                              hintText: "Description",
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            top: MediaQuery.of(context).size.height * 0.03),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.86,
                          child: Column(
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  DropdownButton<String>(
                                    value: dropdownValue,
                                    icon: const Icon(Icons.arrow_downward),
                                    elevation: 16,
                                    style: const TextStyle(
                                        color: Colors.deepPurple),
                                    underline: Container(
                                      height: 2,
                                      color: Colors.deepPurpleAccent,
                                    ),
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        dropdownValue = newValue!;
                                      });
                                    },
                                    items: <String>[
                                      'Invoice',
                                      'Bill',
                                      'Credit note',
                                      'Debit note',
                                      'Receipt',
                                      'Payment',
                                      'Expenses',
                                      'Delivery challan',
                                      'Journal',
                                      'Other'
                                    ].map<DropdownMenuItem<String>>(
                                        (String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value),
                                      );
                                    }).toList(),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            top: MediaQuery.of(context).size.height * 0.03),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.9,
                          child: Column(
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  OutlinedButton(
                                    onPressed: () {
                                      showModalBottomSheet<void>(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return Container(
                                            height: 300,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              mainAxisSize: MainAxisSize.min,
                                              children: <Widget>[
                                                SizedBox(
                                                  width: MediaQuery.of(context)
                                                      .size
                                                      .width,
                                                  child: ListTile(
                                                    title: Center(
                                                      child: Text(
                                                        "Take New Photo",
                                                        style: TextStyle(
                                                            color: Colors.blue),
                                                      ),
                                                    ),
                                                    onTap: () async {
                                                      WidgetsFlutterBinding
                                                          .ensureInitialized();
                                                      final cameras =
                                                          await availableCameras();
                                                      final firstCamera = cameras.first;
                                                      print(firstCamera
                                                          .toString());

                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder:
                                                                (context) =>
                                                                    takephoto(
                                                                      camera:
                                                                          firstCamera,
                                                                    )),

                                                      );
                                                      /*
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(builder: (context) => takephoto()),
                                                      );
                                                      */
                                                    },
                                                  ),
                                                ),
                                                Divider(),
                                                SizedBox(
                                                  width: MediaQuery.of(context)
                                                      .size
                                                      .width,
                                                  child: ListTile(
                                                    title: Center(
                                                      child: Text(
                                                          "Photo Library",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.blue)),
                                                    ),
                                                    onTap: () async {
                                                      SharedPreferences prefs =
                                                          await SharedPreferences
                                                              .getInstance();
                                                      FilePickerResult? result =
                                                          await FilePicker
                                                              .platform
                                                              .pickFiles();

                                                      if (result != null) {
                                                        print("File path is : " +
                                                            result.files.single
                                                                .path
                                                                .toString());
                                                        FirebaseFirestore
                                                            .instance
                                                            .collection(
                                                                'uploaded_camera_photos')
                                                            .add({
                                                          'file_name': result
                                                              .files.single.path
                                                              .toString(),
                                                          'token':
                                                              prefs.getString(
                                                                  'token')
                                                        }).then((value) {
                                                          print("success");
                                                          Navigator.of(context)
                                                              .pop();
                                                        }).catchError((error) =>
                                                                print(
                                                                    "Failed to add user: $error"));
                                                        //File file = File(result.files.single.path.toString());
                                                      } else {
                                                        // User canceled the picker
                                                      }
                                                    },
                                                  ),
                                                ),
                                                Divider(),
                                                SizedBox(
                                                  width: MediaQuery.of(context)
                                                      .size
                                                      .width,
                                                  child: ListTile(
                                                    title: Center(
                                                      child: Text("Document",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.blue)),
                                                    ),
                                                  ),
                                                ),
                                                Divider(),
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                      top:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .height *
                                                              0.03),
                                                  child: SizedBox(
                                                    width:
                                                        MediaQuery.of(context)
                                                            .size
                                                            .width,
                                                    child: ListTile(
                                                      title: Center(
                                                        child: Text("Cancel",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .blue)),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                      );
                                    },
                                    child: Row(
                                      children: <Widget>[
                                        Icon(Icons.add),
                                        Text("Add attachment")
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                    top: MediaQuery.of(context).size.height *
                                        0.03),
                                child: StreamBuilder<QuerySnapshot>(
                                  stream: FirebaseFirestore.instance
                                      .collection('uploaded_camera_photos')
                                      .where('token',
                                          isEqualTo: _token_get.toString())
                                      .snapshots(),
                                  builder: (BuildContext context,
                                      AsyncSnapshot<QuerySnapshot> snapshot) {
                                    if (snapshot.hasError) {
                                      return Text('Something went wrong');
                                    }

                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    }
                                    if (snapshot.data!.docs.length == 0) {
                                      return Text("No documents found");
                                    }
                                    return Wrap(
                                      children: <Widget>[
                                        ListView(
                                          scrollDirection: Axis.vertical,
                                          shrinkWrap: true,
                                          children: snapshot.data!.docs
                                              .map((DocumentSnapshot document) {
                                            Map<String, dynamic> data =
                                                document.data()!
                                                    as Map<String, dynamic>;

                                            return Stack(
                                              children: <Widget>[
                                                // Image.file(File(data['file_name']))
                                                SizedBox(
                                                  child: Image.file(
                                                      File(data['file_name'])),
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.2,
                                                ),
                                                Positioned(
                                                    left: -2,
                                                    top: -9,
                                                    child: IconButton(
                                                        icon: Icon(
                                                          Icons.cancel,
                                                          color:
                                                              Colors.redAccent,
                                                          size: 18,
                                                        ),
                                                        onPressed:
                                                            () => setState(() {
                                                                  FirebaseFirestore
                                                                      .instance
                                                                      .collection(
                                                                          'uploaded_camera_photos')
                                                                      .doc(document
                                                                          .id)
                                                                      .delete()
                                                                      .then(
                                                                          (value) {
                                                                    Fluttertoast.showToast(
                                                                        msg:
                                                                            "Successfully removed",
                                                                        toastLength:
                                                                            Toast
                                                                                .LENGTH_SHORT,
                                                                        gravity:
                                                                            ToastGravity
                                                                                .CENTER,
                                                                        timeInSecForIosWeb:
                                                                            1,
                                                                        backgroundColor:
                                                                            Colors
                                                                                .red,
                                                                        textColor:
                                                                            Colors
                                                                                .white,
                                                                        fontSize:
                                                                            16.0);
                                                                  }).catchError(
                                                                          (error) =>
                                                                              print("Failed to delete user: $error"));
                                                                }))),
                                              ],
                                            );
                                          }).toList(),
                                        ),
                                      ],
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
      bottomNavigationBar: RoundedLoadingButton(
        color: Colors.blue[800],
        borderRadius: 2.00,
        width: MediaQuery.of(context).size.width,
        child: Text('CREATE', style: TextStyle(color: Colors.white)),
        controller: _btnController,
        onPressed: () async {
          var request;
          if (_formKey.currentState!.validate()) {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            print("Token is : " + prefs.getString('token').toString());
            await FirebaseFirestore.instance
                .collection('uploaded_camera_photos')
                .where('token', isEqualTo: _token_get.toString())
                .get()
                .then((QuerySnapshot querySnapshot) {
              querySnapshot.docs.forEach((doc) {
                //print(doc["first_name"]);
                setState(() {
                  _uploaded_image_file = doc['file_name'];
                });
              });
            });
            print("uploaded file from server : " +
                _uploaded_image_file.toString());
            Map<String, String> headers = {
              "Accept": "application/json",
              "Cookie": 'gate_token=${prefs.getString('token').toString()}'
            };
            /*
          var uri = Uri.parse('https://books.sambiya.com/book-keeping/task?');
          var request = http.MultipartRequest('POST', uri)
            ..fields['user'] = 'nweiz@google.com'
            ..files.add(await http.MultipartFile.fromPath(
                'package', 'build/package.tar.gz',
                contentType: MediaType('application', 'x-tar')));
          var response = await request.send();
          if (response.statusCode == 200) print('Uploaded!');
          */
            print("_uploaded_image_file : " +_uploaded_image_file.toString());
            if(_uploaded_image_file == null || _uploaded_image_file == "") {
              request = http.MultipartRequest(
                'POST',
                Uri.parse("https://books.sambiya.com/book-keeping/task?"
                    "type=${dropdownValue}"
                    "&description=${_description.text}"
                    "&task_number=1"
                    "&attachment="
                    "&summary=${_activity_summery.text}"),
              );
              request.headers.addAll(headers);
            }
            else{
              request = http.MultipartRequest(
                'POST',
                Uri.parse("https://books.sambiya.com/book-keeping/task?"
                    "type=${dropdownValue}"
                    "&description=${_description.text}"
                    "&task_number=1"
                    "&attachment="
                    "&summary=${_activity_summery.text}"),
              );
              request.headers.addAll(headers);
              request.files.add(await http.MultipartFile.fromPath(
                  'attachment', _uploaded_image_file));
            }
            /*
          var res = await request.send();

          var response1 = await http.post(
              Uri.parse("https://books.sambiya.com/book-keeping/task?"
                  "type=${dropdownValue}"
                  "&description=${_description.text}"
                  "&task_number=1"
                  "&attachment="
                  "&summary=sample summery"),
              headers: {
                "Accept": "application/json",
                "Cookie": 'gate_token=${prefs.getString('token').toString()}'
              });

           */

            var res = await request.send();
            print(
                "res.reasonPhrase.toString() : " + res.reasonPhrase.toString());
            if (res.reasonPhrase.toString() == "Created") {
              Fluttertoast.showToast(
                  msg: "Successfully created",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.CENTER,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.red,
                  textColor: Colors.white,
                  fontSize: 16.0);
              Navigator.pop(context);
            } else {
              Fluttertoast.showToast(
                  msg: res.reasonPhrase.toString(),
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.CENTER,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.red,
                  textColor: Colors.white,
                  fontSize: 16.0);
            }
            _btnController.reset();
          }
          _btnController.reset();
        },
      ),
    );
  }
}
