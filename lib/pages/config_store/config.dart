

import 'dart:convert';
import 'dart:typed_data';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:badges/badges.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:lojas_khuise/constants/app_constants.dart';
import 'package:lojas_khuise/constants/style.dart';
import 'package:lojas_khuise/helpers/reponsiveness.dart';
import 'package:lojas_khuise/helpers/validator_text.dart';
import 'package:lojas_khuise/widgets/custom_text.dart';
import 'package:lojas_khuise/widgets/screens_templates_messages/product_error.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:responsive_grid/responsive_grid.dart';


class Config extends StatefulWidget {


  @override
  Config_State createState() => Config_State();
}

class Config_State extends State<Config> with Validator_Text {

  Map <String, dynamic> shipping_map = {};

  final _formKey = GlobalKey<FormState>();

  var format_number = new MaskTextInputFormatter(mask: '########', filter: { "#": RegExp(r'[0-9]') });

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: !ResponsiveWidget.isSmallScreen(context) ? Container(): IconButton(icon: Icon(Icons.menu, color: Colors.black,), onPressed: (){
          scaffoldKey.currentState.openDrawer();
        }),
        title: Column(
          children: [
            Align(
              alignment: Alignment.topLeft,
              child:  Text('Lojas Khuise', style: TextStyle(fontSize: 17, color: Colors.pink),),
            ),
            Align(
              alignment: Alignment.topLeft,
              child: Text('Configurações / Loja', style: TextStyle(fontSize: 13,color: Colors.grey)),
            )
          ],
        ),
        automaticallyImplyLeading: false,
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance.collection('config')
            .doc('shipping')
            .snapshots(),
        builder: (context, shipping_document) {
          if (!shipping_document.hasData)
            return Container();
          else
            return ListView(
              children: <Widget>[
                Padding(padding: EdgeInsets.all(5),
                  child: Container(
                      constraints: BoxConstraints(maxWidth: 600),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: active.withOpacity(.4), width: .5),
                        boxShadow: [
                          BoxShadow(
                              offset: Offset(0, 6),
                              color: lightGrey.withOpacity(.1),
                              blurRadius: 12
                          )
                        ],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: EdgeInsets.all(16),
                      margin: EdgeInsets.only(bottom: 10),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Align(
                                    alignment: Alignment.topLeft,
                                    child: Text("Frete", style: TextStyle(fontSize: 20, color: Colors.pink),),
                                  ),
                                  SizedBox(width: 5,),
                                  Tooltip(message: "Defina todas as informações do frete.",height: 40,textStyle: TextStyle(fontSize: 12, color: Colors.white), child: Icon(Icons.help_outline, color: Colors.grey,)),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(height: 2,),
                          Divider(
                              color: Colors.pink
                          ),
                          SizedBox(height: 3,),
                          Form(
                            key: _formKey,
                            child: Column(
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(),
                                  child: Material(
                                    elevation: 5.0,
                                    shadowColor: Colors.black,
                                    child: TextFormField(
                                      initialValue: shipping_document.data.data()['nVlAltura'].toString(),
                                      onChanged: (valor) {
                                        shipping_map['nVlAltura'] = int.parse(valor);
                                      },
                                      autofocus: false,
                                      validator: validateText,
                                      inputFormatters: [format_number],
                                      style: TextStyle(
                                          fontSize: 15.0, color: Colors.black),
                                      decoration: InputDecoration(
                                        //Cha
                                        filled: true,
                                        fillColor: Colors.white,
                                        labelText: 'Altura',
                                        labelStyle: TextStyle(
                                            color: Colors.pink
                                        ),
                                        hintText: 'Altura...',
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
                                SizedBox(height: 5,),
                                Padding(
                                  padding: EdgeInsets.only(),
                                  child: Material(
                                    elevation: 5.0,
                                    shadowColor: Colors.black,
                                    child: TextFormField(
                                      initialValue: shipping_document.data.data()['nVlComprimento'].toString(),
                                      onChanged: (valor) {
                                        shipping_map['nVlComprimento'] = int.parse(valor);
                                      },
                                      autofocus: false,
                                      keyboardType: TextInputType.number,
                                      validator: validateText,
                                      inputFormatters: [format_number],
                                      style: TextStyle(
                                          fontSize: 15.0, color: Colors.black),
                                      decoration: InputDecoration(
                                        //Cha
                                        filled: true,
                                        fillColor: Colors.white,
                                        labelText: 'Comprimento',
                                        labelStyle: TextStyle(
                                            color: Colors.pink
                                        ),
                                        hintText: 'Comprimento...',
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
                                SizedBox(height: 5,),
                                Padding(
                                  padding: EdgeInsets.only(),
                                  child: Material(
                                    elevation: 5.0,
                                    shadowColor: Colors.black,
                                    child: TextFormField(
                                      initialValue: shipping_document.data.data()['nVlDiametro'].toString(),
                                      onChanged: (valor) {
                                        shipping_map['nVlDiametro'] = int.parse(valor);
                                      },
                                      autofocus: false,
                                      keyboardType: TextInputType.number,
                                      validator: validateText,
                                      inputFormatters: [format_number],
                                      style: TextStyle(
                                          fontSize: 15.0, color: Colors.black),
                                      decoration: InputDecoration(
                                        //Cha
                                        filled: true,
                                        fillColor: Colors.white,
                                        labelText: 'Diametro',
                                        labelStyle: TextStyle(
                                            color: Colors.pink
                                        ),
                                        hintText: 'Diametro...',
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
                                SizedBox(height: 5,),
                                Padding(
                                  padding: EdgeInsets.only(),
                                  child: Material(
                                    elevation: 5.0,
                                    shadowColor: Colors.black,
                                    child: TextFormField(
                                      initialValue: shipping_document.data.data()['nVlLargura'].toString(),
                                      onChanged: (valor) {
                                        shipping_map['nVlLargura'] = int.parse(valor);
                                      },
                                      keyboardType: TextInputType.number,
                                      autofocus: false,
                                      validator: validateText,
                                      inputFormatters: [format_number],
                                      style: TextStyle(
                                          fontSize: 15.0, color: Colors.black),
                                      decoration: InputDecoration(
                                        //Cha
                                        filled: true,
                                        fillColor: Colors.white,
                                        labelText: 'Largura',
                                        labelStyle: TextStyle(
                                            color: Colors.pink
                                        ),
                                        hintText: 'Largura...',
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
                                SizedBox(height: 5,),
                                Padding(
                                  padding: EdgeInsets.only(),
                                  child: Material(
                                    elevation: 5.0,
                                    shadowColor: Colors.black,
                                    child: TextFormField(
                                      initialValue: shipping_document.data.data()['nVlPeso'].toString(),
                                      onChanged: (valor) {
                                        shipping_map['nVlPeso'] = int.parse(valor);
                                      },
                                      autofocus: false,
                                      keyboardType: TextInputType.number,
                                      validator: validateText,
                                      inputFormatters: [format_number],
                                      style: TextStyle(
                                          fontSize: 15.0, color: Colors.black),
                                      decoration: InputDecoration(
                                        //Cha
                                        filled: true,
                                        fillColor: Colors.white,
                                        labelText: 'Peso',
                                        labelStyle: TextStyle(
                                            color: Colors.pink
                                        ),
                                        hintText: 'Peso...',
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
                                SizedBox(height: 5,),
                                Padding(
                                  padding: EdgeInsets.only(),
                                  child: Material(
                                    elevation: 5.0,
                                    shadowColor: Colors.black,
                                    child: TextFormField(
                                      initialValue: shipping_document.data.data()['sCepOrigem'].toString(),
                                      onChanged: (valor) {
                                        shipping_map['sCepOrigem'] = valor;
                                      },
                                      autofocus: false,
                                      keyboardType: TextInputType.number,
                                      validator: validateText,
                                      inputFormatters: [format_number],
                                      style: TextStyle(
                                          fontSize: 15.0, color: Colors.black),
                                      decoration: InputDecoration(
                                        //Cha
                                        filled: true,
                                        fillColor: Colors.white,
                                        labelText: 'Cep da Loja',
                                        labelStyle: TextStyle(
                                            color: Colors.pink
                                        ),
                                        hintText: 'Cep da Loja...',
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
                          ),
                          SizedBox(height: 15,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(),
                              InkWell(
                                onTap: () async {

                                  if (_formKey.currentState.validate()) {
                                    try{
                                      await FirebaseFirestore.instance.collection('config')
                                          .doc('shipping').update(shipping_map);

                                      AwesomeDialog(
                                        width: 500,
                                        context: context,
                                        animType: AnimType.SCALE,
                                        dialogType: DialogType.SUCCES,
                                        title: 'Sucesso',
                                        btnOkOnPress: () async {
                                        },
                                        desc: 'Novas informações salvas com sucesso.',
                                        btnOkText: 'Fechar',
                                      )..show();

                                    }catch(e){
                                    }
                                  }else{
                                  }

                                },
                                child: Container(
                                    decoration: BoxDecoration(color: Colors.pink,
                                        borderRadius: BorderRadius.circular(20)),
                                    alignment: Alignment.center,
                                    width: 200,
                                    height: 50,
                                    padding: EdgeInsets.symmetric(vertical: 16),
                                    child: CustomText(
                                      text: "SALVAR",
                                      color: Colors.white,
                                    )
                                ),
                              ),
                            ],
                          ),
                        ],
                      )
                  ),
                )
              ],
            );
        },
      ),
    );
  }

}