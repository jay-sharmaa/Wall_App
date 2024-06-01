import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'RegisterPage.dart';

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final userPassword = TextEditingController();
  final userEmail = TextEditingController();
  bool visibilityText = false;

  void sigin()async{
    try {
      showDialog(context: context, builder: (context){
        return CircularProgressIndicator();
      });
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: userEmail.text, password: userPassword.text);
      if(context.mounted) Navigator.pop(context);
    }
    on FirebaseAuthException catch (e) {
      Navigator.pop(context);
      showDialog(context: context, builder: (context){
        return AlertDialog(
          title: Text(e.message!),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body:Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.wallet, size: 64,),
            const SizedBox(height: 20),
            SizedBox(
              width: 250,
              child: TextField(
                controller: userEmail,
                decoration: InputDecoration(
                  hintText: "Enter Your Email",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: 250,
              child: TextField(
                controller: userPassword,
                decoration: InputDecoration(
                  hintText: "Enter Your Password",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  suffixIcon: GestureDetector(child: visibilityText == false ?
                  const Icon(Icons.remove_red_eye_outlined) : const Icon(Icons.remove_red_eye), onTap: (){
                    setState(() {
                      visibilityText = !visibilityText;
                      print(visibilityText);
                    });
                  })
                ),
                obscureText: visibilityText,
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: 300,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(onPressed: (){
                    sigin();
                  }, child: Text("Login")),
                  const SizedBox(width: 80),
                  GestureDetector(child: Text("Register Now", style: TextStyle(color: Colors.blue),),
                    onTap: (){
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context){
                        return RegisterPage();
                      }));
                    },
                  )
                ],
              ),
            )
          ],
        ),
      )
    );
  }
}
