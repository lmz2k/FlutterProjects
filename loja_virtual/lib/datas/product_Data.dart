import 'package:cloud_firestore/cloud_firestore.dart';

class ProductData{

    String category;
    String id;
    String title;
    String description;

    double price;

    List images;
    List cores;


    ProductData.fromDocument(DocumentSnapshot snapshot){

      this.id = snapshot.documentID;
      this.title = snapshot.data["title"];
      this.description = snapshot.data["description"];
      this.price = snapshot.data["price"];
      this.images = snapshot.data["images"];
      this.cores = snapshot.data["cores"];
      
    }



    Map<String, dynamic> toResumedMap(){

      return{
        "title":title,
        "description":description,
        "price":price,

      };

    }


}