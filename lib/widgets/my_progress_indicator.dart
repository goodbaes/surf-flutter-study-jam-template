import 'package:flutter/material.dart';

class MyProgressIdicator extends StatelessWidget {
  const MyProgressIdicator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const CircularProgressIndicator(
      color: Colors.amber,
    );
  }
}
