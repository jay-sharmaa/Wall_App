import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DeletePost extends StatefulWidget {
  final String postId;
  const DeletePost({super.key, required this.postId});

  @override
  State<DeletePost> createState() => _DeletePostState();
}

class _DeletePostState extends State<DeletePost> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Icon(Icons.cancel, color: Colors.grey),
      onTap: (){
        showDialog(context: context, builder: (context){
          return AlertDialog(
            title: const Text("Delete Post"),
            content: Text("Sure??"),
            actions: [
              IconButton(onPressed: () async{
                final commentDocs = await FirebaseFirestore.instance.collection("User Posts").doc(widget.postId).collection("Comments").get();
                for(var doc in commentDocs.docs){
                  await FirebaseFirestore.instance.collection("User Posts").doc(widget.postId).collection("Comments").doc(doc.id).delete();
                }
                FirebaseFirestore.instance.collection("User Posts").doc(widget.postId).delete();
              }, icon: Icon(Icons.thumb_up)),
              IconButton(onPressed: (){
                Navigator.pop(context);
              }, icon: Icon(Icons.thumb_down))
            ]
          );
        });
      },
    );
  }
}
