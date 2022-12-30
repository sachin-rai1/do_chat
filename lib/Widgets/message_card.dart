import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_application/Model/ChatModel.dart';
import 'package:chat_application/api/api.dart';
import 'package:chat_application/helper/mydate_util.dart';
import 'package:flutter/material.dart';

import '../helper/Constants.dart';

class MessageCard extends StatefulWidget {
  final ChatModel message;

  const MessageCard({Key? key, required this.message}) : super(key: key);

  @override
  State<MessageCard> createState() => _MessageCardState();
}

class _MessageCardState extends State<MessageCard> {
  @override
  Widget build(BuildContext context) {
    return APIs.user?.uid == widget.message.fromId
        ? _greenMessage()
        : _blueMessage();
  }

  Widget _blueMessage() {

    //update last mesaage read status

    if(widget.message.read!.isEmpty){
      APIs.updateMessageReadStatus(widget.message);
    }

    return Padding(
      padding: EdgeInsets.only(bottom: h * 0.004),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.symmetric(horizontal: w * 0.04),
            decoration: BoxDecoration(
                border: Border.all(color: Colors.blue),
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                    bottomRight: Radius.circular(30)),
                color: Colors.blue.shade100),
            padding: EdgeInsets.all(w * 0.03),
            child: widget.message.type == Type.text? Text(
              widget.message.msg!,
              style: const TextStyle(fontSize: 15),
            ):CachedNetworkImage(
              errorWidget:(context , url , error) => Icon(Icons.image),
                imageUrl: widget.message.msg!),
          ),

          Padding(
            padding: EdgeInsets.only(left: w * 0.04 , top: h * 0.005),
            child: Text(
              MyDateUtil.getFormattedTime(context: context, time: widget.message.sent!),
              style: const TextStyle(fontSize: 12, color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }

  Widget _greenMessage() {
    return Padding(
      padding: EdgeInsets.only(bottom: h * 0.004),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            margin: EdgeInsets.symmetric(horizontal: w * 0.04),
            decoration: BoxDecoration(
                border: Border.all(color: Colors.greenAccent),
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                    bottomLeft: Radius.circular(30)),
                color: Colors.green.shade100),
            padding: EdgeInsets.all(w * 0.03),
            child: widget.message.type == Type.text? Text(
              widget.message.msg!,
              style: const TextStyle(fontSize: 15),
            ):CachedNetworkImage(
              placeholder:(context , url) =>const CircularProgressIndicator(strokeWidth: 2),
                errorWidget:(context , url , error) => const Icon(Icons.image),
                imageUrl: widget.message.msg!),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: w * 0.04),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  MyDateUtil.getFormattedTime(context: context, time: widget.message.sent!),
                  style: const TextStyle(fontSize: 12, color: Colors.black87),
                ),
                (widget.message.read != "")?const Icon(
                  Icons.done_all_rounded,
                  color: Colors.blue,
                ):const Icon(Icons.done_outlined),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
