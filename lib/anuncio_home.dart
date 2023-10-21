import 'package:flutter/material.dart';


class AnuncioHome extends StatefulWidget {
  const AnuncioHome({super.key});

  @override
  State<AnuncioHome> createState() => _AnuncioHomeState();
}

class _AnuncioHomeState extends State<AnuncioHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Doa-se'),
      ),
    );
  }
}