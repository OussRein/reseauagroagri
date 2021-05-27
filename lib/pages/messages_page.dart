import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:reseau_agroagri_app/models/chat.dart';
import 'package:reseau_agroagri_app/widgets/chat_widget.dart';

class MassagesPage extends StatefulWidget {
  static const String ROUTE = '/messages-page';
  @override
  _MassagesPageState createState() => _MassagesPageState();
}

class _MassagesPageState extends State<MassagesPage> {
  List<Chat> _chats = [];
  final uid = FirebaseAuth.instance.currentUser.uid;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        title: Text(
          "Conversations",
          style: GoogleFonts.lato(
            textStyle: TextStyle(color: Colors.black),
            fontSize: 28,
            fontWeight: FontWeight.bold,
            fontStyle: FontStyle.italic,
          ),
        ),
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('chats')
                  .where('sender', isEqualTo: uid)
                  .snapshots(),
              builder:
                  (context, AsyncSnapshot<QuerySnapshot> chatSnapshotSender) {
                return StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('chats')
                      .where('reciepient', isEqualTo: uid)
                      .snapshots(),
                  builder: (context,
                      AsyncSnapshot<QuerySnapshot> chatSnapshotReciever) {
                    if (chatSnapshotReciever.connectionState ==
                        ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    final chatDocs = chatSnapshotReciever.data.docs;
                    chatDocs.addAll(chatSnapshotSender.data.docs);
                    return ListView.builder(
                      itemCount: chatDocs.length,
                      shrinkWrap: true,
                      padding: EdgeInsets.only(top: 16),
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        Chat chat = Chat.fromJson(chatDocs[index].data());
                        return ChatWidget(chat: chat);
                      },
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
