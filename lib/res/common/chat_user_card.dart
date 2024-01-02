import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatting_app/models/chat_user_model.dart';
import 'package:chatting_app/res/common/media_query.dart';
import 'package:flutter/material.dart';

class ChatUserCard extends StatelessWidget {
  final ChatUserModel? chatUSerModel;
  const ChatUserCard({super.key, required this.chatUSerModel});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: () {},
        child: ListTile(
          leading: ClipRRect(
            child: CachedNetworkImage(
              height: height(context) * .055,
              width: height(context) * .055,
              imageUrl:
                  "https://lh3.googleusercontent.com/a/ACg8ocIEZBC3CYaeaWfsD2caVfYILl8iJCylC4c-3IDRut3n2Q=s96-c",
              //placeholder: (context, url) => CircularProgressIndicator(),
              errorWidget: (context, url, error) => Icon(Icons.error),
            ),
          ),
          title: Text("${chatUSerModel!.name}"),
          subtitle: Text("${chatUSerModel!.about}"),
          trailing: Text("${chatUSerModel!.lastActive}"),
        ),
      ),
    );
  }
}
