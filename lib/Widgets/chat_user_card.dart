import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_application/Model/UserModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../UI/ChatScreen.dart';
import '../helper/Constants.dart';

class ChatUserCard extends StatefulWidget {
  final UserModel user;

  const ChatUserCard({super.key, required this.user});

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
      child: InkWell(
        onTap: () {
          Get.to(() => ChatScreen(
                user: widget.user,
              ));
        },
        child: ListTile(
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(h* 0.5),
            child: CachedNetworkImage(
              height: h * 0.05,
              fit: BoxFit.cover,
              width: w * 0.1,
              imageUrl: widget.user.image!,
              errorWidget: (context, url, error) => Icon(Icons.error),
            ),
          ),
          title: Text(widget.user.name!),
          subtitle: Text(
            widget.user.about!,
            maxLines: 1,
          ),
          trailing: Container(
            width: 15,
            height: 15,
            decoration: BoxDecoration(
                color: Colors.greenAccent.shade400,
                borderRadius: BorderRadius.circular(10)),
          ),
          // Text(
          //   widget.user.lastActive!,
          //   style:const TextStyle(color: Colors.black),
          // ),
        ),
      ),
    );
  }
}
