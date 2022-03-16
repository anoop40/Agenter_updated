
import 'package:agenter_updated/plan_listing.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
class subscription_details extends StatefulWidget{
  final _email;
  final _name;
  subscription_details(this._email,this._name);
  _subscription_details createState() => _subscription_details();
}
class _subscription_details extends State<subscription_details>{
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Align(
            alignment: Alignment.topRight,
            child: TextButton(
              onPressed: (){
                Navigator.pop(context);
              },
              child: Text("Done"),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
                top: MediaQuery.of(context).size.height * 0.01),
            child: ChoiceChip(
              backgroundColor: Colors.greenAccent,
              label: Text(widget._name[0],
                style: TextStyle(
                    color: Colors.black,
                    fontSize: MediaQuery.of(context).size.width * 0.1),
              ),
              selected: true,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
                top: MediaQuery.of(context).size.height * 0.01),
            child: Text(widget._name,
              style: TextStyle(fontSize: 19),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
                top: MediaQuery.of(context).size.height * 0.01),
            child: Text(
              "Email : ${widget._email}",
              style: TextStyle(fontSize: 16, color: Colors.black45),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
                top: MediaQuery.of(context).size.height * 0.01),
            child: Text(
              "Plan : ${widget._email}",
              style: TextStyle(fontSize: 16, color: Colors.black45),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
                top: MediaQuery.of(context).size.height * 0.01),
            child: Text(
              "Expiry : ${widget._email}",
              style: TextStyle(fontSize: 16, color: Colors.black45),
            ),
          ),
          Divider(),
          ListTile(
            leading: FaIcon(FontAwesomeIcons.tasks,size: 16, color: Colors.blue[900],),
            title: Text("Plans"),
            trailing: Icon(Icons.navigate_next),
            onTap: (){
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) =>  plan_listing()),
              );
            },
          ),
          Divider(),
          ListTile(
            leading: FaIcon(FontAwesomeIcons.download,size: 16, color: Colors.blue[900],),
            title: Text("Download invoice"),
            trailing: Icon(Icons.navigate_next),
          ),
          Divider(),
          ListTile(
            leading: FaIcon(FontAwesomeIcons.trash, color: Colors.red,),
            title: Text("Cancel Subscription"),
          ),

        ],
      ),
    );
  }
}
