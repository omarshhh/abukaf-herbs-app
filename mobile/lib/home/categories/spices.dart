import 'package:flutter/material.dart';

class Spices extends StatelessWidget {
  const Spices({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Category 2')),
      body: const Center(
        child: Text(
          'Products of Category 2',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
        ),
      ),
    );
  }
}
