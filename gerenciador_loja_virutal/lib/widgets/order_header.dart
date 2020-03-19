import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gerenciadorlojavirutal/blocs/user_bloc.dart';

class OrderHeader extends StatelessWidget {

  final DocumentSnapshot orderHeader;

  OrderHeader(this.orderHeader);




  @override
  Widget build(BuildContext context) {


    final _userBloc = BlocProvider.of<UserBloc>(context);
    final user = _userBloc.getUser(orderHeader.data["clientId"]);


    return Row(
      children: <Widget>[
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[Text("${user["name"]}"), Text("${user["address"]}")],
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[Text("Produtos: R\$ ${orderHeader.data["productsPrice"].toStringAsFixed(2)}", style: TextStyle(fontWeight: FontWeight.bold),),
            Text("Total: R\$ ${orderHeader.data["totalPrice"].toStringAsFixed(2)}",style: TextStyle(fontWeight: FontWeight.bold))],
        )
      ],
    );
  }
}
