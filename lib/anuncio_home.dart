import 'package:doa_se_app/box_card.dart';
import 'package:flutter/material.dart';

class AnuncioHome extends StatelessWidget {
  const AnuncioHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: BoxCard(boxContent: _AnuncioHome()),
    );
  }
}

class _AnuncioHome extends StatelessWidget {
  const _AnuncioHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [Text('texto text 01')],
    );
  }
}
