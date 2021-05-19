import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginPage extends StatefulWidget {
  final FirebaseAuth firebaseAuth;

  LoginPage({this.firebaseAuth});

  bool isShowPassword = true;

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  final TextEditingController mailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ログイン'),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              controller: mailController,
              keyboardType: TextInputType.emailAddress,
              validator: (String value) {
                if (value == null || value.isEmpty) {
                  return 'メールアドレスを入力してください。';
                }
                return null;
              },
            ),
            TextFormField(
              controller: passwordController,
              keyboardType: TextInputType.visiblePassword,
              obscureText: widget.isShowPassword,
              decoration: InputDecoration(
                suffix: IconButton(
                  icon: Icon(
                    widget.isShowPassword
                        ? Icons.visibility
                        : Icons.visibility_off,
                  ),
                  onPressed: () {
                    setState(() {
                      widget.isShowPassword = !widget.isShowPassword;
                    });
                  },
                ),
              ),
              validator: (String value) {
                if (value == null || value.isEmpty) {
                  return 'パースワードを入力してください。';
                }
                return null;
              },
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    child: Text('ログイン'),
                    onPressed: () async {
                      FocusScope.of(context).unfocus();
                      if (_formKey.currentState.validate()) {
                        String strErrorMessage = '';
                        try {
                          await widget.firebaseAuth.signInWithEmailAndPassword(
                            email: mailController.text,
                            password: passwordController.text,
                          );
                          Navigator.pop(context);
                        } on FirebaseAuthException catch (e) {
                          strErrorMessage = e.message;
                          log(
                            'Login Page FirebaseAuth error',
                            time: DateTime.now(),
                            error: e.message,
                          );
                        } catch (e) {
                          strErrorMessage = e.toString();
                          log(
                            'Login Page error',
                            time: DateTime.now(),
                            error: e.toString(),
                          );
                        }

                        if (strErrorMessage.isNotEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(strErrorMessage)),
                          );
                        }
                      }
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    child: Text(
                      '戻る',
                      style: TextStyle(color: Colors.black),
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.white,
                    ),
                    onPressed: () {
                      FocusScope.of(context).unfocus();
                      Navigator.of(context).pop();
                    },
                  ),
                ),
              ],
            ),
            ElevatedButton(
                child: Text('login with google'),
                onPressed: () async {
                  // Trigger the Google Authentication flow.
                  final GoogleSignInAccount googleUser =
                      await GoogleSignIn().signIn();
                  // Obtain the auth details from the request.
                  final GoogleSignInAuthentication googleAuth =
                      await googleUser.authentication;
                  // Create a new credential.

                  await widget.firebaseAuth
                      .signInWithCredential(GoogleAuthProvider.credential(
                    accessToken: googleAuth.accessToken,
                    idToken: googleAuth.idToken,
                  ));
                  Navigator.pop(context);
                }),
          ],
        ),
      ),
    );
  }
}
