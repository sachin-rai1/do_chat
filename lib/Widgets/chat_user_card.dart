import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../helper/Constants.dart';

class ChatUserCard extends StatefulWidget {
  const ChatUserCard({Key? key}) : super(key: key);

  @override
  State<ChatUserCard> createState() => _ChatUserCardState();
}

class _ChatUserCardState extends State<ChatUserCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: .5,
      color: Colors.lightBlue[100],
      margin: EdgeInsets.symmetric(horizontal: w * 0.04, vertical: 4),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: const InkWell(

        child: ListTile(
          leading: CircleAvatar(
            child: Icon(CupertinoIcons.person),
          ),
          title: Text("Demo User"),
          subtitle: Text("Las User Message " , maxLines: 1,),
          trailing: Text("12:00 PM" , style: TextStyle(color: Colors.black),),

        ),
      ),
    );
  }
}
