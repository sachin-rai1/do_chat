import 'dart:developer';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_application/UI/auth/login_screen.dart';
import 'package:chat_application/Widgets/chat_user_card.dart';
import 'package:chat_application/api/api.dart';
import 'package:chat_application/helper/dialog.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import '../../Model/UserModel.dart';
import '../../helper/Constants.dart';

class ProfileScreen extends StatefulWidget {
  final UserModel user;

  const ProfileScreen({Key? key, required this.user}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
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
                child: const Icon(CupertinoIcons.home)),
            title: const Text("Profile Screen"),
          ),
          floatingActionButton: Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: FloatingActionButton.extended(
              backgroundColor: Colors.redAccent,
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                await GoogleSignIn().signOut().then((value) => APIs.updateActiveStatus(false));
                Get.offAll(const LoginScreen());
              },
              label: const Text("Logout"),
              icon: const Icon(Icons.logout),
            ),
          ),
          body: Form(
            key: _formKey,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: w * 0.05),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(width: w, height: h * 0.03),
                    Stack(
                      children: [
                        _image != null
                            ?
                            //local image
                            ClipRRect(
                                borderRadius: BorderRadius.circular(h/2),
                                child: Image.file(
                                  File(_image!),
                                  width: w/2,
                                  height: h/4.5,
                                  fit: BoxFit.cover,
                                ))
                            :

                            //image from server
                            ClipRRect(
                                borderRadius: BorderRadius.circular(h),
                                child: CachedNetworkImage(
                                  width: w / 2,
                                  height: h/4.5,
                                  fit: BoxFit.cover,
                                  imageUrl: widget.user.image!,
                                  placeholder: (context, url) => const Center(
                                      child: CircularProgressIndicator()),
                                  errorWidget: (context, url, error) =>
                                      const Icon(Icons.error),
                                ),
                              ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: MaterialButton(
                            elevation: 1,
                            shape: const CircleBorder(),
                            onPressed: () {
                              _showBottomSheet();
                            },
                            color: Colors.white,
                            child: const Icon(
                              Icons.edit,
                              color: Colors.blue,
                            ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: h * 0.03),
                    Text(
                      widget.user.email!,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.w600),
                    ),
                    SizedBox(height: h * 0.03),
                    TextFormField(
                      onSaved: (val) => APIs.me.name = val ?? "",
                      validator: (val) => val != null && val.isNotEmpty
                          ? null
                          : 'Required Field',
                      initialValue: widget.user.name,
                      decoration: InputDecoration(
                          label: const Text("Name"),
                          hintText: "eg : Sachin Rai",
                          prefixIcon: const Icon(
                            CupertinoIcons.person,
                            color: Colors.blue,
                          ),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25))),
                    ),
                    SizedBox(height: h * 0.02),
                    TextFormField(
                      onSaved: (val) => APIs.me.about = val ?? "",
                      validator: (val) => val != null && val.isNotEmpty
                          ? null
                          : 'Required Field',
                      initialValue: widget.user.about,
                      decoration: InputDecoration(
                          label: const Text("About"),
                          hintText: "eg : Feeling Happy",
                          prefixIcon: const Icon(
                            CupertinoIcons.info_circle_fill,
                            color: Colors.blue,
                          ),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25))),
                    ),
                    SizedBox(height: h * 0.02),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                          shape: const StadiumBorder(),
                          minimumSize: Size(w * 0.4, h * 0.05)),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();
                          APIs.updateSelfInfo().then((value) {
                            Dialogs.showSnackBar(
                                context, "Updated" , Colors.green);
                          });
                          log("inside validator");
                        }
                      },
                      icon: const Icon(Icons.edit),
                      label: const Text("Update "),
                    )
                  ],
                ),
              ),
            ),
          )),
    );
  }

  void _showBottomSheet() {
    showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(20), topLeft: Radius.circular(20))),
        builder: (_) {
          return ListView(
            shrinkWrap: true,
            padding: EdgeInsets.only(top: h * 0.02, bottom: h * 0.05),
            children: [
              const Text(
                "Pick Profile Picture",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      final ImagePicker _picker = ImagePicker();
                      final XFile? image =
                          await _picker.pickImage(source: ImageSource.gallery);

                      log('image path : ${image?.path} -- MimeType : ${image?.mimeType}');

                      setState(() {
                        _image = image!.path;
                      });
                      APIs.updateUserProfile(File(_image!));

                      Get.back();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      shape: const CircleBorder(),
                      fixedSize: Size(w * 0.2, h * 0.15),
                    ),
                    child: Image.asset('assets/icons/photo.png'),
                  ),
                  ElevatedButton(
                    onPressed: () async{
                      final ImagePicker _picker = ImagePicker();
                      final XFile? image = await _picker.pickImage(source: ImageSource.camera);
                      log('image path : ${image?.path} -- MimeType : ${image?.mimeType}');

                      setState(() {
                        _image = image!.path;
                      });
                      APIs.updateUserProfile(File(_image!));
                      Get.back();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      shape: const CircleBorder(),
                      fixedSize: Size(w * 0.2, h * 0.1),
                    ),
                    child: Image.asset('assets/icons/camera.png'),
                  )
                ],
              ),
            ],
          );
        });
  }
}
