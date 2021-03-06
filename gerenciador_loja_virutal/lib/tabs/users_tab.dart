import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gerenciadorlojavirutal/blocs/user_bloc.dart';
import 'package:gerenciadorlojavirutal/widgets/user_tile.dart';



class UserTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    final _userBloc = BlocProvider.of<UserBloc>(context);


    return Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: TextField(
            onChanged: _userBloc.onChangedSearch,
            style: TextStyle(color: Colors.white),
            decoration: InputDecoration(
                hintText: "Pesquisar",
                hintStyle: TextStyle(color: Colors.white),
                icon: Icon(
                  Icons.search,
                  color: Colors.white,
                ),
                border: InputBorder.none),
          ),
        ),


        Expanded(
          child: StreamBuilder<List>(
            stream: _userBloc.outUsers,
            builder: (context, snapshot) {


              if (!snapshot.hasData){
                return Center(child: CircularProgressIndicator(),);
              }
              else if (snapshot.data.length == 0 ){
                return(Center(child: Text("Nenhum usuario encontrado!", style: TextStyle(color: Colors.pinkAccent),),));
              }else{


                return ListView.separated(
                    itemBuilder: (context, index) {
                      return UserTile(snapshot.data[index]);
                    },
                    separatorBuilder: (context, index) {
                      return Divider();
                    },
                    itemCount: snapshot.data.length);



              }



            }
          ),
        )
      ],
    );
  }
}
