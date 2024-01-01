import 'package:chatting_app/models/chat_user_model.dart';
import 'package:flutter/material.dart';

class ChatUserCard extends StatelessWidget {
  final ChatUserModel? chatUSerModel;
  const ChatUserCard({super.key, required this.chatUSerModel});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        child: ListTile(
          onTap: () {},
          title: Text("${chatUSerModel!.name}"),
          subtitle: Text("${chatUSerModel!.about}"),
          trailing: Text("${chatUSerModel!.email}"),
        ),
      ),
    );
  }
}
