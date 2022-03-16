
import 'package:agenter_updated/sign_in_page.dart';
import 'package:agenter_updated/sign_up.dart';
import 'package:camera/camera.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'landing_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp,DeviceOrientation.portraitDown])
      .then((_) => runApp(MyApp()),
  );

}
void getCameras() async {
  await availableCameras().catchError((e){});
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);
  _my_app createState() => _my_app();
}
class _my_app extends State<MyApp>{
  @override
  initState(){
    super.initState();
    getCameras();
  }
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: 'Agenter',
      theme: ThemeData(

        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => landing_page(),
        '/sign_in': (context) => sign_in_page(),
        '/sign_up' : (context) => sign_up(),
      },

    );
  }
}


