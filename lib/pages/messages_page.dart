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
  @override
  void initState() {
    super.initState();
    final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
    final uid = _firebaseAuth.currentUser.uid;
    
    Timer.run(() async {

        await fetchChats();
    });
  }
  Future<void> fetchChats() async {
    final currentUserId = FirebaseAuth.instance.currentUser.uid;
    await FirebaseFirestore.instance
        .collection('chats')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        
          final data = Chat.fromJson(doc.data());
          print(data);
          if ((data.sender == currentUserId) ||
              ((data.reciepient == currentUserId))) {
            _chats.add(data);
          }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SafeArea(
              child: Padding(
                padding: EdgeInsets.only(left: 16, right: 16, top: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "Conversations",
                      style: GoogleFonts.lato(
                        textStyle: TextStyle(color: Colors.black),
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Divider(),
            ListView.builder(
              itemCount: _chats.length,
              shrinkWrap: true,
              padding: EdgeInsets.only(top: 16),
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return ChatWidget(chat: _chats[index]);
              },
            ),
          ],
        ),
      ),
    );
  }
}
