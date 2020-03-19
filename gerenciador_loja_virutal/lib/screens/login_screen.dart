import 'package:flutter/material.dart';
import 'package:gerenciadorlojavirutal/blocs/login_bloc.dart';
import 'package:gerenciadorlojavirutal/screens/home_screen.dart';
import 'package:gerenciadorlojavirutal/widgets/input_form.dart';



class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final _LoginBloc = LoginBloc();


  @override
  void initState() {
      super.initState();
      _LoginBloc.outState.listen((state){
        switch (state){

          case LoginState.SUCCESS:
            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=> HomeScreen()));

            break;
            case LoginState.FAIL:
              showDialog(context: context, builder: (context) => AlertDialog(title: Text("Erro"), content: Text("Você não tem os privelegios necessarios para acessar esta pagina"),));
              break;
              case LoginState.LOADING:
                case LoginState.IDLE:

        }




      });


  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[850],
      body: StreamBuilder<LoginState>(
        stream: _LoginBloc.outState,
        initialData: LoginState.LOADING,
        builder: (context, snapshot) {
          print(snapshot.data);
          switch (snapshot.data) {

            case LoginState.LOADING:
              return Center(child: CircularProgressIndicator(),);

            case LoginState.FAIL:
            case LoginState.SUCCESS:
            case LoginState.IDLE:
              return Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  Container(),
                  SingleChildScrollView(
                    child: Container(
                      margin: EdgeInsets.all(16),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Icon(
                            Icons.store_mall_directory,
                            color: Colors.pinkAccent,
                            size: 160,
                          ),

                          LoginForm(Icons.person_outline, "Usuario", false,
                              _LoginBloc.outEmail, _LoginBloc.changeEmail),
                          LoginForm(Icons.person_outline, "Senha", true,
                              _LoginBloc.outSenha, _LoginBloc.changeSenha),

                          SizedBox(height: 32,),

                          StreamBuilder<bool>(
                              stream: _LoginBloc.outSubmitValid,
                              builder: (context, snapshot) {
                                return SizedBox(
                                  height: 50,
                                  child: RaisedButton(
                                    disabledColor: Colors.pinkAccent.withAlpha(
                                        140),
                                    onPressed: snapshot.hasData ? _LoginBloc
                                        .submit : null,
                                    color: Colors.pinkAccent,
                                    child: Text("Entrar"),
                                    textColor: Colors.white,
                                  ),
                                );
                              }
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              );
          }
        }
      ),
    );
  }
}
