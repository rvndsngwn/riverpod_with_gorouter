import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomeView extends StatelessWidget {
  const HomeView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: ElevatedButton(
        onPressed: () {
          context.push(
              "/over-view?title=Over View Page&subtitle=This is dynamic data.&imageUrl=https://picsum.photos/id/1/200/300");
        },
        child: Text(
          "Click me".toUpperCase(),
          textScaleFactor: 3,
        ),
      ),
    );
  }
}
