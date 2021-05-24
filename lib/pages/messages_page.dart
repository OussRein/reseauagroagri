import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:reseau_agroagri_app/models/chat.dart';
import 'package:reseau_agroagri_app/widgets/chat.dart';

class MassagesPage extends StatefulWidget {
  static const String ROUTE = '/messages-page';
  @override
  _MassagesPageState createState() => _MassagesPageState();
}

class _MassagesPageState extends State<MassagesPage> {
  List<Chat> _chats = [
    Chat(title: "Jane Russel", dateCreation: "Now"),
    Chat(title: "Glady's Murphy", dateCreation: "Yesterday"),
    Chat(title: "Jorge Henry", dateCreation: "31 Mar"),
    Chat(title: "Philip Fox", dateCreation: "28 Mar"),
    Chat(title: "Debra Hawkins", dateCreation: "23 Mar"),
    Chat(title: "Jacob Pena", dateCreation: "17 Mar"),
    Chat(title: "Andrey Jones", dateCreation: "24 Feb"),
    Chat(title: "John Wick", dateCreation: "18 Feb"),
  ];

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
