import 'package:calculadora_imc/main.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:calculadora_imc/tile_pesagens.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Pesagens"),
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance
            .collection("pesagens")
            .orderBy("data", descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return Center(child: CircularProgressIndicator());
          else
            return ListView(
              children: snapshot.data.documents
                  .map((doc) => PesagemTile(doc))
                  .toList(),
            );
        },
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => home()));
          },
          child: Icon(Icons.add)),
    );
  }
}
