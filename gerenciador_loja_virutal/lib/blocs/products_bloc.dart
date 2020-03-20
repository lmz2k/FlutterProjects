import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:rxdart/rxdart.dart';

class ProductBloc extends BlocBase {
  final _dataController = BehaviorSubject<Map>();
  final _loadingControlar = BehaviorSubject<bool>();
  final _createdControler = BehaviorSubject<bool>();

  Stream<Map> get outData => _dataController.stream;

  Stream<bool> get outLoad => _loadingControlar.stream;

  Stream<bool> get outCreate => _createdControler.stream;

  Map<String, dynamic> unsavedData;

  String categoryID;
  DocumentSnapshot product;

  ProductBloc({this.categoryID, this.product}) {
    if (product != null) {
      unsavedData = Map.of(product.data);
      unsavedData["images"] = List.of(product.data["images"]);
      unsavedData["cores"] = List.of(product.data["cores"]);

      _createdControler.add(true);
    } else {
      unsavedData = {
        "title": null,
        "description": null,
        "price": null,
        "images": [],
        "cores": [],
      };

      _createdControler.add(false);
    }

    _dataController.add(unsavedData);
  }

  void saveTitle(String title) {
    unsavedData["title"] = title;
  }

  void saveDescription(String description) {
    unsavedData["description"] = description;
  }

  void savePrice(String price) {
    unsavedData["price"] = double.parse(price);
  }

  void saveImages(List images) {
    unsavedData["images"] = images;
  }

  void saveColors(List cores) {
    unsavedData["cores"] = cores;
  }



  void deleteProduct() {
    product.reference.delete();
  }

  Future<bool> saveProduct() async {
    print("entrei");

    _loadingControlar.add(true);

    try {
      if (product != null) {
        await _uploadImages(product.documentID);
        await product.reference.updateData(unsavedData);
      } else {
        DocumentReference r = await Firestore.instance.collection("products")
            .document(categoryID).collection("itens")
            .add(Map.from(unsavedData)
          ..remove("images"));
        await _uploadImages(r.documentID);
        await r.updateData(unsavedData);
      }

      _loadingControlar.add(false);
      _createdControler.add(true);
      return true;
    } catch (e) {
      print("deu erro");
      _loadingControlar.add(false);
      return false;
    }
  }


  Future _uploadImages(String id) async {
    for (int i = 0; i < unsavedData["images"].length; i++) {
      if (unsavedData['images'][i] is String) continue;


      StorageUploadTask uploadTask = FirebaseStorage.instance.ref().child(
          categoryID).child(id).child(DateTime
          .now()
          .millisecondsSinceEpoch
          .toString()).putFile(unsavedData["images"][i]);


      StorageTaskSnapshot storage = await uploadTask.onComplete;
      String url = await storage.ref.getDownloadURL();

      unsavedData["images"][i] = url;
    }
  }

  @override
  void dispose() {
    _dataController.close();
    _loadingControlar.close();
    _createdControler.close();
  }
}
