import 'package:flutter/material.dart';
import 'package:reseau_agroagri_app/models/chat.dart';
import 'package:reseau_agroagri_app/pages/message_details_page.dart';

class ChatWidget extends StatefulWidget {

  final Chat chat;
  ChatWidget({@required this.chat});

  @override
  _ChatWidgetState createState() => _ChatWidgetState();
}

class _ChatWidgetState extends State<ChatWidget> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context){
          return MessageDetailPage();
        }));
      },
      child: Container(
        padding: EdgeInsets.only(left: 16,right: 16,top: 10,bottom: 10),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Row(
                children: <Widget>[
                  CircleAvatar(),
                  SizedBox(width: 16,),
                  Expanded(
                    child: Container(
                      color: Colors.transparent,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(widget.chat.title, style: TextStyle(fontSize: 16),),
                          SizedBox(height: 6,),
                          Text(widget.chat.title,style: TextStyle(fontSize: 13,color: Colors.grey.shade600),),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Text(widget.chat.dateCreation,style: TextStyle(fontSize: 12,),),
          ],
        ),
      ),
    );
  }
}