import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loja_virtual/datas/cart_product.dart';
import 'package:loja_virtual/datas/product_Data.dart';
import 'package:loja_virtual/models/caat_model.dart';







class CartTile extends StatelessWidget {

  final CartProduct cp;

  CartTile(this.cp);





  @override
  Widget build(BuildContext context) {

    Widget _buildContent(){

      CartModel.of(context).updatePrices();


      return Row(
        mainAxisAlignment: MainAxisAlignment.start,


          children: <Widget>[

          Container(
            padding: EdgeInsets.all(8.0),
            width: 120.0,
            child: Image.network(cp.productData.images[0],fit: BoxFit.cover,),
          ),

          Expanded(

            child: Container(

              padding: EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    cp.productData.title, style: TextStyle(fontWeight: FontWeight.w500, fontSize: 17.0),
                  ),
                  Text(
                    "Cor: ${cp.color}", style: TextStyle(fontWeight: FontWeight.w300),
                  ),
                  Text(
                    "R\$: ${cp.productData.price.toStringAsFixed(2)}", style: TextStyle(color: Theme.of(context).primaryColor, fontSize:16.0, fontWeight: FontWeight.bold),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      IconButton(
                        color: Theme.of(context).primaryColor,
                        icon: Icon(Icons.remove),
                        onPressed: cp.quantity > 1 ? (){

                          CartModel.of(context).decProduct(cp);






                        } : null,
                      ),
                      Text(
                        "${cp.quantity.toString()}"
                      ),
                      IconButton(
                        color: Theme.of(context).primaryColor,
                        icon: Icon(Icons.add),
                        onPressed: (){

                          CartModel.of(context).incProduct(cp);



                        },
                      ),

                      FlatButton(
                        child: Text("Remover", style: TextStyle(color: Colors.grey),),
                        onPressed: (){

                          CartModel.of(context).removerCartItem(cp);
                        },
                      )
                    ],
                  )
                ],

              ),
            ),
          )



        ],
      );



    }

    return Card(
      margin: EdgeInsets.symmetric(horizontal: 8.0,vertical: 4.0),

      child: cp.productData == null ? FutureBuilder<DocumentSnapshot>(
        future: Firestore.instance.collection("products").document(cp.category).collection("itens").document(cp.pid).get(),
        builder: (context, snapshot){

          if(snapshot.hasData){
            cp.productData = ProductData.fromDocument(snapshot.data);
            return _buildContent();
          }else{
            return Container(
              height: 70,
              child: CircularProgressIndicator(),
              alignment: Alignment.center,
            );
          }
        },

      ) :
      _buildContent(),
    );
  }
}
