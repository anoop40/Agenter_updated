import 'package:flutter/material.dart';

class Accordion extends StatefulWidget {
  final String title;
  final  content;

  const Accordion({Key? key, required this.title, required this.content})
      : super(key: key);
  @override
  _AccordionState createState() => _AccordionState();
}

class _AccordionState extends State<Accordion> {
  bool _showContent = false;
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      ListTile(
        leading: Icon(
          _showContent ? Icons.remove : Icons.add
        , color: Colors.blue,),
        title: Text(widget.title, style: TextStyle(color: Colors.blue),),
        onTap: (){
          setState(() {
            _showContent = !_showContent;
          });
        },
      ),
      _showContent
          ? Container(
        padding: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.06),
        child: widget.content,
      )
          : Container()
    ]);
  }
}