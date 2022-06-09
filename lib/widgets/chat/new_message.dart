// @dart=2.9
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class NewMessage extends StatefulWidget {
  @override
  State<NewMessage> createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  final _formKey = GlobalKey<FormState>();
  String message = '';
  final _controller = new TextEditingController();

  void _sendMessage() async {
    FocusScope.of(context).unfocus();
    final user = await FirebaseAuth.instance.currentUser();
    final isVaild = _formKey.currentState.validate();
    final userData=await Firestore.instance.collection('users').document(user.uid).get();

    if (isVaild) {
      _formKey.currentState.save();
      Firestore.instance.collection('chat').add({
        'text': message,
        'createdAt': Timestamp.now(),
        'userId': user.uid,
        'username': userData['username'],
        'userImage':userData['image_url'],
      });
      _controller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 8),
      padding: EdgeInsets.all(8),
      child: Form(
        key: _formKey,
        child: Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: _controller,
                key: ValueKey('message'),
                decoration: InputDecoration(labelText: 'Send A Message ...'),
                validator: (value) {
                  if (value.trim().length == 0) {
                    return 'The message can\'t be empty';
                  }
                  return null;
                },
                onSaved: (value) {
                  message = value;
                },
              ),
            ),
            IconButton(
              onPressed: _sendMessage,
              icon: Icon(Icons.send),
              color: Theme.of(context).primaryColor,
            ),
          ],
        ),
      ),
    );
  }
}
