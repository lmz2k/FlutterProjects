import 'package:flutter/material.dart';
import 'package:loja_virtual/models/user_model.dart';
import 'package:loja_virtual/screen/login_screen.dart';
import 'package:loja_virtual/tiles/drawer_tile.dart';
import 'package:scoped_model/scoped_model.dart';

class CustomDrawer extends StatelessWidget {


  final  PageController _pageController;
  const CustomDrawer( this._pageController);


  @override
  Widget build(BuildContext context) {
    Widget _fundoDegrade() => Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color.fromARGB(255, 2, 201, 254), Colors.white]),
          ),
        );

    return Drawer(
      child: Stack(
        children: <Widget>[
          _fundoDegrade(),
          ListView(
            padding: EdgeInsets.only(left: 32, top: 16),
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(bottom: 8.0),
                padding: EdgeInsets.fromLTRB(0.0, 16.0, 16.0, 8.0),
                height: 200,
                child: Stack(
                  children: <Widget>[
                    Positioned(
                      top: 16.0,
                      left: 0.0,
                      child: Text(
                        "lmz2k\nGame Store",
                        style: TextStyle(
                            fontSize: 38, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Positioned(
                        left: 0.0,

                        bottom: 0.0,
                        child: ScopedModelDescendant<UserModel>(
                          builder: (context,child, model){
                            print(model.isLoggedIn());
                            print(model.userData);

                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(

                                  "Olá, ${!model.isLoggedIn() ? " ": model.userData["name"]}",
                                  style: TextStyle(
                                      fontSize: 18.0, fontWeight: FontWeight.bold),
                                ),
                                GestureDetector(
                                  onTap: (){

                                    if(!model.isLoggedIn()){
                                      Navigator.of(context).push(MaterialPageRoute(builder: (context)=> LoginScreen()));
                                    }else{

                                      model.SignOut();

                                    }


                                  },
                                  child: Text( !model.isLoggedIn() ?
                                    "Entre ou cadastre-se > " : "Sair",
                                    style: TextStyle(
                                        color: Theme.of(context).primaryColor,
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            );
                          },
                        ))
                  ],
                ),
              ),
              Divider(),
              DrawerTile(Icons.home, "Inicio",_pageController,0),
              DrawerTile(Icons.list, "Produtos",_pageController,1),
              DrawerTile(Icons.location_on, "Nossa loja",_pageController,2),
              DrawerTile(Icons.playlist_add_check, "Meus Pedidos",_pageController,3),

            ],
          )
        ],
      ),
    );
  }
}
