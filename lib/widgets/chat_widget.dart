import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:reseau_agroagri_app/models/chat.dart';
import 'package:reseau_agroagri_app/pages/message_details_page.dart';

class ChatWidget extends StatefulWidget {
  final Chat chat;
  ChatWidget({@required this.chat});

  @override
  _ChatWidgetState createState() => _ChatWidgetState();
}

class _ChatWidgetState extends State<ChatWidget> {
  String sender = "";
  String reciepient = "";

  @override
  void initState() {
    
    Timer.run(() async {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.chat.sender)
          .get()
          .then((DocumentSnapshot documentSnapshot) {
        if (documentSnapshot.exists) {
          final map = new Map<String, dynamic>.from(documentSnapshot.data());
          sender = map['username'];
          print(sender);
        }
      }).onError((error, stackTrace) {
        print(error);
      });
      await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.chat.reciepient)
          .get()
          .then((DocumentSnapshot documentSnapshot) {
        if (documentSnapshot.exists) {
          final map = new Map<String, dynamic>.from(documentSnapshot.data());
          reciepient = map['username'];
          print(reciepient);
        }
      }).onError((error, stackTrace) {
        print(error);
      });
      if(FirebaseAuth.instance.currentUser.uid == widget.chat.reciepient){
        var x = reciepient;
        reciepient = sender;
        sender = x;
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return MessageDetailPage(reciepient, widget.chat.id);
        }));
      },
      child: Container(
        padding: EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: Row(
                children: <Widget>[
                  CircleAvatar(),
                  SizedBox(
                    width: 16,
                  ),
                  Expanded(
                    child: Container(
                      color: Colors.transparent,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            sender,
                            style: GoogleFonts.lato(
                                        textStyle:
                                            TextStyle(color: Colors.black87),
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        fontStyle: FontStyle.italic,
                                      ),
                          ),
                          SizedBox(
                            height: 6,
                          ),
                          Text(
                            reciepient,
                            style: GoogleFonts.lato(
                                        textStyle:
                                            TextStyle(color: Colors.black87),
                                        fontSize: 16,
                                        fontStyle: FontStyle.italic,
                                      ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Text(
              DateTime.now().toString(),
              style: TextStyle(
                fontSize: 8,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
