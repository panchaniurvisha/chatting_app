import 'package:chatting_app/models/chat_user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class APIs {
  static FirebaseAuth auth = FirebaseAuth.instance;

  static FirebaseFirestore fireStore = FirebaseFirestore.instance;

  /// for checking if user exists or not
  static Future<bool> userExists() async {
    return (await fireStore
            .collection("users")
            .doc(auth.currentUser!.uid)
            .get())
        .exists;
  }

  ///to return current user
  static User get user => auth.currentUser!;

  /// for creating new user
  static Future<void> createUser() async {
    final time = DateTime.now().millisecondsSinceEpoch.toString();
    final chatUser = ChatUserModel(
      id: user.uid,
      name: user.displayName.toString(),
      email: user.email.toString(),
      image: user.photoURL.toString(),
      about: "Hey,i am using we chat",
      createdAt: time,
      isOnline: false,
      lastActive: time,
      pushToken: "",
    );
    return await fireStore
        .collection("users")
        .doc(user.uid)
        .set(chatUser.toJson());
  }
}
