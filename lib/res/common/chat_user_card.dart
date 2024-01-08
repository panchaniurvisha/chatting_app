import 'package:chatting_app/models/chat_user_model.dart';
import 'package:flutter/material.dart';

import '../../view/chat_screen.dart';
import 'media_query.dart';

class ChatUserCard extends StatelessWidget {
  final ChatUserModel? chatUserModel;

  const ChatUserCard({super.key, required this.chatUserModel});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ChatScreen(
                        chatUserModel: chatUserModel!,
                      )));
        },
        child: ListTile(
            // leading: ClipRRect(
            //   borderRadius: BorderRadius.circular(30),
            //   child: Image.network("${chatUSerModel!.image}",
            //       fit: BoxFit.contain,
            //       errorBuilder: (context, error, stackTrace) =>
            //           Icon(CupertinoIcons.profile_circled)),
            // ),
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(height(context) / 10),
              child: CircleAvatar(
                backgroundImage: NetworkImage(
                  "${chatUserModel!.image}",
                  //   Image.file(
                  //   File(profileImage!),
                  //   // height: 500.h,
                  //   fit: BoxFit.cover,
                  // ),
                ),
                radius: 50,
              ),
            ),
            title: Text("${chatUserModel!.name}"),
            subtitle: Text("${chatUserModel!.about}"),
            trailing: const CircleAvatar(
              radius: 10,
              backgroundColor: Colors.lightGreenAccent,
            )),
      ),
    );
  }
}
