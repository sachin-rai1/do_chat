import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_application/Model/ChatModel.dart';
import 'package:chat_application/Model/UserModel.dart';
import 'package:chat_application/api/api.dart';
import 'package:chat_application/helper/mydate_util.dart';
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
  //last msg info
  ChatModel? _messages;

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
        onTap: () async {
          await Get.to(() => ChatScreen(
                user: widget.user,
              ));
        },
        child: StreamBuilder(
            stream: APIs.getLastMessages(widget.user),
            builder: (context, snapshot) {
              final data = snapshot.data?.docs;

              final list =
                  data?.map((e) => ChatModel.fromJson(e.data())).toList() ?? [];
              if (list.isNotEmpty) {
                _messages = list[0];
              }

              return ListTile(
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(h * 0.5),
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
                  _messages != null
                      ? _messages!.type == Type.image
                          ? "Image"
                          : _messages!.msg!
                      : widget.user.about!,
                  maxLines: 1,
                ),
                trailing: (_messages == null)
                    ? null
                    : _messages!.read!.isEmpty &&
                            _messages!.fromId != APIs.user!.uid
                        ? Container(
                            width: 15,
                            height: 15,
                            decoration: BoxDecoration(
                                color: Colors.greenAccent.shade400,
                                borderRadius: BorderRadius.circular(10)),
                          )
                        : Text(MyDateUtil.getLastMessageTime(
                            context: context, time: _messages!.sent!)),
              );
            }),
      ),
    );
  }
}
