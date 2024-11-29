import 'package:cinemader/main.dart';
import 'package:flutter/material.dart';
import 'package:cinemader/lobby/signin.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cinemader/core/route/app_route.dart';
import 'package:cinemader/core/theme/app_theme.dart';
import 'package:cinemader/core/route/app_route_name.dart';

class DecisionTree extends StatefulWidget {
  const DecisionTree({super.key});

  @override
  State<DecisionTree> createState() => _DecisionTreeState();
}

class _DecisionTreeState extends State<DecisionTree> {
  User? user;
  @override
  void initState() {
    super.initState();
    onRefresh(FirebaseAuth.instance.currentUser);
  }

  onRefresh(userCred) {
    setState(() {
      user = userCred;
    });
  }

  Widget build(BuildContext context) {
    if (user == null) {
      print('to sign in');
      return Signin();
    }
    print('to Main');
    return MainWidget();
  }
}
