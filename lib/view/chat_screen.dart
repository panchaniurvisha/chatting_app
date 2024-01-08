import 'package:chatting_app/models/chat_user_model.dart';
import 'package:chatting_app/res/common/message_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../api/apis.dart';
import '../models/message_model.dart';
import '../res/common/media_query.dart';

class ChatScreen extends StatefulWidget {
  final ChatUserModel? chatUserModel;

  const ChatScreen({super.key, required this.chatUserModel});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  List<MessageModel> list = [];
  final textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            flexibleSpace: appBar(),
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              children: [
                Expanded(
                  child: StreamBuilder(
                      stream: APIs.getAllMessages(widget.chatUserModel!),
                      builder: (context, snapshot) {
                        switch (snapshot.connectionState) {
                          case ConnectionState.waiting:
                          case ConnectionState.none:
                            return SizedBox();
                          case ConnectionState.active:
                          case ConnectionState.done:
                            final data = snapshot.data?.docs;
                            // debugPrint("Data->${jsonEncode(data![0].data())}");
                            list = data
                                    ?.map(
                                        (e) => MessageModel.fromJson(e.data()))
                                    .toList() ??
                                [];
                            if (list.isNotEmpty) {
                              return ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: list.length,
                                  itemBuilder: (context, index) =>
                                      MessageCard(messageModel: list[index]));
                            } else {
                              return Center(
                                child: Text(
                                  "Say hii 🖐️",
                                  style: TextStyle(fontSize: 20.sp),
                                ),
                              );
                            }
                        }
                      }),
                ),
                chatInput(),
              ],
            ),
          )),
    );
  }

  Widget appBar() {
    return Row(
      children: [
        IconButton(
            icon: const Icon(
              Icons.arrow_back_outlined,
            ),
            onPressed: () => Navigator.pop(context)),
        ClipRRect(
          borderRadius: BorderRadius.circular(height(context) / 10),
          child: CircleAvatar(
            backgroundImage: NetworkImage(
              "${widget.chatUserModel!.image}",
            ),
            radius: 25,
          ),
        ),
        const SizedBox(
          width: 10,
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.chatUserModel!.name!,
                style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.bold)),
            Text("Last seen not available",
                style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.black54))
          ],
        ),
      ],
    );
  }

  Widget chatInput() {
    return Row(
      children: [
        Expanded(
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.emoji_emotions,
                    color: Colors.blueAccent,
                  ),
                  onPressed: () {},
                ),
                Expanded(
                  child: TextField(
                    controller: textController,
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "Type Something",
                      hintStyle: TextStyle(color: Colors.blueAccent),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(
                    Icons.image,
                    color: Colors.blueAccent,
                  ),
                  onPressed: () {},
                ),
                IconButton(
                  icon: const Icon(
                    Icons.camera_alt_rounded,
                    color: Colors.blueAccent,
                  ),
                  onPressed: () {},
                )
              ],
            ),
          ),
        ),
        InkWell(
          child: const CircleAvatar(
            backgroundColor: Colors.green,
            child: Icon(Icons.send, color: Colors.white, size: 20),
          ),
          onTap: () {
            if (textController.text.isNotEmpty) {
              APIs.sendMessage(widget.chatUserModel!, textController.text);
              textController.text = "";
            }
          },
        )
      ],
    );
  }
}
