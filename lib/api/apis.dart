import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class APIs {
  static FirebaseAuth auth = FirebaseAuth.instance;

  static FirebaseFirestore fireStore = FirebaseFirestore.instance;

  /// for checking if user exists or not
  // static Future<bool> userExists() async {
  //   return await fireStore.collection("users").doc();
  // }
}
