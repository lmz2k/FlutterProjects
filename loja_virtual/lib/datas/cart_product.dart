import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:loja_virtual/datas/product_Data.dart';

class CartProduct{



  String cid;
  String category;
  String pid;


  int quantity;
  String color;

  ProductData productData;


  CartProduct();

  CartProduct.fromDocument(DocumentSnapshot document){
      this.cid = document.documentID;
      this.category = document.data["category"];
      this.pid = document.data["pid"];
      this.quantity = document.data["quantity"];
      this.color = document.data['color'];

  }
  Map<String, dynamic> toMap(){
    return{
      "category":category,
      "pid":pid,
      "quantity":quantity,
      "color":color,
      "product": productData.toResumedMap()
  };
}





}