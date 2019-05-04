import 'package:flutter/material.dart';
// import 'ui/task.dart';
import 'ui/new_subject.dart';
import 'ui/task2.dart';
// import 'ui/task3.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
        initialRoute: "/",
        routes: {
          "/": (context) => TaskScreen(),
          // "/": (context) => Homepage(),
          "/new_subject":(context) => NewSubjectScreen()
        }
    );
  }
}