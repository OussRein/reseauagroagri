import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:reseau_agroagri_app/models/chat.dart';

class NewMessage extends StatefulWidget {
  final String chatId;
  NewMessage(this.chatId);
  @override
  _NewMessageState createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  var _enteredMessage = '';
final _controller = new TextEditingController();
  void _sendMessage() async {
    FocusScope.of(context).unfocus();
    final user = FirebaseAuth.instance.currentUser.uid;
    ChatMessage chatMessage = new ChatMessage(
      chatId: widget.chatId,
      messageContent: _enteredMessage,
      creator: user,
      dateCreation: Timestamp.now(),
      read: false,
    );
    
    await FirebaseFirestore.instance
        .collection('chat_messages')
        .add(chatMessage.toJson(chatMessage));
         _controller.clear();
    setState(() {
                  _enteredMessage = '';
                });
  }

  @override
  Widget build(BuildContext context) {
    return Align(
          alignment: Alignment.bottomLeft,
          child: Container(
            padding: EdgeInsets.only(left: 10, bottom: 10, top: 10),
            color: Colors.white,
            height: 60,
            child: Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    textCapitalization: TextCapitalization.sentences,
                    controller: _controller,
                    onChanged: (value) {
                      setState(() {
                        _enteredMessage = value;
                      });
                    },
                    decoration: InputDecoration(
                        hintText: "Ecrivez un message...",
                        hintStyle: TextStyle(color: Colors.black54),
                        border: InputBorder.none),
                  ),
                ),
                SizedBox(
                  width: 15,
                ),
                FloatingActionButton(
                  onPressed: _enteredMessage.trim().isEmpty ? null : _sendMessage,
                  child: Icon(
                    Icons.send,
                    color: Colors.white,
                    size: 15,
                  ),
                  backgroundColor: Colors.blue,
                  elevation: 0,
                ),
              ],
            ),
          ),
        );
  }
}
