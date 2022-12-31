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
    bool isMe = APIs.user?.uid == widget.message.fromId;
    return InkWell(
      onLongPress: () {
        _showBottomSheet(isMe);
      },
      child: isMe ? _greenMessage() : _blueMessage(),
    );
  }

  Widget _blueMessage() {
    //update last message read status

    if (widget.message.read!.isEmpty) {
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
            child: widget.message.type == Type.text
                ? Text(
                    widget.message.msg!,
                    style: const TextStyle(fontSize: 15),
                  )
                : CachedNetworkImage(
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.image),
                    imageUrl: widget.message.msg!),
          ),
          Padding(
            padding: EdgeInsets.only(left: w * 0.04, top: h * 0.005),
            child: Text(
              MyDateUtil.getFormattedTime(
                  context: context, time: widget.message.sent!),
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
            child: widget.message.type == Type.text
                ? Text(
                    widget.message.msg!,
                    style: const TextStyle(fontSize: 15),
                  )
                : CachedNetworkImage(
                    placeholder: (context, url) =>
                        const CircularProgressIndicator(strokeWidth: 2),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.image),
                    imageUrl: widget.message.msg!),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: w * 0.04),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  MyDateUtil.getFormattedTime(
                      context: context, time: widget.message.sent!),
                  style: const TextStyle(fontSize: 12, color: Colors.black87),
                ),
                (widget.message.read != "")
                    ? const Icon(
                        Icons.done_all_rounded,
                        color: Colors.blue,
                      )
                    : const Icon(Icons.done_outlined),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showBottomSheet(bool isMe) {
    showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(20), topLeft: Radius.circular(20))),
        builder: (_) {
          return ListView(
            shrinkWrap: true,
            children: [
              Container(
                height: 4,
                margin: EdgeInsets.symmetric(
                    vertical: h * 0.015, horizontal: w * 0.4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.grey,
                ),
              ),
              (widget.message.type == Type.text)
                  ? OptionItem(
                      icon: const Icon(
                        Icons.copy_all_rounded,
                        color: Colors.blue,
                        size: 26,
                      ),
                      name: "Copy",
                      onTap: () {})
                  : OptionItem(
                      icon: const Icon(
                        Icons.download,
                        color: Colors.blue,
                        size: 26,
                      ),
                      name: "Save Image",
                      onTap: () {}),
              Divider(
                  color: Colors.black54, endIndent: w * 0.04, indent: w * 0.04),
              (widget.message.type == Type.text && isMe)
                  ? OptionItem(
                      icon: const Icon(
                        Icons.edit,
                        color: Colors.blue,
                      ),
                      name: "Edit Message",
                      onTap: () {})
                  : Container(),
              if(isMe)
              OptionItem(
                  icon: const Icon(
                    Icons.delete,
                    color: Colors.blue,
                    size: 26,
                  ),
                  name: "Delete Message",
                  onTap: () {}),
              Divider(
                  color: Colors.black54, endIndent: w * 0.04, indent: w * 0.04),
              OptionItem(
                  icon: const Icon(
                    Icons.remove_red_eye,
                    color: Colors.green,
                    size: 26,
                  ),
                  name: "Sent At",
                  onTap: () {}),
              OptionItem(
                  icon: const Icon(
                    Icons.remove_red_eye,
                    color: Colors.red,
                    size: 26,
                  ),
                  name: "Read At",
                  onTap: () {})
            ],
          );
        });
  }
}

class OptionItem extends StatelessWidget {
  final Icon icon;
  final String name;
  final VoidCallback onTap;

  const OptionItem(
      {Key? key, required this.icon, required this.name, required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Padding(
        padding:
            EdgeInsets.only(left: w * 0.05, bottom: h * 0.015, top: h * 0.015),
        child: Row(
          children: [
            icon,
            Flexible(
                child: Text(
              '     $name',
              style: const TextStyle(
                  fontSize: 15, color: Colors.black, letterSpacing: 0.5),
            )),
          ],
        ),
      ),
    );
  }
}
