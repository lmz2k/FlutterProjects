import 'package:flutter/material.dart';
import 'package:loja_virtual/models/user_model.dart';
import 'package:scoped_model/scoped_model.dart';





class signUpScreen extends StatefulWidget {
  @override
  _signUpScreenState createState() => _signUpScreenState();
}

class _signUpScreenState extends State<signUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passController = TextEditingController();
  final _adressController = TextEditingController();
  final _ScafoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _ScafoldKey,
        appBar: AppBar(
          title: Text("Criar Conta"),
          centerTitle: true,
        ),
        body: ScopedModelDescendant<UserModel>(
          builder: (context, child, model) {

            if (model.isLoading){
              return Center(child: CircularProgressIndicator(),);
            }

            return Form(
              key: _formKey,
              child: ListView(
                padding: EdgeInsets.all(16.0),
                children: <Widget>[
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(hintText: "Nome Completo"),
                    validator: (text) {
                      if (text.isEmpty) return "Nome Invalido!";
                    },
                  ),
                  SizedBox(
                    height: 16.0,
                  ),
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(hintText: "Email"),
                    keyboardType: TextInputType.emailAddress,
                    validator: (text) {
                      if (text.isEmpty || !text.contains("@"))
                        return "Email Invalido!";
                    },
                  ),
                  SizedBox(
                    height: 16.0,
                  ),
                  TextFormField(
                      controller: _passController,
                      validator: (text) {
                        if (text.isEmpty || text.length < 6)
                          return "Senha Invalido!";
                      },
                      decoration: InputDecoration(
                        hintText: "Senha",
                      ),
                      obscureText: true),
                  SizedBox(
                    height: 16.0,
                  ),
                  TextFormField(
                    controller: _adressController,
                    validator: (text) {
                      if (text.isEmpty) return "Endereço Invalido!";
                    },
                    decoration: InputDecoration(
                      hintText: "Endereço",
                    ),
                  ),
                  SizedBox(
                    height: 16.0,
                  ),
                  SizedBox(
                    height: 44,
                    child: RaisedButton(
                      onPressed: () {
                        if (_formKey.currentState.validate()) {

                          Map<String,dynamic> userData = {
                            "name":_nameController.text,
                            "email":_emailController.text,
                            "address": _adressController.text,
                          };

                          model.signUp(userData, _passController.text, _onSucess, _onFailed);

                        }
                      },
                      child: Text(
                        "Criar Conta",
                        style: TextStyle(fontSize: 18.0, color: Colors.white),
                      ),
                      color: Theme.of(context).primaryColor,
                    ),
                  )
                ],
              ),
            );
          },
        ));
  }


  void _onSucess(){

      _ScafoldKey.currentState.showSnackBar(
        SnackBar(
          content: Text("Usuario Criado com Sucesso!"),
          backgroundColor: Theme.of(context).primaryColor,
          duration: Duration(seconds: 2),
        )
      );


      Future.delayed(Duration(seconds: 2)).then((_){
        Navigator.of(context).pop();
      });

    



  }

  void _onFailed(){




    _ScafoldKey.currentState.showSnackBar(
        SnackBar(
          content: Text("Falha ao Criar Usuario"),
          backgroundColor: Colors.redAccent,
          duration: Duration(seconds: 2),
        )
    );






  }
}









