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
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return MessageDetailPage(reciepient, widget.chat.id);
        }));
      },
      child: FutureBuilder(
        future: FirebaseFirestore.instance
            .collection('users')
            .doc(widget.chat.reciepient)
            .get(),
        builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          return FutureBuilder(
            future: FirebaseFirestore.instance
                .collection('users')
                .doc(widget.chat.sender)
                .get(),
            builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot2) {
              if (snapshot2.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              print(snapshot2.data.data());
              var map2 = new Map<String, dynamic>.from(snapshot2.data.data());
              var map = new Map<String, dynamic>.from(snapshot.data.data());
              if (FirebaseAuth.instance.currentUser.uid ==
                  widget.chat.reciepient) {
                var x = map;
                map = map2;
                map2 = x;
              }
              reciepient = map['username'];
              sender = map2['username'];

              return Container(
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  border: Border.symmetric(
                    horizontal: BorderSide(
                      color: Colors.black38,
                      width: 1,
                    ),
                  ),
                ),
                padding:
                    EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 10),
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
                                    reciepient,
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
                                    sender,
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
              );
            },
          );
        },
      ),
    );
  }
}
