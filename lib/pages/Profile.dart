import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final curruser = FirebaseAuth.instance.currentUser!;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile Page"),
        backgroundColor: Colors.grey.shade900,
      ),
      body: Column(
        children: [
          Icon(Icons.person, size: 64,),
          Text(curruser.email!, textAlign: TextAlign.center,),
          SizedBox(height: 16,),
          Padding(
            padding: const EdgeInsets.only(left:15),
            child: Text("Details",
            style: TextStyle(fontSize: 20)),
          )
        ],
      ),
    );
  }
}
