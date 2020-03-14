import 'package:flutter/material.dart';
import 'package:loja_virtual/models/user_model.dart';
import 'package:loja_virtual/screen/signup_screen.dart';
import 'package:scoped_model/scoped_model.dart';


class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passController = TextEditingController();
  final _ScafoldKey = GlobalKey<ScaffoldState>();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _ScafoldKey,
        appBar: AppBar(
          title: Text("Entrar"),
          centerTitle: true,
          actions: <Widget>[
            FlatButton(
              child: Text(
                "CRIAR CONTA",
                style: TextStyle(
                  fontSize: 15.0,
                  color: Colors.white,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => signUpScreen()));
              },
            )
          ],
        ),
        body: ScopedModelDescendant<UserModel>(
            builder: (context, child, model){
              if(model.isLoading) return Center(child: CircularProgressIndicator(),);

              return Form(
                key: _formKey,
                child: ListView(
                  padding: EdgeInsets.all(16.0),
                  children: <Widget>[
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
                        validator: (text){
                          if (text.isEmpty || text.length < 6)
                            return "Senha Invalido!";
                        },
                        decoration: InputDecoration(
                          hintText: "Senha",
                        ),
                        obscureText: true),
                    Align(
                      alignment: Alignment.centerRight,
                      child: FlatButton(
                          onPressed: () {
                            if(_emailController.text.isEmpty){


                              _ScafoldKey.currentState.showSnackBar(
                                  SnackBar(
                                    content: Text("Ensira o email para recuperação!"),
                                    backgroundColor: Colors.redAccent,
                                    duration: Duration(seconds: 2),
                                  )
                              );


                            }else{
                                model.recoverPassword(_emailController.text);
                              _ScafoldKey.currentState.showSnackBar(
                                  SnackBar(
                                    content: Text("Verifique seu Email!"),
                                    backgroundColor: Theme.of(context).primaryColor,
                                    duration: Duration(seconds: 2),
                                  )

                              );

                            }

                          },
                          child: Text(
                            "Esqueci minha senha",
                            textAlign: TextAlign.right,
                          ),
                          padding: EdgeInsets.zero),
                    ),
                    SizedBox(
                      height: 16.0,
                    ),
                    SizedBox(
                      height: 44,
                      child: RaisedButton(
                        onPressed: () {
                          if (_formKey.currentState.validate()){

                            print(_emailController.text);
                                print(_passController.text);
                            model.singIn(_emailController.text, _passController.text, _onSucess, _onFailed);

                          }


                        },
                        child: Text(
                          "Entrar",
                          style: TextStyle(fontSize: 18.0, color: Colors.white),
                        ),
                        color: Theme.of(context).primaryColor,
                      ),
                    )
                  ],
                ),
              );
            }

        )
    );
  }


  void _onSucess(){

    Navigator.of(context).pop();

  }

  void _onFailed(){


    _ScafoldKey.currentState.showSnackBar(
        SnackBar(
          content: Text("Falha ao logar com usuario"),
          backgroundColor: Colors.redAccent,
          duration: Duration(seconds: 2),
        )
    );




  }
}



