
import 'package:flutter/material.dart';


class Products_Error extends StatefulWidget {

  @override
  Products_Error_State createState() =>
      Products_Error_State();
}

class Products_Error_State extends State<Products_Error> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ops...'),
        centerTitle: true,
        elevation: 0.5,
        leading: IconButton(onPressed: (){
          Navigator.pop(context);
        },icon: Icon(Icons.arrow_back),),
      ),
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment:
          CrossAxisAlignment.stretch,
          mainAxisAlignment:
          MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.warning_amber_outlined,
              size: 96.0,
              color: Colors.black,
            ),
            SizedBox(
              height: 16.0,
            ),
            Text(
              "Não foi possível visualizar o Produto.\n"
                  "Consulte o suporte para resolver.",
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