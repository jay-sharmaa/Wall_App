import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:wall/myDrawer.dart';
import 'package:wall/wallpost.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final TextEditingController message = TextEditingController();
  final currentUser = FirebaseAuth.instance.currentUser;

  void postMessage(){
    if(message.text.isNotEmpty){
      FirebaseFirestore.instance.collection("User Posts").add({
        'user': currentUser!.email,
        'message': message.text,
        'TimeStamp': Timestamp.now(),
        'Likes': []
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey.shade300,
        appBar: AppBar(
          backgroundColor: Colors.grey.shade700,
          title: const Text("Wall"),
          actions: [
            IconButton(
                onPressed: () {
                  FirebaseAuth.instance.signOut();
                },
                icon: const Icon(Icons.logout),
            )
          ],
        ),
        drawer: MyDrawer(),
        body: Column(
          children: [
            Expanded(child: StreamBuilder(
              stream: FirebaseFirestore.instance.collection("User Posts").orderBy("TimeStamp", descending: false).snapshots(),
              builder: (context, snapshot){
                if(snapshot.hasData){
                  return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index){
                    final post = snapshot.data!.docs[index];
                    print("hi");
                    return WallPost(message: post['message'], user: post['user'], postId: post.id, likes: List<String>.from(post['Likes'] ?? []));
                  });
                }
                else if(snapshot.hasError){
                  return Text(snapshot.error.toString());
                }
                else{
                  return const CircularProgressIndicator();
                }
              },
            )),
            Center(
              child: SizedBox(
                width: 350,
                child: TextField(
                  controller: message,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                      ),
                    suffixIcon: IconButton(onPressed: (){
                      postMessage();
                      message.clear();
                    }, icon: const Icon(Icons.upload))
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10,),
            SizedBox(
              width: 350,
              child: Row(
                children: [
                  Text(currentUser!.email!, style: const TextStyle(fontWeight: FontWeight.bold),),
                ],
              ),
            )
          ],
        ),
    );
  }
}
