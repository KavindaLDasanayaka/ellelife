import 'package:ellelife/core/utils/colors.dart';
import 'package:ellelife/src/feed/domain/entities/post.dart';
import 'package:flutter/material.dart';

class Postpage extends StatelessWidget {
  final Post post;
  const Postpage({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 25),
              Text(
                post.postCaption,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                  color: mainColor,
                ),
              ),
              const SizedBox(height: 20),
              Image.network(post.postImage),
              const SizedBox(height: 20),
              Text(
                "${post.likes.toString()} likes",
                style: TextStyle(
                  color: mainWhite,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
