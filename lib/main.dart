import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:calculadora_imc/home_screen.dart';

void main() {
  runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Calculadora IMC",
      home: HomeScreen(),
      theme: ThemeData(accentColor: Colors.blue, primaryColor: Colors.green)));
}

class home extends StatefulWidget {
  @override
  _homeState createState() => _homeState();
}

class _homeState extends State<home> {
  TextEditingController _pesoController = TextEditingController();
  TextEditingController _alturaController = TextEditingController();

  String _infoText = "Informe Seus Dados";
  double peso, altura, imc;
  bool _activeButton = false;
  int status;

  void _verificarImc() {
    setState(() {
      if (imc < 18.6) {
        _infoText =
            "Seu IMC está em: ${imc.toStringAsPrecision(4)}, você está abaixo do peso";
        status = 0;
      } else if (imc >= 18.6 && imc < 24.9) {
        _infoText =
            "Seu IMC está em: ${imc.toStringAsPrecision(4)}, seu peso é ideal";
        status = 1;
      } else if (imc >= 24.9 && imc < 29.9) {
        _infoText =
            "Seu IMC está em: ${imc.toStringAsPrecision(4)}, você está levemente acima do peso";
        status = 2;
      } else if (imc >= 29.9 && imc < 34.9) {
        _infoText =
            "Seu IMC está em: ${imc.toStringAsPrecision(4)}, você está com Obesidade Grau I";
        status = 2;
      } else if (imc >= 34.9 && imc < 39.9) {
        _infoText =
            "Seu IMC está em: ${imc.toStringAsPrecision(4)}, você está com Obesidade Grau II";
        status = 0;
      } else {
        _infoText =
            "Seu IMC está em: ${imc.toStringAsPrecision(4)}, você está com obesidade Grau III";
        status = 0;
      }
    });
  }

  void _calcular() {
    peso = double.parse(_pesoController.text.replaceAll(',', '.'));
    altura = double.parse(_alturaController.text.replaceAll(',', '.'));
    imc = peso / (altura * altura);
    _verificarImc();
    /*setState(() {
      _infoText = "Seu IMC está em: ${imc.toStringAsPrecision(4)}";
    });*/
  }

  void _sendData() {
    Firestore.instance.collection("pesagens").add({
      "altura": altura,
      "peso": peso,
      "imc": imc,
      "status": status,
      "data": Timestamp.now()
    });
  }

  void _limparCampos() {
    _pesoController.text = '';
    _alturaController.text = '';
    setState(() {
      _infoText = "Informe Seus Dados";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Calculadora IMC"),
          centerTitle: true,
          backgroundColor: Colors.green,
          actions: [
            IconButton(
              icon: Icon(Icons.refresh),
              onPressed: _limparCampos,
            ),
          ],
        ),
        body: SingleChildScrollView(
            child: Padding(
          padding: EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 0.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Icon(
                Icons.fitness_center,
                size: 120.0,
                color: Colors.grey,
              ),
              TextField(
                onChanged: (text) {
                  if (_alturaController.text.isNotEmpty &&
                      _pesoController.text.isNotEmpty) {
                    _calcular();
                    _activeButton = true;
                  } else {
                    _activeButton = false;
                  }
                },
                controller: _pesoController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: "Peso (Kg)",
                  labelStyle: TextStyle(
                    color: Colors.green,
                  ),
                ),
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.green,
                  fontSize: 25.0,
                ),
              ),
              TextField(
                onChanged: (text) {
                  if (_alturaController.text.isNotEmpty &&
                      _pesoController.text.isNotEmpty) {
                    _calcular();
                    _activeButton = true;
                  } else {
                    _activeButton = false;
                  }
                },
                controller: _alturaController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: "Altura (m)",
                  labelStyle: TextStyle(
                    color: Colors.green,
                  ),
                ),
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.green,
                  fontSize: 25.0,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                child: Container(
                  height: 50.0,
                  child: RaisedButton(
                    onPressed: _activeButton == true
                        ? () {
                            _sendData();
                            Navigator.pop(context);
                          }
                        : null,
                    child: Text(
                      "Gravar Informações",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 25.0,
                      ),
                    ),
                    color: Colors.green,
                  ),
                ),
              ),
              Text(
                _infoText,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.green,
                  fontSize: 25.0,
                ),
              ),
            ],
          ),
        )));
  }
}
