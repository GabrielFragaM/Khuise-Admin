import 'package:flutter/material.dart';
import 'package:lojas_khuise/pages/config_store/config.dart';
import 'package:lojas_khuise/pages/products/all_products.dart';
import 'package:lojas_khuise/pages/orders/all_orders.dart';
import 'package:lojas_khuise/routing/routes.dart';

Route<dynamic> generateRoute(RouteSettings settings){
  switch (settings.name) {
    case overviewPageRoute:
      return _getPageRoute(All_Products());
    case driversPageRoute:
      return _getPageRoute(All_Orders());
    case configPageRoute:
      return _getPageRoute(Config());
    default:
      return _getPageRoute(All_Products());

  }
}

PageRoute _getPageRoute(Widget child){
  return MaterialPageRoute(builder: (context) => child);
}