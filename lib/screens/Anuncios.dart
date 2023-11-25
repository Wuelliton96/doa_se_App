// Importações necessárias
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doa_se_app/screens/detalhes_Anuncio.dart';
import 'package:flutter/material.dart';

import '../models/inserirAnuncio.dart';
import '../widgets/cust_itemAnuncio.dart';

// Classe responsável por renderizar a tela de anúncios
class Anuncios extends StatefulWidget {
  const Anuncios({Key? key}) : super(key: key);

  @override
  State<Anuncios> createState() => _AnunciosState();
}

class _AnunciosState extends State<Anuncios> {
  // Lista de itens do menu
  List<String> itensMenu = [];
  // Controlador de Stream para os dados do Firestore
  final _controller = StreamController<QuerySnapshot>.broadcast();

  // Método para adicionar um ouvinte para atualizações nos anúncios
  _adicionarListenerAnuncios() async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    Stream<QuerySnapshot> stream = db.collection("anuncios").snapshots();
    stream.listen((dados) {
      _controller.add(dados);
    });
  }

  @override
  void initState() {
    super.initState();
    _adicionarListenerAnuncios();
  }

  @override
  Widget build(BuildContext context) {
    // Widget de carregamento enquanto os dados estão sendo carregados
    var carregandoDados = const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircularProgressIndicator(),
          Text("Carregando anúncios"),
        ],
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text("Doa-se"),
      ),
      body: Container(
        child: Column(
          children: [
            StreamBuilder(
              stream: _controller.stream,
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                    return carregandoDados;
                  case ConnectionState.waiting:
                    return carregandoDados;
                  case ConnectionState.active:
                  case ConnectionState.done:
                    QuerySnapshot querySnapshot = snapshot.data!;
                    if (querySnapshot.docs.isEmpty) {
                      return Container(
                        padding: const EdgeInsets.all(100),
                        child: const Text(
                          "Nenhum anúncio! 😢",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      );
                    } else {
                      return Expanded(
                        child: ListView.builder(
                            itemCount: querySnapshot.docs.length,
                            itemBuilder: (_, indice) {
                              List<DocumentSnapshot> anuncios =
                                  querySnapshot.docs.toList();
                              DocumentSnapshot documentSnapshot =
                                  anuncios[indice];
                              Anuncio anuncio = Anuncio.fromDocumentSnapshot(
                                  documentSnapshot);
                              return ItemAnuncio(
                                anuncio: anuncio,
                                onTapItem: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              DetalhesAnuncio(anuncio)));
                                },
                              );
                            }),
                      );
                    }
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
