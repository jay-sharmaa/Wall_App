import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:wall/like_button.dart';

class WallPost extends StatefulWidget {
  final String message;
  final String user;
  final String postId;
  final List<String> likes;
  const WallPost({super.key, required this.message, required this.user, required this.postId, required this.likes});

  @override
  State<WallPost> createState() => _WallPostState();
}

class _WallPostState extends State<WallPost> {

  final curruser = FirebaseAuth.instance.currentUser!;
  bool isLiked = false;
  @override
  void initState() {
    super.initState();
    isLiked = widget.likes.contains(curruser);
  }

  void toggleLikes(){
    setState(() {
      isLiked = !isLiked;
    });

    DocumentReference postRef = FirebaseFirestore.instance.collection("User Posts").doc(widget.postId);
    if(isLiked){
      postRef.update({
        'Likes': FieldValue.arrayUnion([curruser.email])
      });
    }
    else{
      postRef.update({
        'Likes': FieldValue.arrayRemove([curruser.email])
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Column(
            children: [
              LikeButton(isLiked: true, onClick: (){}),
              const SizedBox(height: 8),
              const Text("")
            ],
          ),
          Column(
            children: [
              Text(widget.user),
              Text(widget.message)
            ],
          ),
        ],
      ),
    );
  }
}
