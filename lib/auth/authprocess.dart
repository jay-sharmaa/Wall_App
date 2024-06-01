import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:wall/pages/Home.dart';
import 'package:wall/pages/login.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(stream: FirebaseAuth.instance.authStateChanges(), builder: (context,  snapshot){
      if(snapshot.hasData){
        return Home();
      }
      else{
        return LoginPage();
      }
    });
  }
}
