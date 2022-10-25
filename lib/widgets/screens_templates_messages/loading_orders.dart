
import 'package:flutter/material.dart';


class Loading_Orders extends StatefulWidget {

  @override
  Loading_Orders_State createState() =>
      Loading_Orders_State();
}

class Loading_Orders_State extends State<Loading_Orders> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment:
          CrossAxisAlignment.stretch,
          mainAxisAlignment:
          MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.category,
              size: 96.0,
              color: Colors.black,
            ),
            SizedBox(
              height: 16.0,
            ),
            Text(
              "Carregando os pedidos...",
              style: TextStyle(
                  fontSize: 22.0,
                  color: Colors.black,
                  fontWeight:
                  FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 16.0,
            ),
          ],
        ),
      ),
    );
  }

}