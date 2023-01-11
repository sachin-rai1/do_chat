import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_application/helper/mydate_util.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../Model/UserModel.dart';
import '../../helper/constants.dart';

class ViewProfileScreen extends StatefulWidget {
  final UserModel user;

  const ViewProfileScreen({Key? key, required this.user}) : super(key: key);

  @override
  State<ViewProfileScreen> createState() => _ViewProfileScreenState();
}

class _ViewProfileScreenState extends State<ViewProfileScreen> {

  String? _image;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          leading: GestureDetector(
              onTap: () {
                Get.back();
              },
              child: const Icon(Icons.arrow_back)),
          title: Text(widget.user.name!),
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: w * 0.05),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(width: w, height: h * 0.03),
                _image != null
                    ?
                    //local image
                    ClipRRect(
                        borderRadius: BorderRadius.circular(h / 2),
                        child: Image.file(
                          File(_image!),
                          width: w / 2,
                          height: h / 4.5,
                          fit: BoxFit.cover,
                        ))
                    :

                    //image from server
                    ClipRRect(
                        borderRadius: BorderRadius.circular(500),
                        child: CachedNetworkImage(
                          width: 250,
                          height: 250,
                          fit: BoxFit.fill,
                          imageUrl: widget.user.image!,
                          placeholder: (context, url) =>
                              const Center(child: CircularProgressIndicator()),
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                        ),
                      ),
                SizedBox(height: h * 0.03),
                Text(
                  widget.user.email!,
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.w600),
                ),
                SizedBox(height: h * 0.03),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("About : ",
                        style: TextStyle(
                            fontSize: 18,
                            color: Colors.black87,
                            fontWeight: FontWeight.bold)),
                    Text(" ${widget.user.about!}",
                        style: const TextStyle(
                            fontSize: 18, color: Colors.black87)),
                  ],
                ),
              ],
            ),
          ),
        ),
        floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Joined On  : ",
                style: TextStyle(
                    fontSize: 15,
                    color: Colors.black87,
                    fontWeight: FontWeight.bold)),
            Text(" ${MyDateUtil.getLastMessageTime(context: context, time: widget.user.createdAt! ,showYear: true)}",
                style: const TextStyle(fontSize: 15, color: Colors.black87)),
          ],
        ),
      ),
    );
  }
}
