import 'package:flutter/material.dart';

class FullScreenImage extends StatelessWidget {
  final String imageUrl;
  const FullScreenImage({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Hero(
          tag: "profilePic-${imageUrl}",
          child: Image.network(imageUrl, fit: BoxFit.contain),
        ),
      ),
    );
  }
}
