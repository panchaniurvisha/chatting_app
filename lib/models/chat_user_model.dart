// To parse this JSON data, do
//
//     final chatUserModel = chatUserModelFromJson(jsonString);

import 'dart:convert';

ChatUserModel chatUserModelFromJson(String str) =>
    ChatUserModel.fromJson(json.decode(str));

String chatUserModelToJson(ChatUserModel data) => json.encode(data.toJson());

class ChatUserModel {
  String? name;
  String? about;
  String? createdAt;
  bool? isOnline;
  String? id;
  String? image;
  String? lastActive;
  String? email;
  String? pushToken;

  ChatUserModel({
    this.name,
    this.about,
    this.createdAt,
    this.isOnline,
    this.id,
    this.image,
    this.lastActive,
    this.email,
    this.pushToken,
  });

  factory ChatUserModel.fromJson(Map<String, dynamic> json) => ChatUserModel(
        name: json["name"],
        about: json["about"],
        createdAt: json["created_at"],
        isOnline: json["is_online"],
        id: json["id"],
        image: json["image"],
        lastActive: json["last_active"],
        email: json["email"],
        pushToken: json["push_token"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "about": about,
        "created_at": createdAt,
        "is_online": isOnline,
        "id": id,
        "image": image,
        "last_active": lastActive,
        "email": email,
        "push_token": pushToken,
      };
}
