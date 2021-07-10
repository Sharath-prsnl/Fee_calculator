// @dart=2.9
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:fee_calculator/mainscreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Fee Calculator',
            theme: ThemeData(
              primaryColor: Colors.blue[900],
              scaffoldBackgroundColor: Colors.white,
            ),
            home: mainscreen(),
          );
        }
}

