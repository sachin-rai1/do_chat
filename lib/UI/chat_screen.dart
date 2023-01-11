import 'dart:developer';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_application/Model/UserModel.dart';
import 'package:chat_application/UI/view_profile_screen.dart';
import 'package:chat_application/Widgets/message_card.dart';
import 'package:chat_application/helper/mydate_util.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../Model/ChatModel.dart';
import '../api/api.dart';
import '../helper/constants.dart';

class ChatScreen extends StatefulWidget {
  final UserModel user;

  const ChatScreen({Key? key, required this.user}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  List<ChatModel> list = [];
  bool _showEmoji = false;

  bool _isUploadingImage = false;

  final TextEditingController _msgController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: SafeArea(
        child: WillPopScope(
          onWillPop: () {
            if (_showEmoji) {
              setState(() {
                _showEmoji = !_showEmoji;
              });
              return Future.value(false);
            }
            return Future.value(true);
          },
          child: Scaffold(
            resizeToAvoidBottomInset: true,
            appBar: AppBar(
              automaticallyImplyLeading: false,
              flexibleSpace: _appBar(),
            ),
            body: Column(
              children: [
                _chattingText(),
                if (_isUploadingImage)
                  const Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                        ),
                      )),
                _chatInput(),
                if (_showEmoji)
                  SizedBox(
                    height: h * 0.35,
                    child: EmojiPicker(
                      textEditingController: _msgController,
                      config: Config(
                        columns: 8,
                        emojiSizeMax: 32 * (Platform.isIOS ? 1.3 : 1.0),
                      ),
                    ),
                  )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _appBar() {
    return InkWell(
      onTap: () {
        Get.to(() => ViewProfileScreen(user: widget.user));
      },
      child: StreamBuilder(
        stream: APIs.getUserStatusInfo(widget.user),
        builder: (BuildContext context, snapshot) {
          final data = snapshot.data?.docs;

          final list =
              data?.map((e) => UserModel.fromJson(e.data())).toList() ?? [];

          return Row(
            children: [
              IconButton(
                  onPressed: () {
                    Get.back();
                  },
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Colors.black,
                  )),
              ClipRRect(
                borderRadius: BorderRadius.circular(h * 0.5),
                child: CachedNetworkImage(
                  height: h * 0.05,
                  fit: BoxFit.cover,
                  width: w * 0.1,
                  imageUrl:
                      list.isNotEmpty ? list[0].image! : widget.user.image!,
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(list.isNotEmpty ? list[0].name! : widget.user.name!),
                  const SizedBox(
                    height: 2,
                  ),
                  Text(list.isNotEmpty
                      ? list[0].isOnline! ?
                      'Online':MyDateUtil.getLastActiveTime(context: context, lastActiveTime: widget.user.lastActive!)
                      :MyDateUtil.getLastActiveTime(context: context, lastActiveTime: widget.user.lastActive!))
                ],
              )
            ],
          );
        },
      ),
    );
  }

  Widget _chatInput() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: h * 0.01, horizontal: w * 0.025),
      child: Row(
        children: [
          Expanded(
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Row(
                children: [
                  //emoji button
                  IconButton(
                      onPressed: () {
                        setState(() {
                          _showEmoji = !_showEmoji;
                        });
                      },
                      icon: const Icon(
                        Icons.emoji_emotions,
                        color: Colors.blue,
                      )),

                  Expanded(
                      child: TextField(
                    onTap: () {
                      if (_showEmoji) {
                        setState(() {
                          _showEmoji = !_showEmoji;
                        });
                      }
                    },
                    controller: _msgController,
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    decoration: const InputDecoration(
                        hintText: "Type Something ....",
                        hintStyle: TextStyle(color: Colors.blue),
                        border: InputBorder.none),
                  )),

                  //image button
                  IconButton(
                      onPressed: () async {
                        final ImagePicker picker = ImagePicker();

                        final List<XFile> images =
                            await picker.pickMultiImage();

                        for (var i in images) {
                          setState(() {
                            _isUploadingImage = true;
                          });
                          await APIs.sendChatImage(widget.user, File(i.path));
                        }

                        setState(() {
                          _isUploadingImage = false;
                        });
                      },
                      icon: const Icon(
                        Icons.image,
                        color: Colors.blue,
                      )),

                  //camera button
                  IconButton(
                      onPressed: () async {
                        String? _image;
                        final ImagePicker _picker = ImagePicker();
                        final XFile? image =
                            await _picker.pickImage(source: ImageSource.camera);

                        log('image path : ${image?.path} -- MimeType : ${image?.mimeType}');
                        setState(() {
                          _isUploadingImage = true;
                        });

                        setState(() {
                          _image = image!.path;
                        });
                        await APIs.sendChatImage(widget.user, File(_image!));
                        setState(() {
                          _isUploadingImage = false;
                        });
                      },
                      icon: const Icon(
                        Icons.camera_alt_rounded,
                        color: Colors.blue,
                      )),
                ],
              ),
            ),
          ),
          MaterialButton(
            minWidth: 0,
            onPressed: () {
              if (_msgController.text.isNotEmpty) {
                if(list.isEmpty){

                  ///add user by sending first msg to user

                  APIs.sendFirstMsg(widget.user, _msgController.text, Type.text);
                }
                else {

                  ///simply send msg after user added

                  APIs.sendMessage(widget.user, _msgController.text, Type.text);
                }
                _msgController.text = "";
              }
            },
            padding:
                const EdgeInsets.only(top: 10, bottom: 10, left: 10, right: 5),
            shape: const CircleBorder(),
            color: Colors.greenAccent,
            child: const Icon(
              Icons.send,
              color: Colors.white,
            ),
          )
        ],
      ),
    );
  }

  Widget _chattingText() {
    return Expanded(
      child: StreamBuilder(
          stream: APIs.getAllMessages(widget.user),
          builder: (context, snapshot) {
            final data = snapshot.data?.docs;
            list =
                data?.map((e) => ChatModel.fromJson(e.data())).toList() ?? [];

            return (snapshot.connectionState == ConnectionState.active)
                ? (list.isNotEmpty)
                    ? ListView.builder(
                        reverse: true,
                        physics: const BouncingScrollPhysics(),
                        padding: EdgeInsets.only(top: h * 0.01),
                        itemCount: list.length,
                        itemBuilder: (BuildContext context, index) {
                          return MessageCard(message: list[index]);
                        })
                    : const Center(
                        child: Text(
                        "Say Hey! 👋 ",
                        style: TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 18),
                      ))
                : Container();
          }),
    );
  }
}
