import 'package:flutter/material.dart';
import 'package:loja_virtual/models/caat_model.dart';
import 'package:loja_virtual/models/user_model.dart';
import 'package:loja_virtual/screen/Order_screen.dart';
import 'package:loja_virtual/tiles/cart_tile.dart';
import 'package:loja_virtual/widgets/card_price.dart';
import 'package:loja_virtual/widgets/discount_card.dart';
import 'package:loja_virtual/widgets/ship_card.dart';
import 'package:scoped_model/scoped_model.dart';

import 'login_screen.dart';

class CartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Meu Carrinho"),
        centerTitle: true,
        actions: <Widget>[
          Container(
            padding: EdgeInsets.only(right: 8.0),
            child: ScopedModelDescendant<CartModel>(
              builder: (context, child, model) {
                int p = model.produccts.length;
                return Center(
                  child: Text(
                    "${p ?? 0} ${p == 1 ? "ITEM" : "ITENS"}",
                    style: TextStyle(fontSize: 17.0),
                  ),
                );
              },
            ),
          )
        ],
      ),
      body: ScopedModelDescendant<CartModel>(
        builder: (context, child, model) {
          print("entrei0");
          if (model.isLoading && UserModel.of(context).isLoggedIn()) {
            print("entrei1");
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (!UserModel.of(context).isLoggedIn()) {
            print("entrei2");
            return (Container(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      Icons.remove_shopping_cart,
                      size: 80,
                      color: Theme.of(context).primaryColor,
                    ),
                    Center(
                      child: Text(
                        "Entre para ver o carrinho!",
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).primaryColor),
                      ),
                    ),
                    RaisedButton(
                      color: Theme.of(context).primaryColor,
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => LoginScreen()));
                      },
                      child: Text(
                        "Entrar",
                        style: TextStyle(fontSize: 18.0, color: Colors.white),
                      ),
                    ),
                  ],
                )));
          } else if (model.produccts == null || model.produccts.length == 0) {
            return (Center(
              child: Text(
                "Carrinho Vazio!",
                style: TextStyle(
                    fontSize: 20,
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold),
              ),
            ));
          } else {
            return ListView(
              children: <Widget>[
                Column(
                  children: model.produccts.map((p){

                    return CartTile(p);
                  }).toList(),
                ),
                DicountCard(),
                ShipCard(),
                CardPrice(() async {
                  String OrderID = await model.finishOrder();

                  if(OrderID != null){
                    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => OrderScreen(OrderID)));
                  }

                }),
              ],
            );
          }
        },
      ),
    );
  }
}
