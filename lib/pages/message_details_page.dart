import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/chat.dart';
import '../widgets/new_message.dart';

class MessageDetailPage extends StatefulWidget {
  final String chatId;
  final String reciever;
  MessageDetailPage(this.reciever, this.chatId);

  @override
  _MessageDetailPageState createState() => _MessageDetailPageState();
}

class _MessageDetailPageState extends State<MessageDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        flexibleSpace: SafeArea(
          child: Container(
            padding: EdgeInsets.only(right: 16),
            child: Row(
              children: <Widget>[
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(
                    Icons.arrow_back,
                    color: Colors.black,
                  ),
                ),
                SizedBox(
                  width: 12,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        widget.reciever,
                        style: GoogleFonts.lato(
                          textStyle: TextStyle(color: Colors.black),
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top - AppBar().preferredSize.height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('chat_messages')
                    .where('chatId', isEqualTo: widget.chatId)
                    .orderBy('dateCreation')
                    .snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> chatSnapshot) {
                  if (chatSnapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (!chatSnapshot.hasData) {
                    return Padding(
                      padding: const EdgeInsets.only(
                          left: 14, right: 14, top: 10, bottom: 30),
                      child: Center(
                        child: Text(
                          "Aucun message n'a été trouver!",
                          style: GoogleFonts.lato(
                            textStyle: TextStyle(color: Colors.black),
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    );
                  }

                  final chatDocs = chatSnapshot.data.docs;
                  return ListView.builder(
                    itemCount: chatDocs.length,
                    shrinkWrap: true,
                    padding: EdgeInsets.only(top: 10, bottom: 10),
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (ctx, index) {
                      ChatMessage chatmessage =
                          ChatMessage.fromJson(chatDocs[index].data());
                      return Container(
                        padding: EdgeInsets.only(left: 14, right: 14, bottom: 10),
                        child: chatmessage.creator ==
                                FirebaseAuth.instance.currentUser.uid
                            ? Align(
                                alignment: Alignment.topRight,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    
                                    Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(20)),
                                        color: Colors.blue[200],
                                      ),
                                      padding: EdgeInsets.all(10),
                                      child: Text(
                                        chatmessage.messageContent,
                                        style: GoogleFonts.lato(
                                          textStyle: TextStyle(color: Colors.black),
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      "${chatmessage.dateCreation.toDate().day}/${chatmessage.dateCreation.toDate().month}",
                                      style: GoogleFonts.lato(
                                        textStyle: TextStyle(color: Colors.black),
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : Align(
                                alignment: Alignment.topLeft,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                   
                                    Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.only(
                                            topRight: Radius.circular(20)),
                                        color: Colors.grey.shade200,
                                      ),
                                      padding: EdgeInsets.all(10),
                                      child: Text(
                                        chatmessage.messageContent,
                                        style: GoogleFonts.lato(
                                          textStyle: TextStyle(color: Colors.black),
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                     Text(
                                      "${chatmessage.dateCreation.toDate().day}/${chatmessage.dateCreation.toDate().month}",
                                      style: GoogleFonts.lato(
                                        textStyle: TextStyle(color: Colors.black),
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                      );
                    },
                  );
                },
              ),
              NewMessage(widget.chatId),
            ],
          ),
        ),
      ),
    );
  }
}
