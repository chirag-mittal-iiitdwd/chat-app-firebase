// @dart=2.9

import 'package:chat_app/widgets/chat/message_bubble.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Messages extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: FirebaseAuth.instance.currentUser(),
      builder: (ctx, futureSnanshot) {
        if (futureSnanshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        return StreamBuilder(
          stream: Firestore.instance
              .collection('chat')
              .orderBy('createdAt', descending: true)
              .snapshots(),
          builder: (ctx, chatChapshot) {
            if (chatChapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            final chatDocs = chatChapshot.data.documents;
            return ListView.builder(
              reverse: true,
              itemBuilder: (ctx, index) => MessageBubble(
                chatDocs[index]['text'],
                chatDocs[index]['userId'] == futureSnanshot.data.uid,
                chatDocs[index]['username'],
                chatDocs[index]['userImage'],
                key: ValueKey(
                  chatDocs[index].hashCode,
                ),
              ),
              itemCount: chatDocs.length,
            );
          },
        );
      },
    );
  }
}
