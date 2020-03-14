import 'package:flutter/material.dart';
import 'package:loja_virtual/models/caat_model.dart';
import 'package:scoped_model/scoped_model.dart';


class CardPrice extends StatelessWidget {


  final VoidCallback buy;

  CardPrice(this.buy);


  @override
  Widget build(BuildContext context) {
    return Card(




      margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: Container(
        padding: EdgeInsets.all(16.0),
        child: ScopedModelDescendant<CartModel>(builder: (context, child, model){



          double price = model.getProductsPrice();
          double discount = model.getDiscount();
          double entrega = model.getShipPrice();



          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text("Resumo do pedido", textAlign: TextAlign.start,style: TextStyle(fontWeight: FontWeight.w500),),
              SizedBox(
                height: 12.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                   Text("Subtotal"),
                   Text("R\$ ${price.toStringAsFixed(2)}")
                ],
              ),
              Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text("Desconto"),
                  Text("R\$ ${discount.toStringAsFixed(2)}")
                ],
              ),
              Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text("Entrega"),
                  Text("R\$ ${entrega.toStringAsFixed(2)}")
                ],
              ),
              Divider(),
              SizedBox(
                height: 12.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text("Total", style: TextStyle(fontWeight: FontWeight.w500)),
                  Text("R\$ ${(price+entrega-discount).toStringAsFixed(2)}", style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 16.0 ),)
                ],
              ),
              SizedBox(
                height: 12.0,
              ),
              RaisedButton(
                child: Text('Finalizar pedido'),
                textColor: Colors.white,
                color: Theme.of(context).primaryColor,
                onPressed: buy,

              )


            ],
          );
        },),
      ),

    );
  }
}
