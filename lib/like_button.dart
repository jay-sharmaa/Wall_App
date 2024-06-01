import 'package:flutter/material.dart';

class LikeButton extends StatelessWidget {
  final bool isLiked;
  final Function()? onClick;
  const LikeButton({required this.isLiked,required this.onClick,super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onClick,
      child: Icon(
          isLiked? Icons.favorite : Icons.favorite_border,
          color: isLiked? Colors.red : Colors.grey,
      ),
    );
  }
}
