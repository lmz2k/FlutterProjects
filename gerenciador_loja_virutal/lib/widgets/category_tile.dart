import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gerenciadorlojavirutal/screens/product_screen.dart';
import 'package:gerenciadorlojavirutal/widgets/edit_category_dialog.dart';

class CategoryTile extends StatelessWidget {
  final DocumentSnapshot doc;

  CategoryTile(this.doc);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Card(
        child: ExpansionTile(
          title: Text(
            doc.data['title'],
            style:
                TextStyle(color: Colors.grey[850], fontWeight: FontWeight.bold),
          ),
          leading: GestureDetector

            (

            onTap: (){

              showDialog(context: context, builder: (context) => EditCategoryDialog());

            },
            child: CircleAvatar(
              backgroundImage: NetworkImage(doc.data['icon']),
              backgroundColor: Colors.white,
            ),
          ),
          children: <Widget>[
            FutureBuilder<QuerySnapshot>(
              future: doc.reference.collection("itens").getDocuments(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return Container();

                return Column(
                  children: snapshot.data.documents.map((doc) {
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(doc.data['images'][0]),
                        backgroundColor: Colors.white,
                      ),
                      title: Text(doc.data['title']),
                      trailing:
                          Text("R\$${doc.data["price"].toStringAsFixed(2)}"),
                      onTap: () {



                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => ProductScreen(categoryID: doc.documentID, product: doc)));



                      },
                    );
                  }).toList()
                    ..add(ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.white,
                        child: Icon(
                          Icons.add,
                          color: Colors.pinkAccent,
                        ),
                      ),
                      title: Text("Adicionar"),
                      onTap: () {


                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => ProductScreen(categoryID: doc.documentID)));


                      },
                    )),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
