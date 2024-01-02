import 'package:chatting_app/api/apis.dart';
import 'package:chatting_app/res/common/chat_user_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../models/chat_user_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<ChatUserModel> list = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("We Chat"),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {},
          ),
          IconButton(
              onPressed: () {}, icon: const Icon(Icons.more_vert_outlined)),
        ],
        leading: const Icon(CupertinoIcons.home),
      ),
      body: StreamBuilder(
          stream: APIs.fireStore.collection("users").snapshots(),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
              case ConnectionState.none:
                return const Center(child: CircularProgressIndicator());
              case ConnectionState.active:
              case ConnectionState.done:
                if (snapshot.hasData) {
                  final data = snapshot.data?.docs;
                  list = data
                          ?.map((e) => ChatUserModel.fromJson(e.data()))
                          .toList() ??
                      [];
                  // for (var i in data!) {
                  //   print("Data:->${jsonEncode(i.data())}");
                  //   list.add(i.data()["name"]);
                  // }
                  if (list.isNotEmpty) {
                    return ListView.builder(
                        shrinkWrap: true,
                        itemCount: list.length,
                        itemBuilder: (context, index) =>
                            ChatUserCard(chatUSerModel: list[index])
                        //  Text("Name:${list[index]}"),
                        );
                  } else {
                    return Center(
                      child: Text(
                        "No Connection Found!",
                        style: TextStyle(fontSize: 20.sp),
                      ),
                    );
                  }
                }
            }
            return SizedBox();
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await APIs.auth.signOut();
          await GoogleSignIn().signOut();
          // await Navigator.pushNamedAndRemoveUntil(context, MaterialPageRoute(builder: (context) => LoginScreen()), (route) => false);
        },
        child: const Icon(Icons.add_comment_rounded),
      ),
    );
  }
}
