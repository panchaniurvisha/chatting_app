import 'package:chatting_app/api/apis.dart';
import 'package:chatting_app/models/message_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MessageCard extends StatelessWidget {
  final MessageModel? messageModel;
  const MessageCard({super.key, this.messageModel});

  @override
  Widget build(BuildContext context) {
    return APIs.user.uid == messageModel!.fromId ? redMessage() : blueMessage();
  }

  Widget blueMessage() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
            decoration: BoxDecoration(
              color: Colors.blueAccent.shade100,
              border: Border.all(color: Colors.black),
              borderRadius: BorderRadius.all(Radius.circular(30.sp))
                  .copyWith(bottomLeft: Radius.circular(0)),
            ),
            child: Padding(
              padding: EdgeInsets.all(10.w),
              child: Text("${messageModel!.msg}",
                  style:
                      TextStyle(fontSize: 15.sp, fontWeight: FontWeight.bold)),
            ),
          ),
        ),
        Text(messageModel!.sent.toString(),
            style: TextStyle(fontSize: 12.sp, color: Colors.black54))
      ],
    );
  }

  Widget redMessage() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(
              Icons.done_all_rounded,
              color: Colors.blue,
              size: 20.sp,
            ),
            SizedBox(
              width: 5,
            ),
            Text(
              messageModel!.read.toString() + "12.00 AM",
              style: TextStyle(fontSize: 12.sp, color: Colors.black54),
            ),
          ],
        ),
        Flexible(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
            decoration: BoxDecoration(
              color: Colors.red.shade100,
              border: Border.all(color: Colors.black),
              borderRadius: BorderRadius.all(Radius.circular(30.sp))
                  .copyWith(bottomRight: Radius.circular(0)),
            ),
            child: Padding(
              padding: EdgeInsets.all(10.w),
              child: Text("${messageModel!.msg}",
                  style:
                      TextStyle(fontSize: 15.sp, fontWeight: FontWeight.bold)),
            ),
          ),
        ),
      ],
    );
  }
}
