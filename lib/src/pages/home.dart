import 'package:flutter/material.dart';
import 'package:gunting_batu_kertas/src/pages/game.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ElevatedButton(
            onPressed: () => Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => const GamePage()),
              (route) => false,
            ),
            child: const Text("Mulai Sekarang"),
          ),
        ),
      ),
    );
  }
}
