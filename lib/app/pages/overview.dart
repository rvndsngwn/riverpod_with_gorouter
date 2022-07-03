import 'package:flutter/material.dart';

class OverView extends StatelessWidget {
  final String title;
  final String subtitle;
  final String imageUrl;
  const OverView(
      {Key? key,
      required this.title,
      required this.subtitle,
      required this.imageUrl})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(child: Image.network(imageUrl)),
          Text(subtitle),
        ],
      ),
    );
  }
}
