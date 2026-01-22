import 'package:flutter/material.dart';

class Honey extends StatelessWidget {
  const Honey({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Category 4')),
      body: const Center(
        child: Text(
          'Products of Category 4',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
        ),
      ),
    );
  }
}
