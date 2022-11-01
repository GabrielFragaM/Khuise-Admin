
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lojas_khuise/constants/app_constants.dart';
import 'package:lojas_khuise/helpers/reponsiveness.dart';
import 'package:lojas_khuise/pages/orders/widgets/order_details.dart';
import 'package:lojas_khuise/services/auth_service.dart';
import 'package:lojas_khuise/widgets/custom_text.dart';
import 'package:lojas_khuise/widgets/screens_templates_messages/loading_orders.dart';
import 'package:lojas_khuise/widgets/screens_templates_messages/no_orders.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:provider/provider.dart';



class All_Orders extends StatefulWidget {

  @override
  All_Orders_State createState() =>All_Orders_State();
}

class All_Orders_State extends State<All_Orders> {

  String filterValue = 'TODOS';
  String searchValue = '';

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        leading: !ResponsiveWidget.isSmallScreen(context) ? Container(): IconButton(icon: Icon(Icons.menu, color: Colors.black,), onPressed: (){
          scaffoldKey.currentState.openDrawer();
        }),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 10,),
                Text('Lojas Khuise', style: TextStyle(fontSize: 17, color: Colors.pink),),
                Row(
                  children: [
                    Text('Pedidos / ', style: TextStyle(fontSize: 13,color: Colors.grey)),
                    SizedBox(width: 3),
                    DropdownButton<String>(
                      value: filterValue,
                      elevation: 5,
                      style: TextStyle(fontSize: 13, color: Colors.pink,),
                      underline: Container(
                        height: 2,
                        color: Colors.pink,
                      ),
                      onChanged: (String newValue) {
                        setState(() {
                          filterValue = newValue;
                        });
                      },
                      items: <String>['TODOS', 'AGUARDANDO APROVAÇÃO', 'APROVADO', 'REJEITADO', 'EM PREPARAÇÃO', 'EM TRANSPORTE', 'ENTREGUE']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    )
                  ],
                ),
              ],
            ),
            Row(
              children: [
                searchValue != '' ?
                IconButton(onPressed: (){
                  setState(() {
                    searchValue = '';
                  });
                }, icon: Icon(Icons.search_off), color: Colors.grey,):
                Container(),
                SizedBox(width: 3,),
                IconButton(onPressed: (){
                  AwesomeDialog(
                    width: 500,
                    context: context,
                    animType: AnimType.SCALE,
                    dialogType: DialogType.NO_HEADER,
                    body: Column(
                      children: [
                        Text('Buscar Pedido:', style: TextStyle(fontSize: 17, color: Colors.black),),
                        Padding(
                          padding: EdgeInsets.only(left: 5, right: 5, top: 10),
                          child: Material(
                            borderRadius: BorderRadius.circular(5),
                            elevation: 5.0,
                            shadowColor: Colors.black,
                            child: TextFormField(
                              onChanged: (valor) {
                                searchValue = valor;
                              },
                              autofocus: false,
                              style: TextStyle(
                                  fontSize: 15.0, color: Colors.black),
                              decoration: InputDecoration(
                                //Cha
                                filled: true,
                                fillColor: Colors.white,
                                labelText: 'NÚMERO DO PEDIDO',
                                labelStyle: TextStyle(
                                    color: Colors.grey
                                ),
                                hintText: 'NÚMERO DO PEDIDO...',
                                contentPadding: const EdgeInsets.only(
                                    left: 14.0, bottom: 8.0, top: 8.0),
                                focusedBorder: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                errorBorder: InputBorder.none,
                                disabledBorder: InputBorder.none,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    btnOkOnPress: () async {
                      setState(() {
                        searchValue = searchValue;
                      });

                      QuerySnapshot result_order = await FirebaseFirestore.instance.collection('orders')
                          .where('orderNumber', isEqualTo: searchValue).get();

                      if(result_order.docs.length == 0){
                        setState(() {
                          searchValue = '';
                        });
                        AwesomeDialog(
                          width: 500,
                          context: context,
                          animType: AnimType.SCALE,
                          dismissOnTouchOutside: false,
                          dismissOnBackKeyPress: false,
                          dialogType: DialogType.ERROR,
                          title: 'Ops...',
                          btnOkOnPress: () async {
                          },
                          desc: 'Número do pedido incorreto ou não existe.',
                          btnOkText: 'Entendi',
                        )..show();
                      }else{
                      }

                    },
                    btnOkText: 'Procurar...',
                  )..show();
                }, icon: Icon(Icons.search), color: Colors.grey,)
              ],
            )
          ],
        ),
        automaticallyImplyLeading: false,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: searchValue == '' ? filterValue == 'TODOS' ? FirebaseFirestore.instance
            .collection('orders').orderBy('date', descending: false)
            .snapshots() :
        FirebaseFirestore.instance.collection('orders')
        .where('status_text', isEqualTo: filterValue)
        .snapshots():
        FirebaseFirestore.instance.collection('orders')
            .where('orderNumber', isEqualTo: searchValue)
            .snapshots(),
    builder: (context, all_orders_querysnapshot) {
          print(filterValue);
          if (!all_orders_querysnapshot.hasData)
            return Loading_Orders();
          else if(all_orders_querysnapshot.data == null)
            return No_Order_Found();
          else if(all_orders_querysnapshot.data.docs.length == 0)
            return No_Order_Found();
          else
            return DataTable2(
                showCheckboxColumn: false,
                columnSpacing: 20.0,
                columns: [
                  DataColumn(
                    label: Text('Pedido'),
                  ),
                  DataColumn(
                    label: Text('Status'),
                  ),
                  DataColumn(
                    label: Text('Data da Compra'),
                  ),
                  DataColumn(
                    label: Text('Total'),
                  ),
                  DataColumn(
                    label: Text(''),
                  ),
                ],
                rows: List<DataRow>.generate(
                    all_orders_querysnapshot.data.docs.length,
                        (index) => DataRow(
                        onSelectChanged: (bool selected) {
                          if (selected) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => Order_Details(order: all_orders_querysnapshot.data.docs[index])),
                            );
                          }
                        },
                        cells: [
                          DataCell(CustomText(
                            text: "${all_orders_querysnapshot.data.docs[index]['orderNumber']}",
                            color: Colors.black,
                            size: 10,
                          )),
                          DataCell( CustomText(
                            text: "${all_orders_querysnapshot.data.docs[index]['status_text']}",
                            size: 11,
                          )),
                          DataCell(CustomText(
                            text: "${dateFormat.format(DateTime.parse(all_orders_querysnapshot.data.docs[index]['date'].toDate().toString()))}",
                            size: 11,
                          )),
                          DataCell(CustomText(
                            text: "R\$ ${all_orders_querysnapshot.data.docs[index]['total'].toStringAsFixed(2)}",
                            size: 11,
                          )),
                          DataCell(all_orders_querysnapshot.data.docs[index]['status'] == 0 ?
                          Icon(Icons.warning_amber_outlined, color: Colors.yellow, size: 18) :
                          all_orders_querysnapshot.data.docs[index]['status'] == 1 ?
                          Icon(Icons.check_circle, color: Colors.green, size: 18) :
                          all_orders_querysnapshot.data.docs[index]['status'] == 2 ?
                          Icon(Icons.move_to_inbox, color: Colors.blue, size: 18) :
                          all_orders_querysnapshot.data.docs[index]['status'] == 3 ?
                          Icon(Icons.directions_car_rounded, color: Colors.blue, size: 18) :
                          all_orders_querysnapshot.data.docs[index]['status'] == 4 ?
                          Icon(Icons.done, color: Colors.green, size: 18) :
                          Icon(Icons.warning_amber_outlined, color: Colors.red, size: 18)),
                        ])
                )
            );
        },
      ),
    );
  }

}