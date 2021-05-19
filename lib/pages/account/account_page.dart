import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:main_flutter_app/main.dart';

class AccountPage extends StatelessWidget {
  final FirebaseAuth firebaseAuth;

  AccountPage({this.firebaseAuth});

  String strErrorMessage = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('アカウント'),
        actions: [],
      ),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: () {
              try {
                firebaseAuth.signOut();
                Navigator.of(context).pop(context);
              } on FirebaseAuthException catch (e) {
                strErrorMessage = e.message;
                log(
                  'Account page FirebaseAuth signOut error',
                  time: DateTime.now(),
                  error: e.message,
                );
              } catch (e) {
                strErrorMessage = e.toString();
                log(
                  'Account page FirebaseAuth signOut error',
                  time: DateTime.now(),
                  error: e.toString(),
                );
              }
              if (strErrorMessage.isNotEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('ログアウト失敗: $strErrorMessage')));
              }
            },
            child: Text('ログアウト', style: TextStyle(color: Colors.white)),
            style: ElevatedButton.styleFrom(
              primary: Colors.red,
            ),
          ),
        ],
      ),
    );
  }
}
