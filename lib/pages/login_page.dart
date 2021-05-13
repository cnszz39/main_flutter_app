import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginPage extends StatelessWidget {
  final FirebaseAuth firebaseAuth;

  LoginPage({this.firebaseAuth});

  final TextEditingController mailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Icon(Icons.person),
          TextField(controller: mailController),
          TextField(controller: passwordController),
          MaterialButton(
            child: Text('ログイン'),
            onPressed: () {
              try {
                loginWithMailPass(firebaseAuth,mailController.text, passwordController.text).then((value) {
                  print('login page user: ${value.user.uid}');
                });
              } on FirebaseAuthException catch(e) {
                print(e.message);
              } catch(e) {
                print(e.toString());
              }

              Navigator.pop(context);
            },
          ),
          MaterialButton(
              child: Text('login with google'),
              onPressed: () async {
                // Trigger the Google Authentication flow.
                final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();
                // Obtain the auth details from the request.
                final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
                // Create a new credential.

                await firebaseAuth.signInWithCredential(GoogleAuthProvider.credential(accessToken: googleAuth.accessToken,
                  idToken: googleAuth.idToken,));
                Navigator.pop(context);
              }),
        ],
      ),
    );
  }
}

Future<UserCredential> loginWithMailPass(
    FirebaseAuth firebaseAuth, String email, String password) async {
  try {
    UserCredential userCredential =
        await firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return userCredential;
  } on FirebaseAuthException catch (e) {
    print(e.message);
  } catch (e) {
    print(e.toString());
  }
}
