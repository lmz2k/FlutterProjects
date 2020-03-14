import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:scoped_model/scoped_model.dart';

class UserModel extends Model {
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseUser firebaseUser;
  Map<String, dynamic> userData = Map();

  bool isLoading = false;

  static UserModel of(BuildContext context) => ScopedModel.of<UserModel>(context);


  @override
  void addListener(VoidCallback listener) {
    super.addListener(listener);

    _loadCurrentUser();
  }

  void signUp(Map<String, dynamic> userData, String pass, VoidCallback onSucess,
      VoidCallback onFailed) {

    isLoading = true;
    notifyListeners();

    _auth.createUserWithEmailAndPassword(email: userData['email'], password: pass).then((user) async {
      firebaseUser = user;
      await _saveUserData(userData);
      onSucess();
      isLoading = false;
      notifyListeners();
    }).catchError((e) {
      onFailed();
      isLoading = false;
      notifyListeners();
    });
  }

  Future<Null> _saveUserData(Map<String, dynamic> userData) async {
    this.userData = userData;
    await Firestore.instance
        .collection('users')
        .document(firebaseUser.uid)
        .setData(userData);
  }


  void SignOut() async {
    await _auth.signOut();
    userData = Map();
    firebaseUser = null;
    notifyListeners();

  }


  void singIn(String email, String pass, VoidCallback onSucess, VoidCallback onFailed) async {

    isLoading = true;
    notifyListeners();

    print("1");

    _auth.signInWithEmailAndPassword(email: email, password: pass).then((user) async {

      firebaseUser = user;

      await _loadCurrentUser();
      print("2");
      onSucess();
      isLoading = false;
      notifyListeners();

      
    }).catchError((e){

      onFailed();
      isLoading = false;
      notifyListeners();


    });
  }





  void recoverPassword(String email) {


    _auth.sendPasswordResetEmail(email: email);

  }

  bool isLoggedIn() {
    return firebaseUser != null;
  }

  Future<Null> _loadCurrentUser() async{

    if(firebaseUser == null){
      firebaseUser = await _auth.currentUser();
    }

    if(firebaseUser != null){
      if(userData["name"] == null){
        DocumentSnapshot docUser = await Firestore.instance.collection("users").document(firebaseUser.uid).get();
        userData = docUser.data;
      }
    }

    notifyListeners();

  }

}
