import 'dart:io';

import 'package:chatting_app/models/chat_user_model.dart';
import 'package:chatting_app/models/message_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class APIs {
  static FirebaseAuth auth = FirebaseAuth.instance;

  ///For accessing cloud firestore database
  static FirebaseFirestore fireStore = FirebaseFirestore.instance;

  ///For accessing  firebase storage
  static FirebaseStorage storage = FirebaseStorage.instance;

  ///to return current user
  static User get user => auth.currentUser!;

  ///for storing self information
  static ChatUserModel me = ChatUserModel(
    id: user.uid,
    name: user.displayName.toString(),
    email: user.email.toString(),
    image: user.photoURL.toString(),
    about: "Hey,i am using we chat",
    createdAt: "",
    isOnline: false,
    lastActive: "",
    pushToken: "",
  );

  /// for checking if user exists or not
  static Future<bool> userExists() async {
    return (await fireStore
            .collection("users")
            .doc(auth.currentUser!.uid)
            .get())
        .exists;
  }

  ///for getting current user info
  static Future<void> getSelfInfo() async {
    await fireStore.collection("users").doc(user.uid).get().then((user) async {
      if (user.exists) {
        me = ChatUserModel.fromJson(user.data()!);
        debugPrint("My data:${user.data()}");
      } else {
        await createUser().then((value) => getSelfInfo());
      }
    });
  }

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

  ///for getting All Users from firestore database
  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllUsers() {
    return fireStore
        .collection("users")
        // .where("id", isNotEqualTo: user.uid)
        .snapshots();
  }

  static Future<void> updateUserInfo() async {
    await fireStore
        .collection("users")
        .doc(user.uid)
        .update({"name": me.name, "about": me.about}).then((user) async {});
  }

  ///Update Profile picture of user
  static Future<void> updateProfilePicture(File file) async {
    final extension = file.path.split(".").last;
    debugPrint("extension-->$extension");
    final ref = storage.ref().child("profile pictures/${user.uid}.$extension");
    await ref
        .putFile(file, SettableMetadata(contentType: "image/$extension"))
        .then((p0) =>
            debugPrint("Data Transferd-->${p0.bytesTransferred / 1000} kb"));
    me.image = await ref.getDownloadURL();
    await fireStore.collection("users").doc(user.uid).update({
      "image": me.image,
    });
  }

  ///--------- chat screen related Api---
  ///
  ///chats(collection)-->conversition_id(doc)-->messages(collection)-->message(doc)
  ///useful for getting conversition id
  static String getConversationId(String id) =>

      ///id ==> means messgae receive kre
      user.uid.hashCode <= id.hashCode
          ? "${user.uid}_$id"
          : "${id}_${user.uid}";

  ///for getting All Users from firestore database
  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllMessages(
      ChatUserModel chatUserModel) {
    return fireStore
        .collection(
            "chats/${getConversationId(chatUserModel.id.toString())}/messages")
        .snapshots();
  }

  ///For sending Message
  static Future<void> sendMessage(
      ChatUserModel chatUserModel, String msg) async {
    ///message sending time (also used as id)
    final time = DateTime.now().millisecondsSinceEpoch;
    MessageModel messageModel = MessageModel(
        toId: chatUserModel.id,
        msg: msg,
        read: "",
        fromId: user.uid,
        sent: time.toString(),
        type: Type.text);
    final ref = fireStore.collection(
        "chats/${getConversationId(chatUserModel.id.toString())}/messages");
    await ref.doc(time.toString()).set(messageModel.toJson());
  }
}
