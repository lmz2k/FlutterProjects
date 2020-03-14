import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    home: Home(),
  ));
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String _infoText = ("Informe seus dados!");
  GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  TextEditingController controlePeso = new TextEditingController();
  TextEditingController controleAltura = new TextEditingController();

  void resetarAplicativo() {
    setState(() {
      controlePeso.text = "";
      controleAltura.text = "";
      _infoText = ("Informe seus dados!");
    });
  }

  void calcularIMC() {
    setState(() {
      double peso = double.parse(controlePeso.text);
      double altura = double.parse(controleAltura.text) / 100;

      double IMC = peso / (altura * altura);

      if (IMC < 16.6) {
        _infoText = "Abaixo do peso (${IMC.toStringAsPrecision(2)})";
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Calculadora IMC"),
          centerTitle: true,
          backgroundColor: Colors.green,
          actions: <Widget>[
            IconButton(icon: Icon(Icons.refresh), onPressed: resetarAplicativo)
          ],
        ),
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
            child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Icon(
                      Icons.person_outline,
                      size: 210,
                      color: Colors.green,
                    ),
                    TextFormField(
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                            labelText: "Peso em KG:",
                            labelStyle: TextStyle(color: Colors.green)),
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.green),
                        controller: controlePeso,
                        validator:(value){
                          if (value.isEmpty) {
                            return "Insira seu Peso";
                          }
                        }
                        ),
                    TextFormField(
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                          labelText: "Altura em CM:",
                          labelStyle: TextStyle(color: Colors.green)),
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.green),
                      controller: controleAltura,
                      validator: (value) {
                        if (value.isEmpty) {
                          return "Insira sua altura";
                        }
                      },
                    ),
                    Padding(
                        padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                        child: Container(
                          height: 40.0,
                          child: RaisedButton(
                            onPressed: (){
                              if (_formKey.currentState.validate()){
                                calcularIMC();
                            }},
                            child: Text("Calcular",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 25.0)),
                            color: Colors.green,
                          ),
                        )),
                    Text(
                      _infoText,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.green, fontSize: 25),
                    )
                  ],
                ))));
  }
}
