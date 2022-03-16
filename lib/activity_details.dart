import 'dart:convert';

import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import 'edit_activity.dart';
class activity_details extends StatefulWidget{
  final activity_id;

  activity_details(this.activity_id);
  _activity_details createState() => _activity_details();
}
class _activity_details extends State<activity_details>{
  var activity_data;
  late Future str;
  final RoundedLoadingButtonController _btnController = RoundedLoadingButtonController();

  final _added_by = new TextEditingController();
  final _transaction_ref_no = new TextEditingController();
  final _closed_by = new TextEditingController();
  final _new_comment = new TextEditingController();
  final _transaction_added_date = new TextEditingController();
  final _closed_date = new TextEditingController();
  var _comments_container;
  late Map<String, String> headersMap;
  var _time_to_convert;
  String capitalize(String s) => s[0].toUpperCase() + s.substring(1);


  Future<bool> getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print("prefs.getString('token').toString() : "+prefs.getString('token').toString());
    var serverUrlfinal = "https://books.sambiya.com/book-keeping/task/${widget.activity_id}";

    var response = await http.get(Uri.parse(serverUrlfinal), headers: {
      "Accept": "application/json",
      "Cookie": 'gate_token=${prefs.getString('token').toString()}'
    });
    print("gete : " +prefs.getString('token').toString());
    print("Response body : " + response.body.toString());
    setState(() {
      activity_data = json.decode(response.body) ;
      headersMap = {
        "Accept": "application/json",
        "Cookie": 'gate_token=${prefs.getString('token').toString()}'
      };
    });
    /* get activity comments */
    var serverUrlfinal2 = "https://books.sambiya.com/book-keeping/task/comments/${widget.activity_id}";

    var response2 = await http.get(Uri.parse(serverUrlfinal2), headers: {
      "Accept": "application/json",
      "Cookie": 'gate_token=${prefs.getString('token').toString()}'
    });
    print("before");
    print("Response body comments : " + response2.body.toString());
    setState(() {
      _comments_container = json.decode(response2.body) ;

    });
    /* ends here */


