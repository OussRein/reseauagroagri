import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:reseau_agroagri_app/models/chat.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:uuid/uuid.dart';

class ContacterAnnonceurBox extends StatefulWidget {
  final String reciever;
  ContacterAnnonceurBox(this.reciever);
  @override
  _ContacterAnnonceurBoxState createState() => _ContacterAnnonceurBoxState();
}

class _ContacterAnnonceurBoxState extends State<ContacterAnnonceurBox> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      child: InkWell(
        onTap: () => showAlertDialog(context),
        child: Ink(
          color: Theme.of(context).primaryColorDark,
          child: Padding(
            padding: EdgeInsets.only(top: 2.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Icon(
                    Icons.contacts_sharp,
                  ),
                ),
                Text(
                  "Contacter l'annonceur",
                  style: GoogleFonts.lato(
                    textStyle: Theme.of(context).textTheme.headline4,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<bool> showAlertDialog(BuildContext context) {
    return Alert(
        context: context,
        title: "Contacter l'annonceur",
        content: Column(
          children: <Widget>[
            TextField(
              maxLines: 6,
              decoration: InputDecoration(
                icon: Icon(Icons.info),
                labelText: 'Informations',
              ),
              onChanged: (value) => message = value.trim(),
            ),
          ],
        ),
        buttons: [
          DialogButton(
            onPressed: () {
              createChat(message);
              Navigator.of(context).pop();
            },
            child: Text(
              "Envoyer le message",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          )
        ]).show();
  }

  Future<void> createChat(String message) async {
    final reciever = widget.reciever;
    final sender = _firebaseAuth.currentUser.uid;
    Chat chat;
    bool found = false;
    await FirebaseFirestore.instance
        .collection('chats')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        if (!found) {
          final data = Chat.fromJson(doc.data());
          if ((data.reciepient == reciever && data.sender == sender) ||
              ((data.reciepient == sender && data.sender == reciever))) {
            chat = data;
            found = true;
          }
        }
      });
    });
    if (!found) {
      chat = new Chat(id: Uuid().v4(), sender: sender, reciepient: reciever);

      await FirebaseFirestore.instance
          .collection('chats')
          .doc(chat.id)
          .set(chat.toJson(chat));
    }

    ChatMessage chatMessage = new ChatMessage(
      chatId: chat.id,
      messageContent: message,
      creator: sender,
      dateCreation: Timestamp.now(),
      read: false,
    );

    await FirebaseFirestore.instance
        .collection('chat_messages')
        .add(chatMessage.toJson(chatMessage));
  }
}
