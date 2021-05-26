import 'package:flutter/material.dart';

class Chat {
  final String id;
  final String sender;
  final String reciepient;

  Chat({
    this.id,
    this.sender,
    this.reciepient,
  });

  static Chat fromJson(Map<String, dynamic> json) {
    return Chat(
      id: json['id'] as String,
      sender: json['sender'] as String,
      reciepient: json['reciepient'] as String,
    );
  }

  Map<String, dynamic> toJson(Chat instance) => <String, dynamic>{
        'id': instance.id,
        'sender': instance.sender,
        'reciepient': instance.reciepient,
      };
}

class ChatMessage {
  String chatId;
  String messageContent;
  String creator;
  final String dateCreation;
  final bool read;

  ChatMessage({
    @required this.chatId,
    @required this.messageContent,
    @required this.creator,
    this.dateCreation,
    this.read,
  });

  static ChatMessage fromJson(Map<String, dynamic> json) {
  return ChatMessage(
    chatId: json['chatId'] as String,
    messageContent: json['messageContent'] as String,
    creator: json['creator'] as String,
    dateCreation: json['dateCreation'] as String,
    read: json['read'] as bool,
  );
}

Map<String, dynamic> toJson(ChatMessage instance) => <String, dynamic>{
      'chatId': instance.chatId,
      'messageContent': instance.messageContent,
      'creator': instance.creator,
      'dateCreation': instance.dateCreation,
      'read': instance.read,
    };
}
