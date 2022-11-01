

import 'package:cloud_firestore/cloud_firestore.dart';

Future<bool>reduceStock(String orderId, String uidUser, bool confirmation) async {
  if(confirmation == false) {
    QuerySnapshot products = await FirebaseFirestore.instance.collection('users')
        .doc(uidUser).collection('orders')
        .doc(orderId).collection('products').get();
    for (var p in products.docs) {
      Map <String, dynamic> productStoreUpdate = {};
      DocumentSnapshot productStore = await FirebaseFirestore.instance
          .collection('products')
          .doc(p.data()['uid']).get();
      productStoreUpdate['amount'] = productStore.data()['amount'] - p.data()['quantity'];
      await FirebaseFirestore.instance.collection('products')
          .doc(p.data()['uid']).update(productStoreUpdate);
    }
    return true;
  }else{
    return false;
  }
}

Future<bool>addStock(String orderId, String uidUser, bool confirmation) async {
  if(confirmation == true) {
    QuerySnapshot products = await FirebaseFirestore.instance.collection('users')
        .doc(uidUser).collection('orders')
        .doc(orderId).collection('products').get();

    for (var p in products.docs) {
      Map <String, dynamic> productStoreUpdate = {};

      DocumentSnapshot productStore = await FirebaseFirestore.instance
          .collection('products')
          .doc(p.data()['uid']).get();
      productStoreUpdate['amount'] = productStore.data()['amount'] + p.data()['quantity'];
      await FirebaseFirestore.instance.collection('products')
          .doc(p.data()['uid']).update(productStoreUpdate);
    }
    return false;
  }else{
    return true;
  }
}