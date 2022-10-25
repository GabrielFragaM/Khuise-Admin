
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lojas_khuise/constants/app_constants.dart';
import 'package:lojas_khuise/helpers/reponsiveness.dart';
import 'package:lojas_khuise/pages/orders/widgets/order_details.dart';
import 'package:lojas_khuise/services/auth_service.dart';
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

  var uid_order_format = new MaskTextInputFormatter(mask: '#&&&&&&&&&&', filter: { "&": RegExp(r'[0-9]') });

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
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
                )
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
                              inputFormatters: [uid_order_format],
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
        if (all_orders_querysnapshot.connectionState == ConnectionState.waiting) {
          return Loading_Orders();
        }
        else if(all_orders_querysnapshot.data == null)
            return No_Order_Found();
          else if(all_orders_querysnapshot.data.docs.length == 0)
            return No_Order_Found();
          else
            return ListView.builder(
              itemCount: all_orders_querysnapshot.data.docs.length,
              itemBuilder: (context, index) {
                return StreamBuilder<DocumentSnapshot>(
                    stream: FirebaseFirestore.instance.collection('users')
                        .doc(all_orders_querysnapshot.data.docs[index].data()['uid_user']).collection('orders')
                        .doc(all_orders_querysnapshot.data.docs[index].id).snapshots(),
                    builder: (context, order_user_document) {
                      if (!order_user_document.hasData)
                        return Container();
                      else
                        return Padding(
                            padding: EdgeInsets.only(top: 10),
                            child: Container(
                              alignment: Alignment.center,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Colors.white,
                              ),
                              child: ListTile(
                                  onTap: () async {

                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => Order_Details(order: order_user_document.data,)),
                                    );

                                  },
                                  trailing: order_user_document.data.data()['status'] == 0 ?
                                  Icon(Icons.warning_amber_outlined, color: Colors.yellow) :
                                  order_user_document.data.data()['status'] == 1 ?
                                  Icon(Icons.check_circle, color: Colors.green) :
                                  order_user_document.data.data()['status'] == 2 ?
                                  Icon(Icons.move_to_inbox, color: Colors.blue) :
                                  order_user_document.data.data()['status'] == 3 ?
                                  Icon(Icons.directions_car_rounded, color: Colors.blue) :
                                  order_user_document.data.data()['status'] == 4 ?
                                  Icon(Icons.done, color: Colors.green) :
                                  Icon(Icons.warning_amber_outlined, color: Colors.red),
                                  title: Text('PEDIDO: ${order_user_document.data.data()['orderNumber']}', style: TextStyle(fontSize: 12),),
                                  subtitle: Text(
                                      'STATUS: ${order_user_document.data.data()['status_text']}\n'
                                          'DATA DA COMPRA: ${dateFormat.format(DateTime.parse(order_user_document.data.data()['date'].toDate().toString()))}\n'
                                          'TOTAL: R\$ ${order_user_document.data.data()['total'].toStringAsFixed(2)}',
                                    style: TextStyle(fontSize: 11),
                                  )
                              ),
                            )
                        );
                    });
              },
            );

        },
      ),
    );
  }

}