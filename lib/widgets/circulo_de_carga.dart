import 'package:flutter/material.dart';

class CirculoDeCarga extends StatelessWidget {
  const CirculoDeCarga({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(top: 20),
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
