import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class PlaceTile extends StatelessWidget {
  final DocumentSnapshot document;

  PlaceTile(this.document);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            height: 100.0,
            child: Image.network(
              document.data['image'],
              fit: BoxFit.cover,
            ),
          ),
          Container(
            padding: EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  document.data['title'],
                  textAlign: TextAlign.start,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17.0),
                ),
                Text(
                  document.data['adress'],
                  textAlign: TextAlign.start,
                ),
              ],
            ),
          ),
          Row(

            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              FlatButton(
                child: Text(
                  "Ver no mapa"
                ),
                textColor: Colors.blue,
                padding: EdgeInsets.zero,
                onPressed: (){
                  launch()
                },


              )
            ],





          )
        ],
      ),
    );
  }
}
