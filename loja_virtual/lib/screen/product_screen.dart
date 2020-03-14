import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/material.dart';
import 'package:loja_virtual/datas/cart_product.dart';
import 'package:loja_virtual/datas/product_Data.dart';
import 'package:loja_virtual/models/caat_model.dart';
import 'package:loja_virtual/models/user_model.dart';
import 'package:loja_virtual/screen/cart_screen.dart';
import 'package:loja_virtual/screen/login_screen.dart';

class ProductScreen extends StatefulWidget {
  final ProductData produto;

  ProductScreen(this.produto);

  @override
  _ProductScreenState createState() => _ProductScreenState(this.produto);
}

class _ProductScreenState extends State<ProductScreen> {
  final ProductData produto;
  String cor;

  _ProductScreenState(this.produto);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(produto.title),
        centerTitle: true,
      ),
      body: ListView(
        children: <Widget>[
          AspectRatio(
            aspectRatio: 0.9,
            child: Carousel(
              autoplay: false,
              dotSize: 4.0,
              dotSpacing: 15.0,
              dotIncreaseSize: 4.0,
              dotBgColor: Colors.transparent,
              dotColor: Theme.of(context).primaryColor,
              images: produto.images.map((url) {
                return NetworkImage(url);
              }).toList(),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Text(
                  produto.title,
                  style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w500),
                  maxLines: 3,
                ),
                Text(
                  "R\$ ${produto.price.toStringAsFixed(2)}",
                  style: TextStyle(
                    fontSize: 22.0,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                SizedBox(
                  height: 16.0,
                ),
                Text(
                  "Cores",
                  style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500),
                ),
                SizedBox(
                  height: 34.0,
                  child: GridView(
                    padding: EdgeInsets.symmetric(vertical: 4.0),
                    scrollDirection: Axis.horizontal,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 1,
                      mainAxisSpacing: 8.0,
                      childAspectRatio: 0.5,
                    ),
                    children: produto.cores.map((cores) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            cor = cores;
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.all(Radius.circular(4.0)),
                            border: Border.all(
                                color: cores == cor
                                    ? Theme.of(context).primaryColor
                                    : Colors.grey,
                                width: 3.0),
                          ),
                          width: 50.0,
                          alignment: Alignment.center,
                          child: Text(cores),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                SizedBox(
                  height: 16.0,
                ),
                SizedBox(
                  height: 44.0,
                  child: RaisedButton(
                    color: Theme.of(context).primaryColor,
                    onPressed: cor != null ? (){

                      if (UserModel.of(context).isLoggedIn()){
                        CartProduct cartProduct = CartProduct();
                        cartProduct.color = cor;
                        cartProduct.quantity = 1;
                        cartProduct.pid = produto.id;
                        cartProduct.category = produto.category;
                        cartProduct.productData = produto;


                        CartModel.of(context).addCartItem(cartProduct);


                        Navigator.of(context).push(MaterialPageRoute( builder: (context) => CartScreen()));
                      }else{

                        Navigator.of(context).push(MaterialPageRoute( builder: (context) => LoginScreen()));
                      }



                    } : null,
                    child: Text( UserModel.of(context).isLoggedIn() ? "Adicionar ao carrinho!":"Entre para comprar", style: TextStyle(fontSize: 18.0, color: Colors.white),),
                  ),

                ),
                SizedBox(
                  height: 16.0,
                ),
                Text(
                  "Descrição",
                  style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500),
                ),
                Text(
                  produto.description,
                  style: TextStyle(fontSize: 16.0),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
