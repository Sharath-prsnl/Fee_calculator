import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';

class newStudent extends StatefulWidget {
  @override
  _newStudentState createState() => _newStudentState();
}

class _newStudentState extends State<newStudent> {
  final _formKey = GlobalKey<FormState>(debugLabel: '_Student');
  var _name;
  var _fees;
  // ignore: deprecated_member_use
  final dates = new List<DateTime>.empty();
  TextEditingController name = new TextEditingController();
  TextEditingController fees = new TextEditingController();
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    // TODO: implement initState
    name = new TextEditingController();
    fees = new TextEditingController();
    super.initState();
  }

  // void _showDialog() {
  //   // flutter defined function
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       // return object of type Dialog
  //       return AlertDialog(
  //         title: new Text("Student Details"),
  //         content: Text("Name: " + _name),
  //         actions: <Widget>[
  //           // usually buttons at the bottom of the dialog
  //           new TextButton(
  //             child: new Text("Close"),
  //             onPressed: () {
  //               Navigator.of(context).pop();
  //             },
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    CollectionReference students = firestore.collection('Students');
    Future<void> addStudent() {
      // Call the user's CollectionReference to add a new user
      return firestore
          .collection('students')
          .add({
            'name': _name,
            'fees': _fees,
            'classes': 0,
            'dates': dates,
          })
          .then((value) => Navigator.pop(context))
          .catchError((error) => print("Failed to add Student: $error"));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Enter student details"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            TextFormField(
              key: _formKey,
              validator: (input) {
                if (input!.isEmpty) {
                  return "Enter student name";
                }
              },
              decoration: const InputDecoration(
                icon: Icon(Icons.person),
                labelText: 'Student Name',
              ),
              controller: name,
              onChanged: (input) {
                _name = input.toString();
                print(_name);
              },
            ),
            TextFormField(
              controller: fees,
              decoration: const InputDecoration(
                icon: Icon(
                  Icons.payments,
                ),
                labelText: 'Student fees',
              ),
              onChanged: (input) {
                _fees = int.parse(input.toString());
                print(_fees);
              },
            ),
            const SizedBox(height: 30),
            TextButton(
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.all(16.0),
                  primary: Colors.white,
                  textStyle: const TextStyle(fontSize: 20),
                  backgroundColor: Colors.blue[400],
                ),
                onPressed: addStudent,
                child: const Text("Confirm"))
          ],
        ),
      ),
    );
  }
}
