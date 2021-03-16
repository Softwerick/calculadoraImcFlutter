import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_format/date_format.dart';

class PesagemTile extends StatelessWidget {
  final DocumentSnapshot snapshot;
  PesagemTile(this.snapshot);

  final List<Color> colors = [
    Colors.red,
    Colors.green,
    Colors.orange,
  ];

  @override
  Widget build(BuildContext context) {
    String _data = formatDate(snapshot.data["data"].toDate(),
        [dd, '/', mm, '/', yyyy, ' ', HH, ':', mm]);
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: Column(
        children: [
          SizedBox(
            height: 8.0,
          ),
          Text(
              "Peso: ${snapshot.data["peso"]} || Altura: ${snapshot.data["altura"]}",
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: colors[snapshot.data["status"]],
                  fontWeight: FontWeight.bold,
                  fontSize: 17.0)),
          SizedBox(
            height: 8.0,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text("I.M.C: ${snapshot.data["imc"].toStringAsPrecision(4)}",
                    style:
                        TextStyle(fontWeight: FontWeight.w400, fontSize: 14.0)),
                Text(_data,
                    style:
                        TextStyle(fontWeight: FontWeight.w400, fontSize: 14.0)),
              ],
            ),
          ),
          SizedBox(
            height: 8.0,
          ),
        ],
      ),
    );
  }
}
