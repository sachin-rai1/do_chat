import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_application/Model/UserModel.dart';
import 'package:chat_application/UI/view_profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../helper/constants.dart';

class ProfileDialog extends StatelessWidget {
  final UserModel user;

  const ProfileDialog({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.zero,
      backgroundColor: Colors.white.withOpacity(0.9),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      content: SizedBox(
        width: w * 0.6,
        height: h * 0.35,
        child: Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(h * 0.3),
                child: CachedNetworkImage(
                  height: h * 0.25,
                  width: h * 0.25,
                  fit: BoxFit.fill,
                  imageUrl: user.image!,
                  placeholder: (context, url) =>
                      const Center(child: CircularProgressIndicator()),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
              ),
            ),
            Positioned(
              left: w * 0.04,
                top: h * 0.02,
                width: w * 0.55,
                child: Text(
              user.name!,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            )),
            Positioned(
              right: 8,
              top: 6,
              child: MaterialButton(
                  onPressed: () {
                    Get.off(() => ViewProfileScreen(user: user));
                  },
                  shape: const CircleBorder(),
                  padding: EdgeInsets.zero,
                  child: const Icon(
                    Icons.info_outline,
                    color: Colors.blue,
                  )),
            )
          ],
        ),
      ),
    );
  }
}
