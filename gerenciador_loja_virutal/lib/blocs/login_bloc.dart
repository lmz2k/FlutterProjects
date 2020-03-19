import 'dart:async';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gerenciadorlojavirutal/validators/login_validators.dart';
import 'package:rxdart/rxdart.dart';

enum LoginState { IDLE, LOADING, SUCCESS, FAIL }

class LoginBloc extends BlocBase with LoginValidators {
  final _emailControler = BehaviorSubject<String>();
  final _senhaControler = BehaviorSubject<String>();
  final _stateControler = BehaviorSubject<LoginState>();

  Stream<String> get outEmail =>
      _emailControler.stream.transform(validateEmail);

  Stream<String> get outSenha =>
      _senhaControler.stream.transform(validateSenha);

  Stream<LoginState> get outState => _stateControler.stream;

  Stream<bool> get outSubmitValid =>
      Observable.combineLatest2(outEmail, outSenha, (a, b) => true);

  Function(String) get changeEmail => _emailControler.sink.add;

  Function(String) get changeSenha => _senhaControler.sink.add;

  StreamSubscription _streamSubscription;

  LoginBloc() {
    _streamSubscription = FirebaseAuth.instance.onAuthStateChanged.listen((user) async {
      if (user != null) {

        if(await verifyPrivilegies(user)){
          _stateControler.add(LoginState.SUCCESS);
        }else{
          FirebaseAuth.instance.signOut();
          _stateControler.add(LoginState.FAIL);

        }

      } else {
        _stateControler.add(LoginState.IDLE);
      }
    });
  }

  Future<bool> verifyPrivilegies(FirebaseUser user) async {
    return await Firestore.instance
        .collection("admins")
        .document(user.uid)
        .get()
        .then((doc) {
      if (doc.data != null) {
        return true;
      } else {
        return false;
      }
    }).catchError((e) {
      return false;
    });
  }

  void submit() {
    final email = _emailControler.value;
    final senha = _senhaControler.value;

    _stateControler.add(LoginState.LOADING);

    FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: senha)
        .catchError((e) {
      _stateControler.add(LoginState.FAIL);
    });
  }

  @override
  void dispose() {
    _emailControler.close();
    _senhaControler.close();
    _stateControler.close();
    _streamSubscription.cancel();
  }
}
