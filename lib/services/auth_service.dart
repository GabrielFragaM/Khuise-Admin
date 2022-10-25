import 'dart:html';

import 'package:lojas_khuise/routing/routes.dart';
import 'package:lojas_khuise/pages/authentication/authentication.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AuthException implements Exception{
  String message = null;
  AuthException(this.message);
}

class AuthService extends ChangeNotifier {
  FirebaseAuth _auth = FirebaseAuth.instance;
  User usuario;
  bool isLoading = true;
  String equipeId;
  String idAdminEquipe;
  bool isAdmin;

  AuthService() {
    _authCheck();
  }

  _authCheck() {
    _auth.authStateChanges().listen((User user) {
      usuario = (user == null) ? null : user;
      isLoading = false;
      notifyListeners();
    });
  }

  _getUser() async {
    usuario = _auth.currentUser;

    notifyListeners();
  }

  login(String email, String senha) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: senha);
      usuario = _auth.currentUser;
      _getUser();

      DocumentSnapshot user = await FirebaseFirestore.instance.collection('users').doc(usuario.uid).get();

      if(user.data()['is_admin'] == true){
        Get.offAllNamed(rootRoute);

        final Storage _localStorage = window.localStorage;

        Future save() async {
          _localStorage['email'] = email;
          _localStorage['password'] = senha;
        }

        await save();

      }else{
        return throw AuthException('Usuário ou senha incorretos.');
      }


    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        throw AuthException('Usuário ou senha incorretos.');
      }
      else if (e.code == 'wrong-password') {
        throw AuthException('Usuário ou senha incorretos.');
      }
    }
  }

  logout() async {
    await _auth.signOut();

    final Storage _localStorage = window.localStorage;

    Future save() async {
      _localStorage['email'] = 'NaN';
      _localStorage['password'] = 'NaN';
    }



    save();

    _getUser();
  }
}