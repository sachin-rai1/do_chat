import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class APIs {
//for FireBase Auth
  static FirebaseAuth auth = FirebaseAuth.instance;

//For Accessing Firebase DataBase
  static FirebaseFirestore fireStore = FirebaseFirestore.instance;
}
