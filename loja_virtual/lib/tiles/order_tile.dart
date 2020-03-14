import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';


class OrderTile extends StatelessWidget {

  final String documentID;

  OrderTile(this.documentID);

  String _buildProductsText(DocumentSnapshot snapshot){
    String text = "Descrição:\n";


    for(LinkedHashMap m in snapshot.data["products"]){
        text += "${m["quantity"]} x ${m['product']['title']} (R\$ ${m['product']['price'].toStringAsFixed(2)})\n";

    }

    text += "Total: R\$ ${snapshot.data["totalPrice"].toStringAsFixed(2)}";
    return text;

  }

  Widget _buildCircle(String title, String subTitle, int status, int thisStatus){


    Color backColor;
    Widget child;

    if(status < thisStatus){
      backColor = Colors.grey[500];
      child = Text(title, style: TextStyle(color: Colors.white),);
    }else if (status == thisStatus){
      backColor = Colors.blue;
      child = Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Text(title, style: TextStyle(color: Colors.white),),
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          )
        ],
      );

    }else{

      backColor = Colors.green;
      child =  Icon(Icons.check, color: Colors.white,);

    }

    return Column(
      children: <Widget>[
        CircleAvatar(
          radius: 20,
          backgroundColor: backColor,
          child: child,
        ),
        Text(subTitle),
      ],
    );

  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: StreamBuilder<DocumentSnapshot>(
          stream: Firestore.instance.collection("orders").document(documentID).snapshots(),
          builder: (context, snapshot){

            if(!snapshot.hasData){
              return Center(
                child: CircularProgressIndicator(),
              );
            }else{


              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[

                  Text("Código do pedido: ${snapshot.data.documentID}",style: TextStyle(fontWeight: FontWeight.bold),),
                  SizedBox(height: 4.0,),
                  Text(_buildProductsText(snapshot.data)),
                  SizedBox(height: 4.0,),
                  Text("Status do pedido:",style: TextStyle(fontWeight: FontWeight.bold),),
                  SizedBox(height: 4.0,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[

                      _buildCircle("1", "Preparação", snapshot.data["status"], 1),
                      Container(
                        height: 1.0,
                        width: 40.0,
                        color: Colors.grey[500],
                      ),
                      _buildCircle("1", "Transporte", snapshot.data["status"], 2),
                      Container(
                        height: 1.0,
                        width: 40.0,
                        color: Colors.grey[500],
                      ),
                      _buildCircle("1", "Entrega", snapshot.data["status"], 3)

                    ],
                  )

                ],
              );

            }


          },
        ),


      ),
    );
  }
}
