
import 'package:flutter/material.dart';

class Chat{
  final String id;
  final String title;
  final String sender;
  final String reciepient;
  final String dateCreation;
  final bool read;

  Chat(
      {this.id,
      this.title,
      this.sender,
      this.reciepient,
      this.dateCreation,
      this.read});

}

class ChatMessage{
  Chat chat;
  String messageContent;
  String messageType;
  ChatMessage({@required this.messageContent, @required this.messageType});
}

