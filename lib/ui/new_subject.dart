import 'package:flutter/material.dart';
import '../Model/todo.dart';
import '../DB/db.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NewSubjectScreen extends StatelessWidget{
 
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  final TextEditingController textControl = new TextEditingController();
  static final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key:scaffoldKey,
        appBar: AppBar(
          title: Container(
              child: Text("New Subject"),
              margin: EdgeInsets.fromLTRB(60, 20, 0, 50)),
        ),
        body: Builder(
            // Create an inner BuildContext so that the onPressed methods
            // can refer to the Scaffold with Scaffold.of().
            builder: (BuildContext context) {
          return Form(
            key: _formKey,
            child: ListView(
              children: <Widget>[
                Container(
                  child: TextFormField(
                    decoration: InputDecoration(
                      hintText: "Subject",
                    ),
                    controller: textControl,
                    onSaved: (value) => print(value),
                    validator: (value) {
                      if (value.isEmpty) {
                        return "Please fill subject";
                      }
                    },
                  ),
                  margin: EdgeInsets.fromLTRB(15, 0, 15, 0),
                ),
                Container(
                  child: RaisedButton(
                    child:
                        Text("Save", style: TextStyle(color: Colors.white)),
                    color: Theme.of(context).accentColor,
                    onPressed: () async{
                      if (!_formKey.currentState.validate()) {
                        Scaffold.of(context).showSnackBar(SnackBar(
                          content: Text("Please fill subject"),
                        ));
                      } else {

                        Todo todo = new Todo(title: textControl.text, done: 0);
                        Firestore.instance.collection('todo').document().setData({'title':todo.title, 'done': todo.done});


                        Fluttertoast.showToast(msg:"Todo was saved", toastLength:Toast.LENGTH_SHORT);
                        Navigator.pop(context);
                      }
                    },
                  ),
                  margin: EdgeInsets.fromLTRB(15, 0, 15, 0),
                )
              ],
            ),
          );
        }));
        }
}