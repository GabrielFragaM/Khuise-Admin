
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:lojas_khuise/constants/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:lojas_khuise/helpers/reponsiveness.dart';
import 'package:lojas_khuise/pages/products/widgets/product_details.dart';
import 'package:lojas_khuise/widgets/custom_text.dart';
import 'package:lojas_khuise/widgets/screens_templates_messages/loading_products.dart';
import 'package:lojas_khuise/widgets/screens_templates_messages/products_not_found.dart';

class All_Products extends StatefulWidget {

  @override
  All_Products_State createState() =>
      All_Products_State();

}

class All_Products_State extends State<All_Products> {

  String queryProduct = '';
  String queryBy = '';

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        leading: !ResponsiveWidget.isSmallScreen(context) ?Container(): IconButton(icon: Icon(Icons.menu, color: Colors.black,), onPressed: (){
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
          if (!snapshot.hasData)
            return Loading_Products();
          else if(snapshot.data.docs.isNotEmpty || snapshot.connectionState == ConnectionState.done)
            return DataTable2(
                showCheckboxColumn: false,
                columnSpacing: 20.0,
                columns: [
                  DataColumn(
                    label: Text('Imagem'),
                  ),
                  DataColumn(
                    label: Text('Produto'),
                  ),
                  DataColumn(
                    label: Text('Descrição'),
                  ),
                  DataColumn(
                    label: Text('Estoque'),
                  ),
                  DataColumn(
                    label: Text('Preço'),
                  ),
                ],
                rows: List<DataRow>.generate(
                    snapshot.data.docs.length,
                        (index) => DataRow(
                        onSelectChanged: (bool selected) {
                          if (selected) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => Product_Details(product: {'uid': snapshot.data.docs[index].id, 'sizes': snapshot.data.docs[index]['sizes'], 'name': snapshot.data.docs[index]['name'], 'amount': snapshot.data.docs[index]['amount'], 'description': snapshot.data.docs[index]['description'], 'price': snapshot.data.docs[index]['price'], 'images': snapshot.data.docs[index]['images']})),
                            );
                          }
                        },
                        cells: [
                          DataCell(Container(
                            width: 50,
                            height: 50,
                            child: Image.network(snapshot.data.docs[index]['images'][0], fit: BoxFit.cover,),
                          )),
                          DataCell(CustomText(
                            text: "${snapshot.data.docs[index]['name']}",
                            color: Colors.black,
                            size: 14,
                          )),
                          DataCell(Container(
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
                                  text: "${snapshot.data.docs[index]['description']}"),
                            ),
                          )),
                          DataCell(snapshot.data.docs[index]['amount'] == 0 ?
                          Center(
                            child: CustomText(
                              text: "ESTOQUE EM FALTA",
                              color: Colors.red,
                              size: 13,
                            ),
                          ):
                          Center(
                            child: CustomText(
                              text: "${snapshot.data.docs[index]['amount']} EM ESTOQUE",
                              color: Colors.green,
                              size: 13,
                            ),
                          )),
                          DataCell(CustomText(
                            text: "R\$ ${snapshot.data.docs[index]['price'].toStringAsFixed(2)}",
                            color: Colors.black,
                            size: 13,
                          ),),
                        ])
                )
            );
          else
            return Products_Not_Found();
        },
      ),
    );
  }

}