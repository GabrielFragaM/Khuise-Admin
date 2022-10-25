
import 'package:flutter/material.dart';


class No_Order_Found extends StatefulWidget {

  @override
  No_Order_Found_State createState() =>
      No_Order_Found_State();
}

class No_Order_Found_State extends State<No_Order_Found> {


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
              Icons.info_outline,
              size: 96.0,
              color: Colors.black,
            ),
            SizedBox(
              height: 16.0,
            ),
            Text(
              "Nenhum pedido encontrado.",
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