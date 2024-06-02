import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:wall/comment.dart';
import 'package:wall/delete_post.dart';
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
  TextEditingController comment = TextEditingController();
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

  void addComment(String commentText){
    FirebaseFirestore.instance.collection("User Posts").doc(widget.postId).collection("Comments").add(
        {
          "Comments" : commentText,
          "User" : curruser,
          "Time" : Timestamp.now()
        },
    );
  }

  void myShowDialog(){
    showDialog(context: context, builder: (context){
      return AlertDialog(
        title: const Text("Write A Comment"),
        content: TextField(
          controller: comment,
          decoration: InputDecoration(
            hintText: "Your Comment",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4)
            )
          ),
        ),
        actions: [
          IconButton(onPressed: (){
            addComment(comment.text);
            Navigator.pop(context);
          }, icon: const Icon(Icons.upload)),
          IconButton(onPressed: (){
            Navigator.pop(context);
          }, icon: const Icon(Icons.cancel))
        ],
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Column(
            children: [
              LikeButton(isLiked: true, onClick: (){
                toggleLikes();
              }),
              const SizedBox(height: 8),
              const Text("")
            ],
          ),
          Column(
            children: [
              Text(widget.user),
              Text(widget.message),

              IconButton(onPressed: (){
                myShowDialog();
              }, icon: Icon(Icons.comment)),
              StreamBuilder(stream: FirebaseFirestore.instance.collection("User Posts").doc(widget.postId).collection("Comments").orderBy("Time", descending: true).snapshots(),
                  builder: (context, snapshot){
                    if(!snapshot.hasData){
                      return CircularProgressIndicator();
                    }
                    else{
                      return ListView(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        children: snapshot.data!.docs.map((doc) => (Comment(text: doc["Comments"], user: doc["User"], time: formatDate(doc['Time'])))).toList()
                      );
                    }
                  })
            ],
          ),
          if(widget.user == curruser.email) DeletePost(postId: widget.postId)
        ],
      ),
    );
  }
  String formatDate(Timestamp timestamp){
    DateTime dateTime = timestamp.toDate();

    String year = dateTime.year.toString();
    String month = dateTime.month.toString();
    String day = dateTime.day.toString();
    String formattedDate = '$day/$month/$year';

    return formattedDate;
  }
}
