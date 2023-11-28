// Importações necessárias
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../models/inserirAnuncio.dart';
import '../widgets/cust_itemAnuncioUsuario.dart';

// Classe responsável por renderizar a tela de anúncios
class AnunciosUsuario extends StatefulWidget {
  const AnunciosUsuario({Key? key}) : super(key: key);

  @override
  State<AnunciosUsuario> createState() => _AnunciosUsuarioState();
}

class _AnunciosUsuarioState extends State<AnunciosUsuario> {
  String? _idUsuarioLogado;
  // Lista de itens do menu
  List<String> itensMenu = [];
  // Controlador de Stream para os dados do Firestore
  final _controller = StreamController<QuerySnapshot>.broadcast();

  //Método para verificar o usuário logado e
  //salva a id do usuário em: _idUsuarioLogado
  _usuarioLogado() {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? usuarioLogado = auth.currentUser;
    _idUsuarioLogado = usuarioLogado?.uid;
  }

  // Método para adicionar um ouvinte para atualizações nos anúncios
  _adicionarListenerAnuncios() async {
    _usuarioLogado();
    FirebaseFirestore db = FirebaseFirestore.instance;
    Stream<QuerySnapshot> stream = db
        .collection("meus_anuncios")
        .doc(_idUsuarioLogado)
        .collection("anuncios")
        .snapshots();
    stream.listen((dados) {
      _controller.add(dados);
    });
  }

  // Método para deletar anúncios do usuário logado
  _removerAnuncio(String idAnuncio) async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    await db
        .collection("meus_anuncios")
        .doc(_idUsuarioLogado)
        .collection("anuncios")
        .doc(idAnuncio)
        .delete()
        .then((_) async {
      await db.collection("anuncios").doc(idAnuncio).delete();
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
        backgroundColor: Colors.red,
        title: const Text("Meus Anúncios"),
      ),
      // ignore: avoid_unnecessary_containers
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
                          "Nenhum anúncio encontrado.\n\nFaça uma doação!",
                          textAlign: TextAlign.center,
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
                              return ItemAnuncioUsuario(
                                anuncio: anuncio,
                                //botao para remoção do anúncio do usuário
                                onPressedRemover: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: const Text("Confirmar exclusão"),
                                        content: const Text(
                                            "Deseja realmente excluir o anúncio?"),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: const Text(
                                              "Não",
                                              style: TextStyle(
                                                  color: Colors.black),
                                            ),
                                          ),
                                          ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.red,
                                            ),
                                            onPressed: () async {
                                              await _removerAnuncio(anuncio.id);
                                              Future.microtask(() =>
                                                  Navigator.of(context).pop());
                                            },
                                            child: const Text(
                                              "Excluir",
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  );
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
