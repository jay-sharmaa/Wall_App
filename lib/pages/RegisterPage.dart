import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:wall/auth/authprocess.dart';
import 'package:wall/pages/login.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final userPassword = TextEditingController();
  final userEmail = TextEditingController();
  bool visibilityText = false;

  void signup() async{
    showDialog(context: context, builder: (context){
      return CircularProgressIndicator();
    });
    try {
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: userEmail.text, password: userPassword.text);

      FirebaseFirestore.instance.collection("Users").doc(userCredential.user!.email).set({'username' : 'username'});
      if(context.mounted) Navigator.pop(context);
    } on FirebaseAuthException catch (e){
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
                      signup();
                    }, child: Text("Register")),
                    const SizedBox(width: 80),
                    GestureDetector(child: Text("Login Now", style: TextStyle(color: Colors.blue),),
                      onTap: (){
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context){
                          return LoginPage();
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
