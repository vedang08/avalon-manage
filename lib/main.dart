import 'package:avalon_manage/pages/login.dart';
import 'package:avalon_manage/scoped-models/registrations.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

void main() async {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp();
  final RegistrationModel _model = RegistrationModel();
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScopedModel(
      model: _model,
      child: MaterialApp(
          title: 'Avalon Accounts',
          theme: ThemeData(
            // This is the theme of your application.
            //
            // Try running your application with "flutter run". You'll see the
            // application has a blue toolbar. Then, without quitting the app, try
            // changing the primarySwatch below to Colors.green and then invoke
            // "hot reload" (press "r" in the console where you ran "flutter run",
            // or simply save your changes to "hot reload" in a Flutter IDE).
            // Notice that the counter didn't reset back to zero; the application
            // is not restarted.
            primarySwatch: Colors.blue,
          ),
          routes: {
            '/': (BuildContext context) => LoginPage(),
          },
          onGenerateRoute: (RouteSettings settings) {
            if (!_model.isAuthenticated) {
              return MaterialPageRoute(builder: (BuildContext context) {
                LoginPage();
              });
            }
          }),
    );
  }
}
