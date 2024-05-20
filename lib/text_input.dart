import 'package:flutter/material.dart';

class TextInput extends StatelessWidget {
const TextInput({ super.key , this.text});

  final String? text;

  @override
  Widget build(BuildContext context){
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
      child: TextField(
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          hintText: text,
        ),
      ),
    );
  }
}