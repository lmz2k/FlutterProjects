import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:gerenciadorlojavirutal/blocs/orders_bloc.dart';
import 'package:gerenciadorlojavirutal/widgets/order_tile.dart';

class OrdersTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ordersBloc = BlocProvider.of<OrdersBloc>(context);

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16),
      child: StreamBuilder<List>(
          stream: ordersBloc.outOrders,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.data.length == 0) {
              return Center(
                child: Text("Nenhum pedido disponivel!"),
              );
            } else {
              return ListView.builder(
                itemBuilder: (context, index) {
                  return OrderTile(snapshot.data[index]);
                },
                itemCount: snapshot.data.length,
              );
            }
          }),
    );
  }
}
