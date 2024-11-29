import 'package:flutter/material.dart';
import 'package:cinemader/lobby/signin.dart';
import 'package:cinemader/lobby/signup.dart';

class Lobby extends StatelessWidget {
  const Lobby({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(title: Text("Sign in / Sign up")),
    body: 
    Padding(
      padding: const EdgeInsets.fromLTRB(5,3,5,3),
      child: Column(children: [
        SizedBox(
          width: double.infinity,
          child: 
          ElevatedButton.icon(
            icon: Icon(Icons.add),
            label: Text("Sign up",style:TextStyle(fontSize: 20)),
            onPressed: (){
              Navigator.push(context, MaterialPageRoute(
                builder: (context) => Signup()
                )
                );
            }),
        ),
        SizedBox(
          width: double.infinity,
          child: 
          ElevatedButton.icon(
            icon: Icon(Icons.login),
            label: Text("Sign in",style:TextStyle(fontSize: 20)),
            onPressed: (){
              Navigator.push(context, MaterialPageRoute(
                builder: (context) => Signin()
                )
                );
            }),
        ),
      ]),
    ),
    );
  }
}