

import 'dart:developer';
import 'dart:io';


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

  //for checking if users exists
  static Future<bool> userExists() async {
    return (await fireStore.collection('users').doc(user!.uid).get()).exists;
  }


  //for accessing firebaseStorage
  static FirebaseStorage storage = FirebaseStorage.instance;

  static late UserModel me;
  //for getting if users exists
  static Future<void> getSelfInfo() async {
    await fireStore.collection('users').doc(user!.uid).get().then((user) async {
      if(user.exists){
        me = UserModel.fromJson(user.data()!);
      }
      else{
        await createUser().then((value) => getSelfInfo());
      }

    });
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
    await fireStore.collection('users').doc(user!.uid).update(
        {
          'name' : me.name,
          'about' : me.about

        }
    );

  }


  static Stream<QuerySnapshot<Map<String , dynamic>>> getAllUser(){
    return fireStore.collection('users').where('id' , isNotEqualTo: user?.uid).snapshots();
  }
  
  static Future<void> updateUserProfile(File file) async {

    final ext = file.path.split('.').last;

    log("Extension : $ext");

    //storage file ref with path
    final ref =  storage.ref().child('profile_pictures/${user!.uid}');

    //uploading image
    await ref.putFile(file , SettableMetadata(contentType: 'image/$ext')).then((p0){
      log("Data Transfered :${p0.bytesTransferred/1000} ");
    });

    //updating image in firestore database

    me.image = await ref.getDownloadURL();
    await fireStore.collection('users').doc(user!.uid).update(
        {
          'image' : me.image,
        }
    );
  }
  
}
