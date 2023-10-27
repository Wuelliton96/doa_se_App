import 'package:doa_se_app/itemlist.dart';
import 'package:flutter/material.dart';

class AnuncioHome extends StatefulWidget {
  const AnuncioHome({Key? key}) : super(key: key);

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
        backgroundColor: Colors.grey[200],
        body: Column(
          children: <Widget>[
            Expanded(
              child: ListView.separated(
              itemCount: 30,
              itemBuilder: (BuildContext context, int index) {
                return const ItemList();
              }, separatorBuilder: (BuildContext context, int index){
                return Container(height: 10,);
              }
            ),
          )
        ]
      )
    );
  }
}