import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:loja_virtual/datas/cart_product.dart';
import 'package:loja_virtual/models/user_model.dart';
import 'package:scoped_model/scoped_model.dart';

class CartModel extends Model{

  UserModel  user;
  List<CartProduct> produccts = [];
  bool isLoading = false;

  String cupomCode;

  int discountPercentage = 0;


  CartModel(this.user){
    if(user.isLoggedIn() ) _loadCartItems();
  }

  static CartModel of(BuildContext context) =>ScopedModel.of<CartModel>(context);


  void addCartItem(CartProduct cartProduct){
    produccts.add(cartProduct);
    Firestore.instance.collection("users").document(user.firebaseUser.uid).collection("cart").add(cartProduct.toMap()).then((doc){
      cartProduct.cid = doc.documentID;
    });

    notifyListeners();


  }

  void removerCartItem(CartProduct cartProduct){


    Firestore.instance.collection("users").document(user.firebaseUser.uid).collection("cart").document(cartProduct.cid).delete();
    produccts.remove(cartProduct);

    notifyListeners();


  }

  Future<String> finishOrder() async {
    if(produccts.length == 0) return null;

    isLoading = true;
    notifyListeners();

    double productsPrice = getProductsPrice();
    double shipPrice = getShipPrice();
    double dicountPer = getDiscount();
    DocumentReference ref = await Firestore.instance.collection("orders").add({

      "clientId":user.firebaseUser.uid,
      "products": produccts.map((CartProduct) => CartProduct.toMap()).toList(),
      "shipPrice": shipPrice,
      "productsPrice":productsPrice,
      "discount":getDiscount(),
      "totalPrice":(productsPrice-dicountPer +shipPrice),
      "status":1

    });


    await Firestore.instance.collection("users").document(user.firebaseUser.uid).collection("orders").document(ref.documentID).setData({
      "orderID":ref.documentID
    });



    QuerySnapshot querry = await Firestore.instance.collection("users").document(user.firebaseUser.uid).collection("cart").getDocuments();


    for(DocumentSnapshot doc in querry.documents){

      doc.reference.delete();

    }

    produccts.clear();

    discountPercentage = 0;
    cupomCode = null;
    isLoading = false;


    notifyListeners();


    return ref.documentID;
  }

  void updatePrices(){
    notifyListeners();
  }

  void setCupom(String cupCod, int Percent){

    this.cupomCode = cupCod;
    this.discountPercentage = Percent;

  }

  double getProductsPrice(){

    double price = 0.0;

    for(CartProduct c in produccts){

      if (c.productData != null){
        price+= c.quantity * c.productData.price;
      }

    }

    return price;
  }

  double getShipPrice(){

      return 9.99;

  }

  double getDiscount(){


    return getProductsPrice() * discountPercentage / 100;


  }

  void decProduct(CartProduct cp){

    cp.quantity--;


    Firestore.instance.collection('users').document(user.firebaseUser.uid).collection("cart").document(cp.cid).updateData(cp.toMap());

    notifyListeners();

  }

  void incProduct(CartProduct cp){

    cp.quantity++;

    Firestore.instance.collection('users').document(user.firebaseUser.uid).collection("cart").document(cp.cid).updateData(cp.toMap());

    notifyListeners();
  }



 void _loadCartItems() async{


   QuerySnapshot qs = await Firestore.instance.collection('users').document(user.firebaseUser.uid).collection("cart").getDocuments();


   produccts = qs.documents.map((doc) => CartProduct.fromDocument(doc)).toList();



   notifyListeners();

 }

}