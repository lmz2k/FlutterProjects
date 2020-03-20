import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gerenciadorlojavirutal/blocs/products_bloc.dart';
import 'package:gerenciadorlojavirutal/validators/product_validator.dart';
import 'package:gerenciadorlojavirutal/widgets/add_product_sizes.dart';
import 'package:gerenciadorlojavirutal/widgets/images_widget.dart';

class ProductScreen extends StatefulWidget {
  final String categoryID;
  final DocumentSnapshot product;

  ProductScreen({this.categoryID, this.product});

  @override
  _ProductScreenState createState() =>
      _ProductScreenState(this.categoryID, this.product);
}

class _ProductScreenState extends State<ProductScreen> with ProductValidator {
  final _productBloc;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();

  _ProductScreenState(String categoryID, DocumentSnapshot product)
      : _productBloc = ProductBloc(categoryID: categoryID, product: product);

  @override
  Widget build(BuildContext context) {
    InputDecoration _buildDecoration(String label) {
      return InputDecoration(
          labelText: label, labelStyle: TextStyle(color: Colors.grey));
    }

    final fieldStyle = TextStyle(color: Colors.white, fontSize: 16);

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.grey[850],
      appBar: AppBar(
        backgroundColor: Colors.pinkAccent,
        elevation: 0,
        title: StreamBuilder<bool>(
            stream: _productBloc.outCreate,
            initialData: false,
            builder: (context, snapshot) {
              return Text(
                  snapshot.data == true ? "Editar Produto" : "Criar Produto");
            }),
        actions: <Widget>[
          StreamBuilder<bool>(
            stream: _productBloc.outCreate,
            initialData: false,
            builder: (context, snapshot) {
              if (snapshot.data) {
                return StreamBuilder<bool>(
                    stream: _productBloc.outLoad,
                    initialData: false,
                    builder: (context, snapshot) {
                      return IconButton(
                        icon: Icon(Icons.remove),
                        onPressed: snapshot.data
                            ? null
                            : () {
                                _productBloc.deleteProduct();

                                Navigator.of(context).pop();


                              },
                      );
                    });
              } else {
                return Container();
              }
            },
          ),
          StreamBuilder<bool>(
              stream: _productBloc.outLoad,
              initialData: false,
              builder: (context, snapshot) {
                return IconButton(
                  icon: Icon(Icons.save),
                  onPressed: snapshot.data ? null : saveContent,
                );
              }),
        ],
      ),
      body: Stack(
        children: <Widget>[
          Form(
            key: _formKey,
            child: StreamBuilder<Map>(
                stream: _productBloc.outData,
                builder: (context, snapshot) {
                  if (!snapshot.hasData)
                    return Center(
                      child: CircularProgressIndicator(),
                    );

                  return ListView(
                    padding: EdgeInsets.all(16),
                    children: <Widget>[
                      Text(
                        "Imagens",
                        style: TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                      ImagesWidget(
                        context: context,
                        initialValue: snapshot.data["images"],
                        onSaved: _productBloc.saveImages,
                        validator: validateImage,
                      ),
                      TextFormField(
                        initialValue: snapshot.data["title"],
                        style: fieldStyle,
                        decoration: _buildDecoration("Titulo"),
                        onSaved: _productBloc.saveTitle,
                        validator: validateTitle,
                      ),
                      TextFormField(
                        initialValue: snapshot.data["description"],
                        style: fieldStyle,
                        maxLines: 6,
                        decoration: _buildDecoration("Descrição"),
                        onSaved: _productBloc.saveDescription,
                        validator: validateDescription,
                      ),
                      TextFormField(
                        style: fieldStyle,
                        initialValue:
                            snapshot.data["price"]?.toStringAsFixed(2),
                        decoration: _buildDecoration("Preço"),
                        keyboardType:
                            TextInputType.numberWithOptions(decimal: true),
                        onSaved: _productBloc.savePrice,
                        validator: validatePrice,
                      ),

                      SizedBox(height: 16,),
                      Text(
                        "Cores",
                        style: TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                      ProductColor(
                        context: context,
                        initialValue: snapshot.data['cores'],
                        onSaved: _productBloc.saveColors,
                        validator: (s){

                          if(s.isEmpty) return "Adicione um tamanho";

                        },
                      ),

                    ],
                  );
                }),
          ),
          StreamBuilder<bool>(
              stream: _productBloc.outLoad,
              initialData: false,
              builder: (context, snapshot) {
                return IgnorePointer(
                  ignoring: !snapshot.data,
                  child: Container(
                    color: snapshot.data ? Colors.black54 : Colors.transparent,
                  ),
                );
              }),
        ],
      ),
    );
  }

  void saveContent() async {
    if (_formKey.currentState.validate()) {
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text(
          "Salvando produto .... ",
          style: TextStyle(color: Colors.white),
        ),
        duration: Duration(minutes: 1),
        backgroundColor: Colors.pinkAccent,
      ));

      _formKey.currentState.save();
      bool success = await _productBloc.saveProduct();

      _scaffoldKey.currentState.removeCurrentSnackBar();

      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text(
          success ? "Salvo com sucesso!" : "Falha ao salvar, tente novamente",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.pinkAccent,
      ));
    }
  }
}