    return true;
  }
  @override
  void initState() {
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
        title: Text("Activity", style: TextStyle(color: Colors.black),),
        actions: <Widget>[
          PopupMenuButton(
            icon: Icon(Icons.more_vert,color: Colors.black,),
            color: Colors.white,
            itemBuilder: (BuildContext bc) => [
              PopupMenuItem(child: Text("Edit"), value: "edit-activity"),
              PopupMenuItem(
                  child: Text("Delete"), value: "delete-activity"),
            ],
            onSelected: (route) {
              if(route.toString() == "delete-activity"){
                //print("activity_data['data']['id'] : " + activity_data['data']['id'].toString());
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text("Delete activity"),
                      content: Text("This will delete activity from records . Are you sure ? "),
                      actions: [
                        OutlinedButton(
                          child: Text("Cancel"),
                          onPressed:  () {
                            Navigator.pop(context);
                          },
                        ),
                       SizedBox(
                         width: MediaQuery.of(context).size.width * 0.2,
                         child:  RoundedLoadingButton(

                           child: Text('Continue', style: TextStyle(color: Colors.white)),
                           controller: _btnController,

                           onPressed: () async {
                             SharedPreferences prefs = await SharedPreferences.getInstance();

                             var serverUrlfinal = "https://books.sambiya.com/book-keeping/task/${activity_data['data']['id'].toString()}";

                             var response = await http.delete(Uri.parse(serverUrlfinal), headers: {
                               "Accept": "application/json",
                               "Cookie": 'gate_token=${prefs.getString('token').toString()}'
                             });
                            // print("response body : " +response.body.toString());
                             Fluttertoast.showToast(
                                 msg: "Successfully deleted",
                                 toastLength: Toast.LENGTH_SHORT,
                                 gravity: ToastGravity.CENTER,
                                 timeInSecForIosWeb: 1,
                                 backgroundColor: Colors.red,
                                 textColor: Colors.white,
                                 fontSize: 16.0
                             );
                             Navigator.pop(context);
                             Navigator.pop(context);
                           },
                           width: MediaQuery.of(context).size.width * 0.2,
                           color: Colors.blue[800],
                           borderRadius: 2.00,
                           height: MediaQuery.of(context).size.height * 0.04,
                         ),
                       ),

                      ],
                    );
                  },
                );
              }
              if(route.toString() == "edit-activity"){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => edit_activity(widget.activity_id)),
                );
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: FutureBuilder(
          future: str,
          builder: (context,snapshot){
            if(snapshot.hasData){
              // print(activity_data['data']['attachments'].toString());
              _added_by.text = activity_data['data']['user']['name'];
              _transaction_ref_no.text = activity_data['data']['id'].toString();
              _transaction_added_date.text = activity_data['data']['created_at'].toString();
              _closed_date.text = activity_data['data']['closed_at'].toString();


              activity_data['data']['closed_at'].toString() == "" ?
              _closed_date.text = "Not found":
              _closed_date.text = activity_data['data']['closed_at'].toString();

              activity_data['data']['accountant']['name'].toString() == "" ?
              _closed_by.text = "Not found"
                  :
              _closed_by.text = activity_data['data']['accountant']['name'].toString();


              return RefreshIndicator(
                onRefresh: getData,
                child: Column(
                  children: <Widget>[
                    Padding(
                        padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.03 ),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.9,
                          child: Text("Activity : ${activity_data['data']['id']}", style: TextStyle(color: Colors.black45, fontSize: 18),),
                        )
                    ),
                    Padding(
                        padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.01 ),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.9,
                          child: Text(activity_data['data']['summary'], style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
                        )
                    ),
                    Padding(
                        padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.01 ),
                        child: SizedBox(
                            width: MediaQuery.of(context).size.width * 0.9,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[

                                activity_data['data']['task_status'].toString() == "na" || activity_data['data']['task_status'].toString() == "open" ?
                                Chip(
                                  backgroundColor: Colors.green,
                                  label: const Text('OPEN', style: TextStyle(color: Colors.white),),
                                ) : Text("")

                              ],
                            )
                        )
                    ),
                    Padding(
                        padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.01 ),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.9,
                          child: Text(activity_data['data']['description'], style: TextStyle(fontSize: 16),),
                        )
                    ),
                    Padding(
                        padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.03 ),
                        child: SizedBox(
                            width: MediaQuery.of(context).size.width * 0.9,
                            child: Row(
                              children: const <Widget>[
                                Icon(Icons.attach_file, color: Colors.blue,),
                                Text("Attachments", style: TextStyle(color: Colors.blue, fontSize: 18),),
                              ],
                            )
                        )
                    ),
                    // Text(activity_data['data']['attachments'][0]['url'].toString()),
                    activity_data['data']['attachments'].isEmpty ?

                    Padding(
                      padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.02,bottom: MediaQuery.of(context).size.height * 0.02),
                      child: Text("No attachments found"),
                    )  :
                    Padding(
                      padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.02, left: MediaQuery.of(context).size.width * 0.04),

                      child: Row(
                        children: <Widget>[
                          Stack(
                            children: <Widget>[
                              // Image.file(File(data['file_name']))
            /*
                              SizedBox(


                                child: Hero(
                                  tag: 'Activity image',
                                  child: Image.network("https://books.sambiya.com/book-keeping/media/"+
                                      activity_data['data']['attachments'][0]['id'].toString(),
                                    headers: headersMap,
                                  ),
                                ),
                                width: MediaQuery.of(context).size.width * 0.4,
                              ),
                              */
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.4,
                                child: GestureDetector(

                                  onTap: () {
                                    Navigator.push(context, MaterialPageRoute(builder: (context) {
                                      return DetailScreen(activity_data['data']['attachments'][0]['id'].toString());
                                    }));
                                  },
                                  child: Hero(
                                    tag: 'imageHero',
                                    child: Image.network("https://books.sambiya.com/book-keeping/media/"+
                                        activity_data['data']['attachments'][0]['id'].toString(),
                                      headers: headersMap,
                                    ),
                                  ),
                                ),
                              ),

                            ],
                          ),
                        ],
                      ),
                    ),
                    Divider(),


                    /*
                    Image.network(
                        'https://books.sambiya.com/book-keeping/media/${activity_data['data']['attachments'][0]['id']}')
                    */
                    Align(
                      alignment: Alignment.topLeft,
                      child: ExpandableNotifier(  // <-- Provides ExpandableController to its children
                        child: Column(
                          children: [
                            Expandable(           // <-- Driven by ExpandableController from ExpandableNotifier
                              collapsed: ExpandableButton(  // <-- Expands when tapped on the cover photo
                                child: SizedBox(
                                  width: MediaQuery.of(context).size.width * 0.4,
                                  child: ListTile(
                                    title: Text("See more"),
                                    trailing: Icon(Icons.arrow_drop_down),
                                  ),
                                ),
                              ),
                              expanded: Column(
                                  children: [

                                    Padding(
                                      padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.02),
                                      child: Center(
                                        child: SizedBox(
                                          width: MediaQuery.of(context).size.width * 0.9,
                                          child: TextFormField(
                                            controller: _added_by,
                                            enabled: false,
                                            decoration: const InputDecoration(
                                              labelText: 'Added by',
                                            ),
                                            onSaved: (String? value) {
                                              // This optional block of code can be used to run
                                              // code when the user saves the form.
                                            },
                                            validator: (String? value) {
                                              return (value != null && value.contains('@')) ? 'Do not use the @ char.' : null;
                                            },
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.02),
                                      child: Center(
                                        child: SizedBox(
                                          width: MediaQuery.of(context).size.width * 0.9,
                                          child: TextFormField(
                                            controller: _closed_by,
                                            enabled: false,
                                            decoration: const InputDecoration(
                                              labelText: 'Closed by',
                                            ),
                                            onSaved: (String? value) {
                                              // This optional block of code can be used to run
                                              // code when the user saves the form.
                                            },
                                            validator: (String? value) {
                                              return (value != null && value.contains('@')) ? 'Do not use the @ char.' : null;
                                            },
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.02),
                                      child: Center(
                                        child: SizedBox(
                                          width: MediaQuery.of(context).size.width * 0.9,
                                          child: TextFormField(
                                            controller: _transaction_ref_no,
                                            enabled: false,
                                            decoration: const InputDecoration(
                                              labelText: 'Transaction Ref No#',
                                            ),
                                            onSaved: (String? value) {
                                              // This optional block of code can be used to run
                                              // code when the user saves the form.
                                            },
                                            validator: (String? value) {
                                              return (value != null && value.contains('@')) ? 'Do not use the @ char.' : null;
                                            },
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.02),
                                      child: Center(
                                        child: SizedBox(
                                          width: MediaQuery.of(context).size.width * 0.9,
                                          child: TextFormField(
                                            controller: _transaction_ref_no,
                                            enabled: false,
                                            decoration: const InputDecoration(
                                              labelText: 'Document Ref No#',
                                            ),
                                            onSaved: (String? value) {
                                              // This optional block of code can be used to run
                                              // code when the user saves the form.
                                            },
                                            validator: (String? value) {
                                              return (value != null && value.contains('@')) ? 'Do not use the @ char.' : null;
                                            },
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.02),
                                      child: Center(
                                        child: SizedBox(
                                          width: MediaQuery.of(context).size.width * 0.9,
                                          child: TextFormField(
                                            controller: _transaction_added_date,
                                            enabled: false,
                                            decoration: const InputDecoration(
                                              labelText: 'Added date ',
                                            ),
                                            onSaved: (String? value) {
                                              // This optional block of code can be used to run
                                              // code when the user saves the form.
                                            },
                                            validator: (String? value) {
                                              return (value != null && value.contains('@')) ? 'Do not use the @ char.' : null;
                                            },
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.02),
                                      child: Center(
                                        child: SizedBox(
                                          width: MediaQuery.of(context).size.width * 0.9,
                                          child: TextFormField(
                                            controller: _closed_date,
                                            enabled: false,
                                            decoration: const InputDecoration(
                                              labelText: 'Closed date',
                                            ),
                                            onSaved: (String? value) {
                                              // This optional block of code can be used to run
                                              // code when the user saves the form.
                                            },
                                            validator: (String? value) {
                                              return (value != null && value.contains('@')) ? 'Do not use the @ char.' : null;
                                            },
                                          ),
                                        ),
                                      ),
                                    ),

                                    ExpandableButton(       // <-- Collapses when tapped on
                                      child: SizedBox(
                                        width: MediaQuery.of(context).size.width * 0.4,
                                        child: ListTile(
                                          title: Text("Show less"),
                                          trailing: Icon(Icons.arrow_drop_up),
                                        ),
                                      ),
                                    ),
                                  ]
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.topLeft,
                      child: ExpandableNotifier(  // <-- Provides ExpandableController to its children
                        child: Column(
                          children: [
                            Expandable(           // <-- Driven by ExpandableController from ExpandableNotifier
                              collapsed: ExpandableButton(  // <-- Expands when tapped on the cover photo
                                child: SizedBox(
                                  width: MediaQuery.of(context).size.width * 0.4,
                                  child: ListTile(
                                    title: Text("Comments"),
                                    trailing: Icon(Icons.arrow_drop_down),
                                  ),
                                ),
                              ),
                              expanded: Column(
                                  children: [


                                    Padding(
                                      padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.02),
                                      child: Center(
                                        child: SizedBox(
                                          width: MediaQuery.of(context).size.width * 0.9,
                                          child: TextFormField(

                                            controller: _new_comment,
                                            decoration: InputDecoration(
                                              labelText: 'Add comment here',
                                              suffixIcon: IconButton(
                                                onPressed: () async {
                                                  SharedPreferences prefs = await SharedPreferences.getInstance();
                                                  if(_new_comment.text == ""){
                                                    Fluttertoast.showToast(
                                                        msg: "Please type some text",
                                                        toastLength: Toast.LENGTH_SHORT,
                                                        gravity: ToastGravity.CENTER,
                                                        timeInSecForIosWeb: 1,
                                                        backgroundColor: Colors.red,
                                                        textColor: Colors.white,
                                                        fontSize: 16.0
                                                    );
                                                  }
                                                  else{
                                                    var response = await http.post(
                                                        Uri.parse(
                                                            "https://books.sambiya.com/book-keeping/comment/${activity_data['data']['id']}?"
                                                                "&comment=${_new_comment.text}"
                                                        ),
                                                        headers: {
                                                          "Accept": "application/json",
                                                          "Cookie": 'gate_token=${prefs.getString('token').toString()}'
                                                        });
                                                    var resultCon = json.decode(response.body);
                                                    print("resultCon response.body: " + response.body.toString());
                                                    _new_comment.clear();
                                                    setState(() async {
                                                      Fluttertoast.showToast(
                                                          msg: "Comment successfully posted",
                                                          toastLength: Toast.LENGTH_SHORT,
                                                          gravity: ToastGravity.CENTER,
                                                          timeInSecForIosWeb: 1,
                                                          backgroundColor: Colors.red,
                                                          textColor: Colors.white,
                                                          fontSize: 16.0
                                                      );
                                                      /* get activity comments */
                                                      var serverUrlfinal2 = "https://books.sambiya.com/book-keeping/task/comments/${widget.activity_id}";

                                                      var response2 = await http.get(Uri.parse(serverUrlfinal2), headers: {
                                                        "Accept": "application/json",
                                                        "Cookie": 'gate_token=${prefs.getString('token').toString()}'
                                                      });
                                                      print("before");
                                                      print("Response body comments : " + response2.body.toString());
                                                      setState(() {
                                                        _comments_container = json.decode(response2.body) ;

                                                      });
                                                      /* ends here */
                                                    });

                                                  }
                                                },
                                                icon: Icon(Icons.send),
                                              ),
                                            ),
                                            onSaved: (String? value) {
                                              // This optional block of code can be used to run
                                              // code when the user saves the form.
                                            },
                                            validator: (String? value) {
                                              return (value != null && value.contains('@')) ? 'Do not use the @ char.' : null;
                                            },
                                          ),
                                        ),
                                      ),
                                    ),
                                    // _comments_container,
                                    ListView(
                                        scrollDirection: Axis.vertical,
                                        physics: ScrollPhysics(),
                                        shrinkWrap: true,
                                        padding: const EdgeInsets.all(8),
                                        children: List.generate(_comments_container['data'].length,(index) =>

                                            Column(
                                              children: <Widget>[
                                                Padding(
                                                  padding: EdgeInsets.only(top: MediaQuery
                                                      .of(context)
                                                      .size
                                                      .height * 0.02),
                                                  child: Center(
                                                    child: SizedBox(
                                                      width: MediaQuery
                                                          .of(context)
                                                          .size
                                                          .width * 0.9,
                                                      child: ListTile(
                                                        leading: CircleAvatar(
                                                          backgroundColor: Colors.blue,
                                                          child: Text(capitalize(_comments_container['data'][index]['user']['name'][0])),
                                                          maxRadius: 30,
                                                          foregroundImage: NetworkImage("enterImageUrl"),
                                                        ),
                                                        title: Row(
                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          children: <Widget>[
                                                            Text(capitalize(_comments_container['data'][index]['user']['name'].toString())),
                                                            //Text(DateFormat('hh:mm a').format(_comments_container['data'][index]['created_at']), style: TextStyle(
                                                            Text("2:25 am", style: TextStyle(
                                                              //1642838265

                                                              //Text(DateTime.parse(DateTime.fromMicrosecondsSinceEpoch(_comments_container['data'][index]['created_at'].microsecondsSinceEpoch).toDate().toString()).toString(), style: TextStyle(
                                                                color: Colors.black26, fontSize: MediaQuery
                                                                .of(context)
                                                                .size
                                                                .width * 0.03),),
                                                          ],
                                                        ),
                                                        subtitle: Text(_comments_container['data'][index]['comment'].toString()),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Divider(),

                                              ],
                                            )
                                        )
                                    ),



                                    ExpandableButton(       // <-- Collapses when tapped on
                                      child: SizedBox(
                                        width: MediaQuery.of(context).size.width * 0.4,
                                        child: ListTile(
                                          title: Text("Show less"),
                                          trailing: Icon(Icons.arrow_drop_up),
                                        ),
                                      ),
                                    ),
                                  ]
                              ),
                            ),
                          ],
                        ),
                      ),
                    )


                  ],
                ),);
            }
            else{
              return Center(
                child: Padding(
                  padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.4),
                  child: CircularProgressIndicator(),
                ),
              );
            }
          },
        ),
      )
      /*
      body: FutureBuilder(
        future: str,
        builder: (context,snapshot){
          if(snapshot.hasData){
            // print(activity_data['data']['attachments'].toString());
            _added_by.text = activity_data['data']['user']['name'];
            _transaction_ref_no.text = activity_data['data']['id'].toString();
            _transaction_added_date.text = activity_data['data']['created_at'].toString();
            _closed_date.text = activity_data['data']['closed_at'].toString();


            activity_data['data']['closed_at'].toString() == "" ?
            _closed_date.text = "Not found":
            _closed_date.text = activity_data['data']['closed_at'].toString();

            activity_data['data']['accountant']['name'].toString() == "" ?
            _closed_by.text = "Not found"
                :
            _closed_by.text = activity_data['data']['accountant']['name'].toString();


            return RefreshIndicator(
              onRefresh: getData,
            child: Column(
              children: <Widget>[
                Padding(
                    padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.03 ),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.9,
                      child: Text("Activity : ${activity_data['data']['id']}", style: TextStyle(color: Colors.black45, fontSize: 18),),
                    )
                ),
                Padding(
                    padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.01 ),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.9,
                      child: Text(activity_data['data']['summary'], style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
                    )
                ),
                Padding(
                    padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.01 ),
                    child: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.9,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[

                            activity_data['data']['task_status'].toString() == "na" || activity_data['data']['task_status'].toString() == "open" ?
                            Chip(
                              backgroundColor: Colors.green,
                              label: const Text('OPEN', style: TextStyle(color: Colors.white),),
                            ) : Text("")

                          ],
                        )
                    )
                ),
                Padding(
                    padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.01 ),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.9,
                      child: Text(activity_data['data']['description'], style: TextStyle(fontSize: 16),),
                    )
                ),
                Padding(
                    padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.03 ),
                    child: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.9,
                        child: Row(
                          children: const <Widget>[
                            Icon(Icons.attach_file, color: Colors.blue,),
                            Text("Attachments", style: TextStyle(color: Colors.blue, fontSize: 18),),
                          ],
                        )
                    )
                ),
                // Text(activity_data['data']['attachments'][0]['url'].toString()),
                activity_data['data']['attachments'].isEmpty ?

                Padding(
                  padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.02,bottom: MediaQuery.of(context).size.height * 0.02),
                  child: Text("No attachments found"),
                )  :
                Padding(
                  padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.02, left: MediaQuery.of(context).size.width * 0.04),

                  child: Row(
                    children: <Widget>[
                      Stack(
                        children: <Widget>[
                          // Image.file(File(data['file_name']))
                          SizedBox(


                            child: Image.network("https://books.sambiya.com/book-keeping/media/"+
                                activity_data['data']['attachments'][0]['id'].toString(),
                              headers: headersMap,
                            ),
                            width: MediaQuery.of(context).size.width * 0.4,
                          ),

                        ],
                      ),
                    ],
                  ),
                ),
                Divider(),


                /*
                    Image.network(
                        'https://books.sambiya.com/book-keeping/media/${activity_data['data']['attachments'][0]['id']}')
                    */
                Align(
                  alignment: Alignment.topLeft,
                  child: ExpandableNotifier(  // <-- Provides ExpandableController to its children
                    child: Column(
                      children: [
                        Expandable(           // <-- Driven by ExpandableController from ExpandableNotifier
                          collapsed: ExpandableButton(  // <-- Expands when tapped on the cover photo
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width * 0.4,
                              child: ListTile(
                                title: Text("See more"),
                                trailing: Icon(Icons.arrow_drop_down),
                              ),
                            ),
                          ),
                          expanded: Column(
                              children: [

                                Padding(
                                  padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.02),
                                  child: Center(
                                    child: SizedBox(
                                      width: MediaQuery.of(context).size.width * 0.9,
                                      child: TextFormField(
                                        controller: _added_by,
                                        enabled: false,
                                        decoration: const InputDecoration(
                                          labelText: 'Added by',
                                        ),
                                        onSaved: (String? value) {
                                          // This optional block of code can be used to run
                                          // code when the user saves the form.
                                        },
                                        validator: (String? value) {
                                          return (value != null && value.contains('@')) ? 'Do not use the @ char.' : null;
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.02),
                                  child: Center(
                                    child: SizedBox(
                                      width: MediaQuery.of(context).size.width * 0.9,
                                      child: TextFormField(
                                        controller: _closed_by,
                                        enabled: false,
                                        decoration: const InputDecoration(
                                          labelText: 'Closed by',
                                        ),
                                        onSaved: (String? value) {
                                          // This optional block of code can be used to run
                                          // code when the user saves the form.
                                        },
                                        validator: (String? value) {
                                          return (value != null && value.contains('@')) ? 'Do not use the @ char.' : null;
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.02),
                                  child: Center(
                                    child: SizedBox(
                                      width: MediaQuery.of(context).size.width * 0.9,
                                      child: TextFormField(
                                        controller: _transaction_ref_no,
                                        enabled: false,
                                        decoration: const InputDecoration(
                                          labelText: 'Transaction Ref No#',
                                        ),
                                        onSaved: (String? value) {
                                          // This optional block of code can be used to run
                                          // code when the user saves the form.
                                        },
                                        validator: (String? value) {
                                          return (value != null && value.contains('@')) ? 'Do not use the @ char.' : null;
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.02),
                                  child: Center(
                                    child: SizedBox(
                                      width: MediaQuery.of(context).size.width * 0.9,
                                      child: TextFormField(
                                        controller: _transaction_ref_no,
                                        enabled: false,
                                        decoration: const InputDecoration(
                                          labelText: 'Document Ref No#',
                                        ),
                                        onSaved: (String? value) {
                                          // This optional block of code can be used to run
                                          // code when the user saves the form.
                                        },
                                        validator: (String? value) {
                                          return (value != null && value.contains('@')) ? 'Do not use the @ char.' : null;
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.02),
                                  child: Center(
                                    child: SizedBox(
                                      width: MediaQuery.of(context).size.width * 0.9,
                                      child: TextFormField(
                                        controller: _transaction_added_date,
                                        enabled: false,
                                        decoration: const InputDecoration(
                                          labelText: 'Added date ',
                                        ),
                                        onSaved: (String? value) {
                                          // This optional block of code can be used to run
                                          // code when the user saves the form.
                                        },
                                        validator: (String? value) {
                                          return (value != null && value.contains('@')) ? 'Do not use the @ char.' : null;
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.02),
                                  child: Center(
                                    child: SizedBox(
                                      width: MediaQuery.of(context).size.width * 0.9,
                                      child: TextFormField(
                                        controller: _closed_date,
                                        enabled: false,
                                        decoration: const InputDecoration(
                                          labelText: 'Closed date',
                                        ),
                                        onSaved: (String? value) {
                                          // This optional block of code can be used to run
                                          // code when the user saves the form.
                                        },
                                        validator: (String? value) {
                                          return (value != null && value.contains('@')) ? 'Do not use the @ char.' : null;
                                        },
                                      ),
                                    ),
                                  ),
                                ),

                                ExpandableButton(       // <-- Collapses when tapped on
                                  child: SizedBox(
                                    width: MediaQuery.of(context).size.width * 0.4,
                                    child: ListTile(
                                      title: Text("Show less"),
                                      trailing: Icon(Icons.arrow_drop_up),
                                    ),
                                  ),
                                ),
                              ]
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: ExpandableNotifier(  // <-- Provides ExpandableController to its children
                    child: Column(
                      children: [
                        Expandable(           // <-- Driven by ExpandableController from ExpandableNotifier
                          collapsed: ExpandableButton(  // <-- Expands when tapped on the cover photo
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width * 0.4,
                              child: ListTile(
                                title: Text("Comments"),
                                trailing: Icon(Icons.arrow_drop_down),
                              ),
                            ),
                          ),
                          expanded: Column(
                              children: [


                                Padding(
                                  padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.02),
                                  child: Center(
                                    child: SizedBox(
                                      width: MediaQuery.of(context).size.width * 0.9,
                                      child: TextFormField(

                                        controller: _new_comment,
                                        decoration: InputDecoration(
                                          labelText: 'Add comment here',
                                          suffixIcon: IconButton(
                                            onPressed: () async {
                                              SharedPreferences prefs = await SharedPreferences.getInstance();
                                              if(_new_comment.text == ""){
                                                Fluttertoast.showToast(
                                                    msg: "Please type some text",
                                                    toastLength: Toast.LENGTH_SHORT,
                                                    gravity: ToastGravity.CENTER,
                                                    timeInSecForIosWeb: 1,
                                                    backgroundColor: Colors.red,
                                                    textColor: Colors.white,
                                                    fontSize: 16.0
                                                );
                                              }
                                              else{
                                                var response = await http.post(
                                                    Uri.parse(
                                                        "https://books.sambiya.com/book-keeping/comment/${activity_data['data']['id']}?"
                                                            "&comment=${_new_comment.text}"
                                                    ),
                                                    headers: {
                                                      "Accept": "application/json",
                                                      "Cookie": 'gate_token=${prefs.getString('token').toString()}'
                                                    });
                                                var resultCon = json.decode(response.body);
                                                print("resultCon response.body: " + response.body.toString());
                                                _new_comment.clear();
                                                setState(() async {
                                                  Fluttertoast.showToast(
                                                      msg: "Comment successfully posted",
                                                      toastLength: Toast.LENGTH_SHORT,
                                                      gravity: ToastGravity.CENTER,
                                                      timeInSecForIosWeb: 1,
                                                      backgroundColor: Colors.red,
                                                      textColor: Colors.white,
                                                      fontSize: 16.0
                                                  );
                                                  /* get activity comments */
                                                  var serverUrlfinal2 = "https://books.sambiya.com/book-keeping/task/comments/${widget.activity_id}";

                                                  var response2 = await http.get(Uri.parse(serverUrlfinal2), headers: {
                                                    "Accept": "application/json",
                                                    "Cookie": 'gate_token=${prefs.getString('token').toString()}'
                                                  });
                                                  print("before");
                                                  print("Response body comments : " + response2.body.toString());
                                                  setState(() {
                                                    _comments_container = json.decode(response2.body) ;

                                                  });
                                                  /* ends here */
                                                });

                                              }
                                            },
                                            icon: Icon(Icons.send),
                                          ),
                                        ),
                                        onSaved: (String? value) {
                                          // This optional block of code can be used to run
                                          // code when the user saves the form.
                                        },
                                        validator: (String? value) {
                                          return (value != null && value.contains('@')) ? 'Do not use the @ char.' : null;
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                                // _comments_container,
                                ListView(
                                    scrollDirection: Axis.vertical,
                                    physics: ScrollPhysics(),
                                    shrinkWrap: true,
                                    padding: const EdgeInsets.all(8),
                                    children: List.generate(_comments_container['data'].length,(index) =>

                                        Column(
                                          children: <Widget>[
                                            Padding(
                                              padding: EdgeInsets.only(top: MediaQuery
                                                  .of(context)
                                                  .size
                                                  .height * 0.02),
                                              child: Center(
                                                child: SizedBox(
                                                  width: MediaQuery
                                                      .of(context)
                                                      .size
                                                      .width * 0.9,
                                                  child: ListTile(
                                                    leading: CircleAvatar(
                                                      backgroundColor: Colors.blue,
                                                      child: Text(capitalize(_comments_container['data'][index]['user']['name'][0])),
                                                      maxRadius: 30,
                                                      foregroundImage: NetworkImage("enterImageUrl"),
                                                    ),
                                                    title: Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: <Widget>[
                                                        Text(capitalize(_comments_container['data'][index]['user']['name'].toString())),
                                                        //Text(DateFormat('hh:mm a').format(_comments_container['data'][index]['created_at']), style: TextStyle(
                                                        Text("2:25 am", style: TextStyle(
                                                          //1642838265

                                                          //Text(DateTime.parse(DateTime.fromMicrosecondsSinceEpoch(_comments_container['data'][index]['created_at'].microsecondsSinceEpoch).toDate().toString()).toString(), style: TextStyle(
                                                            color: Colors.black26, fontSize: MediaQuery
                                                            .of(context)
                                                            .size
                                                            .width * 0.03),),
                                                      ],
                                                    ),
                                                    subtitle: Text(_comments_container['data'][index]['comment'].toString()),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Divider(),

                                          ],
                                        )
                                    )
                                ),



                                ExpandableButton(       // <-- Collapses when tapped on
                                  child: SizedBox(
                                    width: MediaQuery.of(context).size.width * 0.4,
                                    child: ListTile(
                                      title: Text("Show less"),
                                      trailing: Icon(Icons.arrow_drop_up),
                                    ),
                                  ),
                                ),
                              ]
                          ),
                        ),
                      ],
                    ),
                  ),
                )


              ],
            ),);
          }
          else{
            return Center(
              child: Padding(
                padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.4),
                child: CircularProgressIndicator(),
              ),
            );
          }
        },
      ),
        */
    );
  }
}
class DetailScreen extends StatefulWidget {
  final image_name;
  DetailScreen(this.image_name);
  _Detailscreen createState() => _Detailscreen();
}
class _Detailscreen extends State<DetailScreen>{

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          Navigator.pop(context);
        },
        child: Center(
          child: Hero(
            tag: 'imageHero',
            child: Image.network("https://books.sambiya.com/book-keeping/media/"+ widget.image_name),
          ),
        ),
      ),
    );
  }
}