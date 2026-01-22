import 'package:flutter/material.dart';

class Oils extends StatelessWidget {
  const Oils({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Category 3')),
      body: const Center(
        child: Text(
          'Products of Category 3',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
        ),
      ),
    );
  }
}
