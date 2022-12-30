import 'dart:developer';
import 'dart:io';

import 'package:chat_application/Model/ChatModel.dart';
import 'package:chat_application/Model/UserModel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class APIs {
//for FireBase Auth
  static FirebaseAuth auth = FirebaseAuth.instance;

  static User? get user => auth.currentUser;

//For Accessing Firebase DataBase
  static FirebaseFirestore fireStore = FirebaseFirestore.instance;

  //for accessing firebaseStorage
  static FirebaseStorage storage = FirebaseStorage.instance;

  static late UserModel me;

  //for getting if users exists
  static Future<void> getSelfInfo() async {
    await fireStore.collection('users').doc(user!.uid).get().then((user) async {
      if (user.exists) {
        me = UserModel.fromJson(user.data()!);
      } else {
        await createUser().then((value) => getSelfInfo());
      }
    });
  }

  //for checking if users exists
  static Future<bool> userExists() async {
    return (await fireStore.collection('users').doc(user!.uid).get()).exists;
  }

  static Future<void> createUser() async {
    final time = DateTime.now().millisecondsSinceEpoch.toString();
    final userModel = UserModel(
        id: user!.uid,
        name: user!.displayName,
        email: user!.email,
        about: "Hey I am using Do Chat",
        image: user!.photoURL,
        isOnline: false,
        createdAt: time,
        lastActive: time,
        pushToken: "");
    return await fireStore
        .collection('users')
        .doc(user!.uid)
        .set(userModel.toJson());
  }

  static Future<void> updateSelfInfo() async {
    await fireStore
        .collection('users')
        .doc(user!.uid)
        .update({'name': me.name, 'about': me.about});
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllUser() {
    return fireStore
        .collection('users')
        .where('id', isNotEqualTo: user?.uid)
        .snapshots();
  }

  static Future<void> updateUserProfile(File file) async {
    final ext = file.path.split('.').last;

    log("Extension : $ext");

    //storage file ref with path
    final ref = storage.ref().child('profile_pictures/${user!.uid}');

    //uploading image
    await ref
        .putFile(file, SettableMetadata(contentType: 'image/$ext'))
        .then((p0) {
      log("Data Transfered :${p0.bytesTransferred / 1000} ");
    });

    //updating image in firestore database

    me.image = await ref.getDownloadURL();
    await fireStore.collection('users').doc(user!.uid).update({
      'image': me.image,
    });
  }

  /// ******** Chat Screen Apis ********** ///

  static String getConversationId(String id) =>
      user!.uid.hashCode <= id.hashCode
          ? '${user!.uid}_$id'
          : '${id}_${user!.uid}';

  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllMessages(UserModel user) {
    return fireStore
        .collection('chats/${getConversationId(user.id!)}/messages').orderBy('sent' , descending: true)
        .snapshots();
  }

  static Future<void> sendMessage(UserModel chatUser, String msg , Type type) async {
    //message sending time
    final time = DateTime.now().millisecondsSinceEpoch.toString();

//message to send
    final ChatModel message = ChatModel(
      toId: chatUser.id,
      msg: msg,
      read: "",
      type: type,
      fromId: user!.uid,
      sent: time,
    );
    final ref = fireStore
        .collection('chats/${getConversationId(chatUser.id!)}/messages');
    await ref.doc(time).set(message.toJson());
  }

  static Future<void> updateMessageReadStatus(ChatModel messages) async {
    await fireStore
        .collection('chats/${getConversationId(messages.fromId!)}/messages')
        .doc(messages.sent)
        .update({'read': DateTime.now().millisecondsSinceEpoch.toString()});
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getLastMessages(UserModel user) {
    return fireStore
        .collection('chats/${getConversationId(user.id!)}/messages').orderBy('sent' , descending: true)
        .snapshots();
  }


  static Future<void> sendChatImage(UserModel chatUser , File file)async{
    final ext = file.path.split('.').last;


    //storage file ref with path
    final ref = storage.ref().child('images/${getConversationId(chatUser.id!)}/${DateTime.now().millisecondsSinceEpoch}');

    //uploading image
    await ref
        .putFile(file, SettableMetadata(contentType: 'image/$ext'))
        .then((p0) {
      log("Data Transfered :${p0.bytesTransferred / 1000} ");
    });

    //updating image in firestore database

    final imageUrl = await ref.getDownloadURL();
    await sendMessage(chatUser, imageUrl, Type.image);
  }

}
