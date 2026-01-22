import 'package:flutter/material.dart';

class Cosmetics extends StatelessWidget {
  const Cosmetics({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Category 5')),
      body: const Center(
        child: Text(
          'Products of Category 5',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
        ),
      ),
    );
  }
}
