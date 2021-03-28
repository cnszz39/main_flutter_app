import 'package:flutter/material.dart';

class NoteCreatePage extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(Icons.close), onPressed: () => Navigator.pop(context)),
        title: Text('新規ノート'),
      ),
      backgroundColor: Colors.blue,
      body: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding:
                  EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 24),
              child: TextFormField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintStyle: TextStyle(fontSize: 16, color: Colors.white),
                  labelStyle: TextStyle(fontSize: 16, color: Colors.white),
                  filled: true,
                  fillColor: Colors.lightBlueAccent,
                  labelText: 'タイトル',
                  hintText: 'タイトルを入力してください。',
                ),
              ),
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.only(left: 8, top: 32, right: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(32),
                    topLeft: Radius.circular(32),
                  ),
                ),
                child: Padding(
                  padding:
                  EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 24),
                  child: TextFormField(
                    minLines: 5,
                    maxLines: 20,
                    decoration: InputDecoration(
                      hintStyle: TextStyle(fontSize: 16, color: Colors.grey),
                      filled: true,
                      fillColor: Colors.white,
                      hintText: 'タイトルを入力してください。',
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
