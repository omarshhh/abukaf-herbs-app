import 'package:flutter/material.dart';

class Herbs extends StatelessWidget {
  const Herbs({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Category 1')),
      body: const Center(
        child: Text(
          'Products of Category 1',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
        ),
      ),
    );
  }
}
