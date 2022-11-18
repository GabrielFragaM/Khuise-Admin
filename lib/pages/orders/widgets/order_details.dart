import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lojas_khuise/constants/app_constants.dart';
import 'package:lojas_khuise/services/orders_service.dart';
import 'package:lojas_khuise/widgets/custom_text.dart';


class Order_Details extends StatefulWidget {

  DocumentSnapshot order;


  Order_Details({this.order});

  @override
  Order_Details_State createState() => Order_Details_State(order: order);
}

class Order_Details_State extends State<Order_Details> {

  final Order_Details _infoScreen;

  Order_Details_State({DocumentSnapshot order})
      : _infoScreen = Order_Details(order: order);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance.collection('users')
            .doc(_infoScreen.order.data()['uid_user']).collection('orders')
            .doc(_infoScreen.order.id).snapshots(),
        builder: (context, order_document) {
          if (!order_document.hasData)
            return Container();
          else
            return Scaffold(
            appBar: AppBar(
              title: Column(
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child:  Text('Lojas Khuise', style: TextStyle(fontSize: 17, color: Colors.pink),),
                  ),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text('Pedido / Detalhes', style: TextStyle(fontSize: 13,color: Colors.grey)),
                  )
                ],
              ),
              backgroundColor: Colors.white,
              elevation: 1,
              leading: IconButton(onPressed: (){
                Navigator.pop(context);
              },icon: Icon(Icons.arrow_back),color: Colors.pink,),
            ),
            body: ListView(
              children: <Widget>[
                SizedBox(height: 20,),
                Padding(
                  padding: EdgeInsets.only(left: 20),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Text(
                            'Pedido:',
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500
                            ),
                            maxLines: 3,
                          ),
                          SizedBox(width: 5,),
                          Text(
                            '${order_document.data.data()['orderNumber']}',
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500
                            ),
                            maxLines: 3,
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          SizedBox(height: 25),
                          Text(
                            'Copiar código do pedido:',
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500
                            ),
                            maxLines: 3,
                          ),
                          SizedBox(width: 5,),
                          InkWell(
                              onTap: () async {
                                Clipboard.setData(ClipboardData(text: order_document.data.data()['orderNumber']));
                                const snackBar = SnackBar(
                                  backgroundColor: Colors.green,
                                  content: Text('Código do pedido copiado.'),
                                );

                                ScaffoldMessenger.of(context).showSnackBar(snackBar);
                              },
                              child: Icon(Icons.copy, size: 20)
                          )
                        ],
                      )
                    ],
                  )),
                StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance.collection('users')
                        .doc(_infoScreen.order.data()['uid_user']).collection('orders')
                        .doc(_infoScreen.order.id).collection('products').snapshots(),
                    builder: (context, products_querysnapshot) {
                      if (!products_querysnapshot.hasData)
                        return Container();
                      else
                        return DataTable2(
                          showCheckboxColumn: false,
                          columnSpacing: 20.0,
                          columns: [
                            DataColumn(
                              label: Text(''),
                            ),
                            DataColumn(
                              label: Text('Produtos',style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w500
                              ),),
                            ),
                            DataColumn(
                              label: Text('Quantidade',style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w500
                              ),),
                            ),
                            DataColumn(
                              label: Text('Tamanho',style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w500
                              ),),
                            ),
                            DataColumn(
                              label: Text('Preço',style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w500
                              ),),
                            ),
                          ],
                          rows: List<DataRow>.generate(
                              products_querysnapshot.data.docs.length,
                                  (index) => DataRow(
                                  onSelectChanged: (bool selected) {
                                    if (selected) {

                                    }
                                  },
                                  cells: [
                                    DataCell(Container(
                                        width: 50, //SET width
                                        child: Image.network(products_querysnapshot.data.docs[index].data()['images'][0]))),
                                    DataCell(Container(
                                      width: 80, //SET width
                                      child: Text(
                                        '${products_querysnapshot.data.docs[index].data()['name'].toString()}',
                                        style: TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.w500
                                        ),
                                        maxLines: 3,
                                      ),)),
                                    DataCell(Container(
                                      width: 50, //SET width
                                      child: Text(
                                        '${products_querysnapshot.data.docs[index].data()['quantity']}',
                                        style: TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.w500
                                        ),
                                        maxLines: 3,
                                      ),)),
                                    DataCell(Container(
                                      width: 50, //SET width
                                      child: Text(
                                        '${products_querysnapshot.data.docs[index].data()['size']}',
                                        style: TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.w500
                                        ),
                                        maxLines: 3,
                                      ),)),
                                    DataCell(Container(
                                      width: 50, //SET width
                                      child: Text(
                                        'R\$ ${products_querysnapshot.data.docs[index].data()['price'].toStringAsFixed(2)}',
                                        style: TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.w500
                                        ),
                                        maxLines: 3,
                                      ),)),
                                  ])));
                    }),
                DataTable2(
                    showCheckboxColumn: false,
                    columnSpacing: 20.0,
                    columns: [
                      DataColumn(
                        label: Text(''),
                      ),
                      DataColumn(
                        label: Text(''),
                      ),
                      DataColumn(
                        label: Text('',style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w500
                        ),),
                      ),
                      DataColumn(
                        label: Text('',style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w500
                        ),),
                      ),
                      DataColumn(
                        label: Text('',style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w500
                        ),),
                      ),
                    ],
                    rows: List<DataRow>.generate(
                        1,
                            (index) => DataRow(
                            onSelectChanged: (bool selected) {
                              if (selected) {

                              }
                            },
                            cells: [
                              DataCell(Container()),
                              DataCell(Container(
                                width: 50, //SET width
                                child: Text(
                                  '+ (Frete)',
                                  style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w500
                                  ),
                                  maxLines: 3,
                                ),)),
                              DataCell(Container(
                                width: 50, //SET width
                                child: Text(
                                  '+ R\$ ${order_document.data.data()['preco_entrega']}',
                                  style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w500
                                  ),
                                  maxLines: 3,
                                ),)),
                              DataCell(Container(
                                width: 50, //SET width
                                child: Text(
                                  'Total',
                                  style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w500
                                  ),
                                  maxLines: 3,
                                ),)),
                              DataCell(Container(
                                width: 50, //SET width
                                child: Text(
                                  'R\$ ${(order_document.data.data()['preco_entrega'] + order_document.data.data()['total']).toStringAsFixed(2)}',
                                  style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w500
                                  ),
                                  maxLines: 3,
                                ),)),
                            ]))),
                order_document.data.data()['status'] == 0 ?
                Padding(padding: EdgeInsets.only(left: 3),
                  child: Column(
                    children: [
                      ListTile(
                        title: Text('Status do Pedido:'),
                        trailing: Icon(Icons.warning_amber_outlined, color: Colors.yellow),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('AGUARDANDO APROVAÇÃO', style: TextStyle(fontSize: 13),),
                          ],
                        ),
                      ),
                    ],
                  ),
                ):
                order_document.data.data()['status'] == 1 ?
                Padding(padding: EdgeInsets.only(left: 3),
                  child: Column(
                    children: [
                      ListTile(
                        title: Text('Status do Pedido:'),
                        trailing: Icon(Icons.check_circle, color: Colors.green),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('APROVADO', style: TextStyle(fontSize: 13),),
                          ],
                        ),
                      ),
                    ],
                  ),
                ):
                order_document.data.data()['status'] == 2 ?
                Padding(padding: EdgeInsets.only(left: 3),
                  child: Column(
                    children: [
                      ListTile(
                        title: Text('Status do Pedido:'),

                        trailing: Icon(Icons.move_to_inbox, color: Colors.blue),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('EM PREPARAÇÃO', style: TextStyle(fontSize: 13),),
                          ],
                        ),
                      ),
                    ],
                  ),
                ):
                order_document.data.data()['status'] == 3 ?
                Padding(padding: EdgeInsets.only(left: 3),
                  child: Column(
                    children: [
                      ListTile(
                        title: Text('Status do Pedido:'),

                        trailing: Icon(Icons.directions_car_rounded, color: Colors.blue),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('EM TRANSPORTE', style: TextStyle(fontSize: 13),),
                          ],
                        ),
                      ),
                    ],
                  ),
                ):
                order_document.data.data()['status'] == 4 ?
                Padding(padding: EdgeInsets.only(left: 3),
                  child: Column(
                    children: [
                      ListTile(
                        title: Text('Status do Pedido:'),

                        trailing: Icon(Icons.done, color: Colors.green),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('ENTREGUE', style: TextStyle(fontSize: 13),),
                          ],
                        ),
                      ),
                    ],
                  ),
                ) :
                Padding(padding: EdgeInsets.only(left: 3),
                  child: Column(
                    children: [
                      ListTile(
                        title: Text('Status do Pedido:'),
                        trailing: Icon(Icons.warning_amber_outlined, color: Colors.red),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('REJEITADO', style: TextStyle(fontSize: 13),),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () async {
                        Map <String, dynamic> edit_order = {};

                        edit_order['status'] = 1;
                        edit_order['status_text'] = 'APROVADO';

                        edit_order['confirmation'] = await reduceStock(_infoScreen.order.id, _infoScreen.order.data()['uid_user'],
                            order_document.data.data().containsValue('confirmation') == false ? false : order_document.data.data()['confirmation']);

                        await FirebaseFirestore.instance.collection('orders')
                            .doc(_infoScreen.order.id).update(edit_order);

                        await FirebaseFirestore.instance.collection('users')
                            .doc(_infoScreen.order.data()['uid_user']).collection('orders')
                            .doc(_infoScreen.order.id).update(edit_order);

                        final saveCompleted = SnackBar(
                          content: Text('NOVO STATUS DO PEDIDO: APROVADO', style: TextStyle(color: Colors.white),),
                          backgroundColor: Colors.green,
                        );

                        ScaffoldMessenger.of(context).showSnackBar(saveCompleted);

                      },
                      child: Container(
                        decoration: BoxDecoration(color: Colors.green,
                            borderRadius: BorderRadius.circular(5)),
                        alignment: Alignment.center,
                        width: 130,
                        padding: EdgeInsets.symmetric(vertical: 16),
                        child: CustomText(
                          text: "APROVADO",
                          color: Colors.white,
                          size: 12,
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () async {
                        Map <String, dynamic> edit_order = {};

                        edit_order['status'] = 5;
                        edit_order['status_text'] = 'REJEITADO';

                        edit_order['confirmation'] = await addStock(_infoScreen.order.id, _infoScreen.order.data()['uid_user'], order_document.data.data()['confirmation']);

                        await FirebaseFirestore.instance.collection('orders')
                            .doc(_infoScreen.order.id).update(edit_order);

                        await FirebaseFirestore.instance.collection('users')
                            .doc(_infoScreen.order.data()['uid_user']).collection('orders')
                            .doc(_infoScreen.order.id).update(edit_order);

                        final saveCompleted = SnackBar(
                          content: Text('NOVO STATUS DO PEDIDO: REJEITADO', style: TextStyle(color: Colors.white),),
                          backgroundColor: Colors.red,
                        );

                        ScaffoldMessenger.of(context).showSnackBar(saveCompleted);

                      },
                      child: Container(
                        decoration: BoxDecoration(color: Colors.red,
                            borderRadius: BorderRadius.circular(5)),
                        alignment: Alignment.center,
                        width: 130,
                        padding: EdgeInsets.symmetric(vertical: 16),
                        child: CustomText(
                          text: "REJEITADO",
                          color: Colors.white,
                          size: 12,
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () async {
                        Map <String, dynamic> edit_order = {};

                        edit_order['status'] = 2;
                        edit_order['status_text'] = 'EM PREPARAÇÃO';

                        await FirebaseFirestore.instance.collection('orders')
                            .doc(_infoScreen.order.id).update(edit_order);

                        await FirebaseFirestore.instance.collection('users')
                            .doc(_infoScreen.order.data()['uid_user']).collection('orders')
                            .doc(_infoScreen.order.id).update(edit_order);

                        final saveCompleted = SnackBar(
                          content: Text('NOVO STATUS DO PEDIDO: EM PREPARAÇÃO', style: TextStyle(color: Colors.white),),
                          backgroundColor: Colors.blue,
                        );

                        ScaffoldMessenger.of(context).showSnackBar(saveCompleted);

                      },
                      child: Container(
                        decoration: BoxDecoration(color: Colors.blue,
                            borderRadius: BorderRadius.circular(5)),
                        alignment: Alignment.center,
                        width: 130,
                        padding: EdgeInsets.symmetric(vertical: 16),
                        child: CustomText(
                          text: "EM PREPARAÇÃO",
                          color: Colors.white,
                          size: 12,
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () async {
                        Map <String, dynamic> edit_order = {};

                        edit_order['status'] = 3;
                        edit_order['status_text'] = 'EM TRANSPORTE';

                        await FirebaseFirestore.instance.collection('orders')
                            .doc(_infoScreen.order.id).update(edit_order);

                        await FirebaseFirestore.instance.collection('users')
                            .doc(_infoScreen.order.data()['uid_user']).collection('orders')
                            .doc(_infoScreen.order.id).update(edit_order);

                        final saveCompleted = SnackBar(
                          content: Text('NOVO STATUS DO PEDIDO: EM TRANSPORTE', style: TextStyle(color: Colors.white),),
                          backgroundColor: Colors.blue,
                        );

                        ScaffoldMessenger.of(context).showSnackBar(saveCompleted);

                      },
                      child: Container(
                        decoration: BoxDecoration(color: Colors.blue,
                            borderRadius: BorderRadius.circular(5)),
                        alignment: Alignment.center,
                        width: 130,
                        padding: EdgeInsets.symmetric(vertical: 16),
                        child: CustomText(
                          text: "EM TRANSPORTE",
                          color: Colors.white,
                          size: 12,
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () async {
                        Map <String, dynamic> edit_order = {};

                        edit_order['status'] = 4;
                        edit_order['status_text'] = 'ENTREGUE';

                        await FirebaseFirestore.instance.collection('orders')
                            .doc(_infoScreen.order.id).update(edit_order);

                        await FirebaseFirestore.instance.collection('users')
                            .doc(_infoScreen.order.data()['uid_user']).collection('orders')
                            .doc(_infoScreen.order.id).update(edit_order);

                        final saveCompleted = SnackBar(
                          content: Text('NOVO STATUS DO PEDIDO: ENTREGUE', style: TextStyle(color: Colors.white),),
                          backgroundColor: Colors.green,
                        );

                        ScaffoldMessenger.of(context).showSnackBar(saveCompleted);
                      },
                      child: Container(
                        decoration: BoxDecoration(color: Colors.green,
                            borderRadius: BorderRadius.circular(5)),
                        alignment: Alignment.center,
                        width: 130,
                        padding: EdgeInsets.symmetric(vertical: 16),
                        child: CustomText(
                          text: "ENTREGUE",
                          color: Colors.white,
                          size: 12,
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(padding: EdgeInsets.only(left: 3),
                  child: Column(
                    children: [
                      ListTile(
                        title: Text('Data da Compra:'),
                        leading: Icon(Icons.date_range_sharp),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('${dateFormat.format(DateTime.parse(order_document.data.data()['date'].toDate().toString()))}', style: TextStyle(fontSize: 13),),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(padding: EdgeInsets.only(left: 3),
                  child: Column(
                    children: [
                      ListTile(
                        title: Text('Entrega por ${order_document.data.data()['deliveryBy']}:'),
                        leading: Icon(Icons.local_shipping_outlined),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Preço: R\$ ${order_document.data.data()['preco_entrega']}', style: TextStyle(fontSize: 13),),
                            Text('Tempo Estimado: ${order_document.data.data()['tempo_entrega'] == 1 ? '1 a 2 dias' : '${order_document.data.data()['tempo_entrega']} dias'}', style: TextStyle(fontSize: 13),),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                order_document.data.data()['payment_method'] == 0 ?
                Padding(padding: EdgeInsets.only(left: 3),
                  child: Column(
                    children: [
                      ListTile(
                        title: Text('Tipo de Pagamento:'),
                        leading: Icon(Icons.monetization_on_outlined),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Boleto', style: TextStyle(fontSize: 13),),
                          ],
                        ),
                      ),
                    ],
                  ),
                ):
                order_document.data.data()['payment_method'] == 1 ?
                Padding(padding: EdgeInsets.only(left: 3),
                  child: Column(
                    children: [
                      ListTile(
                        title: Text('Tipo de Pagamento:'),
                        leading: Icon(Icons.credit_card_sharp),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text('Cartão de crédio.', style: TextStyle(fontSize: 13),),
                                SizedBox(width: 3,),
                                Text('Taxa de 10%', style: TextStyle(fontSize: 13, color: Colors.pink), ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ) :
                Padding(padding: EdgeInsets.only(left: 3),
                  child: Column(
                    children: [
                      ListTile(
                        title: Text('Tipo de Pagamento:'),
                        leading: Icon(Icons.account_balance_outlined),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Pix', style: TextStyle(fontSize: 13),),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                StreamBuilder<DocumentSnapshot>(
                    stream: FirebaseFirestore.instance.collection('users')
                        .doc(_infoScreen.order.data()['uid_user']).snapshots(),
                    builder: (context, contato) {
                      if (!contato.hasData)
                        return Container();
                      else
                        return Padding(padding: EdgeInsets.only(left: 3),
                        child: Column(
                          children: [
                            ListTile(
                              title: Text('Contato:'),
                              leading: Icon(Icons.contact_mail_outlined),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SelectableText('Telefone: ${contato.data.data()['phone']}', style: TextStyle(fontSize: 13),),
                                  SelectableText('Email: ${contato.data.data()['email']}', style: TextStyle(fontSize: 13),),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                StreamBuilder<DocumentSnapshot>(
                    stream: FirebaseFirestore.instance.collection('users')
                        .doc(_infoScreen.order.data()['uid_user']).collection('address')
                        .doc('address').snapshots(),
                    builder: (context, address) {
                      if (!address.hasData)
                        return Container();
                      else
                        return Padding(padding: EdgeInsets.only(left: 3),
                        child: Column(
                          children: [
                            ListTile(
                              title: Text('Endereço:'),
                              leading: Icon(Icons.location_city),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SelectableText('Cep: ${address.data.data()['cep']}', style: TextStyle(fontSize: 13),),
                                  SelectableText('Endereço: ${address.data.data()['endereco']}', style: TextStyle(fontSize: 13),),
                                  SelectableText('Número: ${address.data.data()['numero']}', style: TextStyle(fontSize: 13),),
                                  SelectableText('Complemento: ${address.data.data()['complemento']}', style: TextStyle(fontSize: 13),),
                                  SelectableText('Bairro: ${address.data.data()['bairro']}', style: TextStyle(fontSize: 13),),
                                  SelectableText('Cidade: ${address.data.data()['cidade']}', style: TextStyle(fontSize: 13),),
                                  SelectableText('Estado: ${address.data.data()['estado']}', style: TextStyle(fontSize: 13),),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                Padding(padding: EdgeInsets.only(left: 3, bottom: 10),
                  child: Column(
                    children: [
                      ListTile(
                        title: Text('Observações:'),
                        leading: Icon(Icons.comment_sharp),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('${order_document.data.data()['observation'] == 'NaN' ? 'Nenhuma' : order_document.data.data()['observation']}', style: TextStyle(fontSize: 13),),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(padding: EdgeInsets.only(left: 3, bottom: 10, top: 100),
                  child: InkWell(
                    onTap: () async {

                      AwesomeDialog(
                        width: 500,
                        context: context,
                        animType: AnimType.SCALE,
                        dismissOnTouchOutside: false,
                        dismissOnBackKeyPress: false,
                        dialogType: DialogType.ERROR,
                        title: 'Deletar Pedido',
                        btnCancelOnPress: () async {
                          Navigator.pop(context);
                          await FirebaseFirestore.instance.collection('orders')
                              .doc(_infoScreen.order.id).delete();

                          await FirebaseFirestore.instance.collection('users')
                              .doc(_infoScreen.order.data()['uid_user']).collection('orders')
                              .doc(_infoScreen.order.id).delete();

                          final saveCompleted = SnackBar(
                            content: Text('Pedido deletado', style: TextStyle(color: Colors.white),),
                            backgroundColor: Colors.red,
                          );

                          ScaffoldMessenger.of(context).showSnackBar(saveCompleted);
                        },
                        btnOkOnPress: () {},
                        desc: 'Você em certeza que deseja deletar esse pedido ?',
                        btnOkText: 'Não',
                        btnCancelText: 'Sim'
                      )..show();
                    },
                    child: Container(
                      decoration: BoxDecoration(color: Colors.red,
                          borderRadius: BorderRadius.circular(5)),
                      alignment: Alignment.center,
                      width: 130,
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: CustomText(
                        text: "Deletar Pedido",
                        color: Colors.white,
                        size: 12,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }

}