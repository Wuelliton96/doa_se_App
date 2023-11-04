import 'package:flutter/material.dart';

class ItemList extends StatelessWidget {
  const ItemList({super.key});

  // const ItemList({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      color: Colors.white,
      child: Row(
        children: <Widget>[
          Image.network("https://images7.alphacoders.com/469/469456.jpg",width: 130, height: 150,fit: BoxFit.cover,),
        const Expanded(
          child: Padding(
            padding: EdgeInsets.all(12.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget> [
                Text("Carro", 
                softWrap: true,
                style: TextStyle(fontWeight: FontWeight.w400),),
                Text("Em bom estado de uso"),
                Text("14 agosto 21:38", style: TextStyle(fontSize: 12, color: Colors.grey)),
              ],
            ),
          ),
        ),
        ]
      ),
    );
  }
}