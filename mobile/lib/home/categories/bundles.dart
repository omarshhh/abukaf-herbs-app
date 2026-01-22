import 'package:flutter/material.dart';

class Bundles extends StatelessWidget {
  const Bundles({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Category 7')),
      body: const Center(
        child: Text(
          'Products of Category 7',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
        ),
      ),
    );
  }
}
