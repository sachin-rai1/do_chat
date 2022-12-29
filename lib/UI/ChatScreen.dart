import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_application/Model/UserModel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../helper/Constants.dart';

class ChatScreen extends StatefulWidget {
  final UserModel user;

  const ChatScreen({Key? key, required this.user}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          flexibleSpace: _appBar(),
        ),
        body: Column(
          children: [
            _chattingText(),
            _chatInput(),
          ],
        ),
      ),
    );
  }

  Widget _appBar() {
    return InkWell(
      onTap: () {},
      child: Row(
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
              imageUrl: widget.user.image!,
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
              Text(widget.user.name!),
              const SizedBox(
                height: 2,
              ),
              Text(widget.user.lastActive!)
            ],
          )
        ],
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
                      onPressed: () {},
                      icon: const Icon(
                        Icons.emoji_emotions,
                        color: Colors.blue,
                      )),

                  const Expanded(
                      child: TextField(
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    decoration: InputDecoration(
                        hintText: "Type Something ....",
                        hintStyle: TextStyle(color: Colors.blue),
                        border: InputBorder.none),
                  )),

                  //image button
                  IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.image,
                        color: Colors.blue,
                      )),

                  //camera button
                  IconButton(
                      onPressed: () {},
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
            onPressed: () {},
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

  Widget _chattingText()
  {
    return Expanded(
      child: StreamBuilder(
          // stream: APIs.getAllUser(),
          builder: (context, snapshot) {
            // final data = snapshot.data?.docs;
            // list = data?.map((e) => UserModel.fromJson(e.data())).toList() ?? [];
            final list = ['hii' , 'hello'];
            return
              // (snapshot.connectionState == ConnectionState.active)
                (list.isNotEmpty)
                ? ListView.builder(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.only(top: h * 0.01),
                itemCount:list.length,
                itemBuilder: (BuildContext context, index) {
                  return Text("List Of message : ${list[index]}");
                })
                : const Center(child: Text("Say Hey! 👋 " , style: TextStyle(fontWeight: FontWeight.w500 , fontSize: 18),));

          }),
    );
  }

}
