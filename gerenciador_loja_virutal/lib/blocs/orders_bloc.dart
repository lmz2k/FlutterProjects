import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';

enum SortCriteria { READY_FIRST, READY_LAST }

class OrdersBloc extends BlocBase {
  Firestore _firestore = Firestore.instance;
  final _ordersControler = BehaviorSubject<List>();
  List<DocumentSnapshot> _ordersList = [];
  SortCriteria _criteria;

  Stream<List> get outOrders => _ordersControler.stream;

  OrdersBloc() {
    _addOrdersListener();
  }

  void setOrderCriteria(SortCriteria sort) {
    _criteria = sort;
    _sort();
  }

  void _sort() {
    switch (_criteria) {
      case SortCriteria.READY_FIRST:
        _ordersList.sort((a, b) {
          int sa = a.data["status"];
          int sb = b.data["status"];

          if (sa < sb)
            return 1;
          else if (sa > sb) return -1;

          return 0;
        });

        break;
      case SortCriteria.READY_LAST:
        _ordersList.sort((a, b) {
          int sa = a.data["status"];
          int sb = b.data["status"];

          if (sa > sb)
            return 1;
          else if (sa < sb) return -1;

          return 0;
        });
        break;
    }
  }

  void _addOrdersListener() {
    _firestore.collection("orders").snapshots().listen((snaopshot) {
      snaopshot.documentChanges.forEach((change) {
        String oid = change.document.documentID;

        switch (change.type) {
          case DocumentChangeType.added:
            _ordersList.add(change.document);
            break;
          case DocumentChangeType.modified:
            _ordersList.removeWhere((order) => order.documentID == oid);
            _ordersList.add(change.document);
            break;

          case DocumentChangeType.removed:
            _ordersList.removeWhere((order) => order.documentID == oid);
            break;
        }

        _sort();
      });

      _ordersControler.add(_ordersList);
    });
  }

  @override
  void dispose() {
    _ordersControler.close();
  }
}
