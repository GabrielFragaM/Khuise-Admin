
import 'dart:convert';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lojas_khuise/constants/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:lojas_khuise/helpers/reponsiveness.dart';
import 'package:lojas_khuise/pages/products/widgets/product_details.dart';
import 'package:lojas_khuise/widgets/custom_text.dart';
import 'package:lojas_khuise/widgets/screens_templates_messages/loading_products.dart';
import 'package:lojas_khuise/widgets/screens_templates_messages/products_not_found.dart';
import 'package:responsive_grid/responsive_grid.dart';

class All_Products extends StatefulWidget {


  @override
  All_Products_State createState() =>
      All_Products_State();

}

class All_Products_State extends State<All_Products> {

  final _controller = ScrollController();

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 20),
            child: IconButton(
              onPressed: (){
                _controller.jumpTo(_controller.position.minScrollExtent);

              },icon: Icon(Icons.arrow_upward_sharp, size: 27,),
            ),
          ),
        ],
      ),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: !ResponsiveWidget.isSmallScreen(context) ? Container(): IconButton(icon: Icon(Icons.menu, color: Colors.black,), onPressed: (){
          scaffoldKey.currentState.openDrawer();
        }),
        actions: [
          InkWell(
            onTap: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Product_Details(product: {'new_product': true, 'sizes': [], 'name': '', 'amount': 0, 'description': '', 'price': 0, 'images': []})),
              );
            },
            child: Row(
              children: [
                Icon(Icons.add_circle_outline, color: Colors.pink,),
                SizedBox(width: 3,),
                Text('NOVO PRODUTO', style: TextStyle(fontSize: 17, color: Colors.pink),),
                SizedBox(width: 5,)
              ],
            )
          )
        ],
        title: Column(
          children: [
            Align(
              alignment: Alignment.topLeft,
              child:  Text('Lojas Khuise', style: TextStyle(fontSize: 17, color: Colors.pink),),
            ),
            Align(
              alignment: Alignment.topLeft,
              child: Text('Todos / Produtos', style: TextStyle(fontSize: 13,color: Colors.grey)),
            )
          ],
        ),
        automaticallyImplyLeading: false,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('products')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return Loading_Products();
          else if(snapshot.data.docs.isNotEmpty)
            return ListView(
              controller: _controller,
              physics: BouncingScrollPhysics(),
              children: [
                ResponsiveGridList(
                    scroll: false,
                    desiredItemWidth: MediaQuery.of(context).size.width > 500 ? 240: 180,
                    minSpacing: 5,
                    children: snapshot.data.docs.map((item) {
                      return GestureDetector(
                        onTap: () async {

                          await Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => Product_Details(product: {'uid': item.id, 'sizes': item['sizes'], 'name': item['name'], 'amount': item['amount'], 'description': item['description'], 'price': item['price'], 'images': item['images']})),
                          );


                        },
                        child: Container(
                          width: 200,
                          child: Card(
                            elevation: 10,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            shadowColor: Colors.black,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Container(
                                  width: 60.0,
                                  height: MediaQuery.of(context).size.width > 900 ? 250.0: 190.0,
                                  child: Image.network(item['images'][0], fit: BoxFit.cover,),
                                ),
                                Center(
                                  child: Container(
                                    padding: EdgeInsets.all(8),
                                    height: 50,
                                    child: CustomText(
                                      text: "${item['name']}",
                                      color: Colors.black,
                                      size: 14,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 5,),
                                Align(
                                  alignment: Alignment.center,
                                  child: Container(
                                    padding: EdgeInsets.all(4),
                                    height: 39,
                                    child: RichText(
                                      overflow: TextOverflow.clip,
                                      strutStyle: StrutStyle(fontSize: 10),
                                      text: TextSpan(
                                          style: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 14,
                                          ),
                                          text: "${item['description']}"),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 5,),
                                item['amount'] == 0 ?
                                Center(
                                  child: CustomText(
                                    text: "ESTOQUE EM FALTA",
                                    color: Colors.red,
                                    size: 13,
                                  ),
                                ):
                                Center(
                                  child: CustomText(
                                    text: "${item['amount']} EM ESTOQUE",
                                    color: Colors.green,
                                    size: 13,
                                  ),
                                ),
                                SizedBox(height: 8,),
                                Center(
                                  child: CustomText(
                                    text: "A partir de R\$: ${item['price'].toStringAsFixed(2)}",
                                    color: Colors.black,
                                    size: 13,
                                  ),
                                ),
                                SizedBox(height: 10,),
                              ],
                            ),
                          ),
                        ),
                      );
                    }).toList()
                )
              ],
            );
          else
            return Products_Not_Found();
        },
      ),
    );
  }

}