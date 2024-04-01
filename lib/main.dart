import 'package:flutter/material.dart';
import 'listOfState.dart';
import 'login.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => Login(),
        '/states': (context) => ListOfState(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/states') {
          return MaterialPageRoute(
            builder: (context) => ListOfState(),
          );
        }
        return null;
      },
    );
  }
}
