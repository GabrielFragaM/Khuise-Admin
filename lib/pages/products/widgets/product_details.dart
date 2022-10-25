

import 'dart:convert';
import 'dart:typed_data';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:badges/badges.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:lojas_khuise/helpers/validator_text.dart';
import 'package:lojas_khuise/widgets/custom_text.dart';
import 'package:lojas_khuise/widgets/screens_templates_messages/product_error.dart';
import 'package:responsive_grid/responsive_grid.dart';


class Product_Details extends StatefulWidget {

  final Map <String, dynamic> product;

  Product_Details({this.product});

  @override
  Product_Details_State createState() => Product_Details_State(product: product);
}

class Product_Details_State extends State<Product_Details> with Validator_Text {

  final Product_Details _productScreen;

  Product_Details_State({Map <String, dynamic> product, int index})
      : _productScreen = Product_Details(product: product);

  bool is_loading = false;

  String value_size = '';


  @override
  Widget build(BuildContext context) {

    try{
      return Scaffold(
          appBar: AppBar(
            title: Text('${_productScreen.product['name'] == '' ? 'NOVO PRODUTO' : _productScreen.product['name'] }'),
            centerTitle: true,
            elevation: 0.5,
            actions: [
              _productScreen.product['new_product'] != true ? IconButton(iconSize: 29,icon: Icon(Icons.delete), color: Colors.white, onPressed: (){
                AwesomeDialog(
                  width: 500,
                  context: context,
                  animType: AnimType.SCALE,
                  dismissOnTouchOutside: false,
                  dismissOnBackKeyPress: false,
                  dialogType: DialogType.ERROR,
                  title: 'CONFIRMAR',
                  btnCancelOnPress: () async {
                    await FirebaseFirestore.instance.collection('products').doc(_productScreen.product['uid']).delete();
                    Navigator.pop(context);
                  },
                  desc: 'Deseja mesmo deletar esse produto ?',
                  btnCancelText: 'DELETAR',
                )..show();
              },):
                  Container()
            ],
            leading: IconButton(onPressed: (){
              Navigator.pop(context);
            },icon: Icon(Icons.arrow_back),),
          ),
          body: ListView(
            children: <Widget>[
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: List.generate(_productScreen.product['images'].length, (index) {
                    return Center(
                      child: Container(
                        width: 380,
                        height: 370,
                        padding: EdgeInsets.all(5),
                        child: Stack(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: NetworkImage(_productScreen.product['images'][index]),
                                      fit: BoxFit.cover),
                                  borderRadius: BorderRadius.circular(5)),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(5)),
                            ),
                            Positioned(
                              top: 5,
                              child: Padding(
                                padding: EdgeInsets.all(0),
                                child: IconButton(iconSize: 28,icon: Icon(Icons.delete), color: Colors.red, onPressed: (){
                                  setState(() {
                                    _productScreen.product['images'].remove(_productScreen.product['images'][index]);
                                  });
                                },),
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  }),
                ),
              ),
              SizedBox(height: 5),
              InkWell(
                onTap: () async {
                  setState(() {
                    is_loading = true;
                  });
                  var image = await FilePicker.platform.pickFiles(allowCompression: false);
                  PlatformFile file = image.files.first;

                  try {
                    Reference _reference = FirebaseStorage.instance
                        .ref().child('products').child('images')
                        .child('${DateTime
                        .now()
                        .millisecondsSinceEpoch
                        .toString()}.png');
                    await _reference
                        .putData(file.bytes, SettableMetadata(
                        contentType: 'image/png'))
                        .whenComplete(() async {
                      await _reference.getDownloadURL().then((url) async {
                        setState(() {
                          _productScreen.product['images'].add(url);
                          is_loading = false;
                        });
                      });
                    });
                  } catch (e) {}
                },
                child: Container(
                    decoration: BoxDecoration(color: Colors.pink,
                        borderRadius: BorderRadius.circular(5)),
                    alignment: Alignment.center,
                    height: 50,
                    width: double.maxFinite,
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: is_loading == false ? CustomText(
                      text: "Adicionar Imagem",
                      color: Colors.white,
                    ): SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                ),
              ),
              SizedBox(height: 10),
              Padding(
                padding: EdgeInsets.only(left: 5, right: 5),
                child: Material(
                  elevation: 5.0,
                  shadowColor: Colors.black,
                  child: TextFormField(
                    initialValue: _productScreen.product['name'],
                    onChanged: (valor) {
                      _productScreen.product['name'] = valor;
                    },
                    autofocus: false,
                    validator: validateText,
                    style: TextStyle(
                        fontSize: 15.0, color: Colors.black),
                    decoration: InputDecoration(
                      //Cha
                      filled: true,
                      fillColor: Colors.white,
                      labelText: 'NOME',
                      labelStyle: TextStyle(
                          color: Colors.pink
                      ),
                      hintText: 'NOME...',
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
              SizedBox(height: 10),
              Padding(
                padding: EdgeInsets.only(left: 5, right: 5),
                child: Material(
                  elevation: 5.0,
                  shadowColor: Colors.black,
                  child: TextFormField(
                    initialValue: _productScreen.product['description'],
                    onChanged: (valor) {
                      _productScreen.product['description'] = valor;
                    },
                    autofocus: false,
                    validator: validateText,
                    style: TextStyle(
                        fontSize: 15.0, color: Colors.black),
                    decoration: InputDecoration(
                      //Cha
                      filled: true,
                      fillColor: Colors.white,
                      labelText: 'DESCRIÇÃO',
                      labelStyle: TextStyle(
                          color: Colors.pink
                      ),
                      hintText: 'DESCRIÇÃO...',
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
              SizedBox(height: 10),
              Padding(
                padding: EdgeInsets.only(left: 5, right: 5),
                child: Material(
                  elevation: 5.0,
                  shadowColor: Colors.black,
                  child: TextFormField(
                    initialValue: _productScreen.product['price'].toStringAsFixed(2),
                    onChanged: (valor) {
                      if(valor.contains(',')){
                        AwesomeDialog(
                          width: 500,
                          context: context,
                          animType: AnimType.SCALE,
                          dismissOnTouchOutside: false,
                          dismissOnBackKeyPress: false,
                          dialogType: DialogType.ERROR,
                          title: 'Ops...',
                          btnOkOnPress: () {
                          },
                          desc: 'Não é permitido digitar "," use "." para quebrar o valor.',
                          btnOkText: 'Entendi',
                        )..show();
                      }else{
                        try{
                          _productScreen.product['price'] = double.parse(valor);
                        }catch(e){
                          AwesomeDialog(
                            width: 500,
                            context: context,
                            animType: AnimType.SCALE,
                            dismissOnTouchOutside: false,
                            dismissOnBackKeyPress: false,
                            dialogType: DialogType.ERROR,
                            title: 'Ops...',
                            btnOkOnPress: () {
                            },
                            desc: 'Não é permitido digitar palavras ou caracteres que não sejam "." !',
                            btnOkText: 'Entendi',
                          )..show();
                        }
                      }
                    },
                    keyboardType: TextInputType.number,
                    autofocus: false,
                    validator: validateText,
                    style: TextStyle(
                        fontSize: 15.0, color: Colors.black),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      labelText: 'PREÇO',
                      labelStyle: TextStyle(
                          color: Colors.pink
                      ),
                      hintText: 'PREÇO...',
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
              SizedBox(height: 10),
              Padding(
                padding: EdgeInsets.only(left: 5, right: 5),
                child: Material(
                  elevation: 5.0,
                  shadowColor: Colors.black,
                  child: TextFormField(
                    initialValue: _productScreen.product['amount'].toString(),
                    onChanged: (valor) {
                      try{
                        _productScreen.product['amount'] = int.parse(valor);
                      }catch(e){
                        AwesomeDialog(
                          width: 500,
                          context: context,
                          animType: AnimType.SCALE,
                          dismissOnTouchOutside: false,
                          dismissOnBackKeyPress: false,
                          dialogType: DialogType.ERROR,
                          title: 'Ops...',
                          btnOkOnPress: () {
                          },
                          desc: 'Não é permitido digitar palavras ou quaisquer caracteres\n'
                              'que não sejam números.',
                          btnOkText: 'Entendi',
                        )..show();
                      }
                    },
                    keyboardType: TextInputType.number,
                    autofocus: false,
                    validator: validateText,
                    style: TextStyle(
                        fontSize: 15.0, color: Colors.black),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      labelText: 'ESTOQUE',
                      labelStyle: TextStyle(
                          color: Colors.pink
                      ),
                      hintText: 'ESTOQUE...',
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
              SizedBox(height: 15,),
              ResponsiveGridList(
                scroll: false,
                desiredItemWidth: 50,
                minSpacing: 5,
                children: List.generate(
                  _productScreen.product['sizes'].length,
                      (index) => Badge(
                        badgeColor: Color.fromRGBO(0, 0, 0, 0.0),
                        badgeContent: GestureDetector(
                          onTap: (){
                            setState(() {
                              _productScreen.product['sizes'].remove(_productScreen.product['sizes'][index]);
                            });
                          },
                          child: Container(
                          height: 20,
                          width: 20,
                          child: GestureDetector(child: Icon(Icons.clear, size: 16,),),
                        ),),
                        child: RawMaterialButton(
                          constraints: BoxConstraints.expand(width: 45, height: 50),
                          onPressed: () {
                          },
                          elevation: 2.0,
                          fillColor: Colors.white,
                          child: Text(_productScreen.product['sizes'][index], style: TextStyle(fontSize: 13),),
                          shape: CircleBorder(),
                        ),
                      ),
                ),
              ),
              SizedBox(height: 5),
              InkWell(
                onTap: () async {
                  AwesomeDialog(
                    width: 400,
                    context: context,
                    animType: AnimType.SCALE,
                    dismissOnTouchOutside: false,
                    dismissOnBackKeyPress: false,
                    dialogType: DialogType.NO_HEADER,
                    body: Material(
                      elevation: 10,
                      shadowColor: Colors.black,
                      borderRadius: BorderRadius.circular(10),
                      child: TextFormField(
                        onChanged: (valor) {
                          setState(() {
                            value_size = valor;
                          });
                        },
                        autofocus: false,
                        validator: validateText,
                        style: TextStyle(
                            fontSize: 15.0, color: Colors.black),
                        decoration: InputDecoration(
                          filled: true,
                          labelText: 'TAMANHO',
                          labelStyle: TextStyle(
                              color: Colors.pink
                          ),
                          hintText: 'TAMANHO...',
                          contentPadding: const EdgeInsets.only(
                              left: 14.0, bottom: 8.0, top: 8.0),
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                        ),
                      ),
                    ),
                    btnOkOnPress: () {
                      if(value_size == ''){
                        return;
                      }else{
                        setState(() {
                          _productScreen.product['sizes'].add(value_size.toUpperCase());
                        });
                      }
                    },
                    btnOkText: 'SALVAR',
                  )..show();
                },
                child: Container(
                    decoration: BoxDecoration(color: Colors.pink,
                        borderRadius: BorderRadius.circular(5)),
                    alignment: Alignment.center,
                    height: 50,
                    width: double.maxFinite,
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: CustomText(
                      text: "Adicionar Tamanho",
                      color: Colors.white,
                    ),
                ),
              ),
              SizedBox(height: 5,),
              InkWell(
                onTap: () async {

                  if(_productScreen.product['images'].length == 0
                      || _productScreen.product['sizes'].length == 0
                      || _productScreen.product['name'] == ''
                      || _productScreen.product['description'] == ''
                      || _productScreen.product['price'] == 0
                      || _productScreen.product['amount'] == 0
                  ){
                    return AwesomeDialog(
                      width: 500,
                      context: context,
                      animType: AnimType.SCALE,
                      dismissOnTouchOutside: false,
                      dismissOnBackKeyPress: false,
                      dialogType: DialogType.ERROR,
                      title: 'Ops...',
                      btnOkOnPress: () {
                      },
                      desc: 'Preencha todos os campos e imagens para o produto\n'
                          'antes de continuar.',
                      btnOkText: 'Entendi',
                    )..show();
                  }else{
                    Map<String, dynamic> errorMap = {
                      "logNewProduct": _productScreen.product
                    };
                    await FirebaseFirestore.instance.collection('log').add(errorMap);
                    try{
                      AwesomeDialog(
                        width: 500,
                        context: context,
                        animType: AnimType.SCALE,
                        dismissOnTouchOutside: false,
                        dismissOnBackKeyPress: false,
                        dialogType: DialogType.SUCCES,
                        title: 'SALVANDO...',
                        desc: 'Aguarde um momento...',
                      )..show();

                      if(_productScreen.product['new_product'] == true){
                        DocumentReference product = await FirebaseFirestore.instance.collection('products').add(_productScreen.product);

                        _productScreen.product['uid'] = product.id;

                        await FirebaseFirestore.instance.collection('products').doc(product.id).update(_productScreen.product);

                        Navigator.pop(context);
                      }else{
                        await FirebaseFirestore.instance.collection('products').doc(_productScreen.product['uid']).update(_productScreen.product);
                      }
                      Navigator.pop(context);

                      final save_completed = SnackBar(
                        content: Text('Produto Salvo.', style: TextStyle(color: Colors.white),),
                        backgroundColor: Colors.green,
                      );

                      ScaffoldMessenger.of(context).showSnackBar(save_completed);

                    }catch(e){
                      Map<String, dynamic> errorMap = {
                        "error": e.toString()
                      };
                      await FirebaseFirestore.instance.collection('logs').add(errorMap);
                    }
                  }
                },
                child: Container(
                  decoration: BoxDecoration(color: Colors.green,
                      borderRadius: BorderRadius.circular(5)),
                  alignment: Alignment.center,
                  height: 50,
                  width: double.maxFinite,
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: CustomText(
                    text: "SALVAR",
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(height: 15,),
            ],
          ),

      );
    }catch(e){
      return Products_Error();
    }
  }

}