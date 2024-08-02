import 'package:flutter/material.dart';

class SuccessScreen extends StatelessWidget {
const SuccessScreen({ super.key, required this.percentage });
  final String percentage;
  @override
  Widget build(BuildContext context){
    return Material(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(percentage),
          ],
        ),
      ),
    );
  }
}