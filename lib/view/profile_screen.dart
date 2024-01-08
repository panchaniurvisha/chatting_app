// ignore_for_file: use_build_context_synchronously

import 'dart:developer';
import 'dart:io';

import 'package:chatting_app/api/apis.dart';
import 'package:chatting_app/helper/dialogs.dart';
import 'package:chatting_app/res/common/media_query.dart';
import 'package:chatting_app/view/auth/login_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';

import '../models/chat_user_model.dart';
import '../res/constant/app_images.dart';

class ProfileScreen extends StatefulWidget {
  final ChatUserModel? chatUserModel;

  const ProfileScreen({
    super.key,
    this.chatUserModel,
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final formKey = GlobalKey<FormState>();
  String? profileImage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text("Profile Screen"),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          Dialogs.showProgressBar(context);
          await APIs.auth.signOut().then((value) async {
            await GoogleSignIn().signOut().then((value) {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                  (route) => false);
            });
          });

          // await Navigator.pushNamedAndRemoveUntil(context, MaterialPageRoute(builder: (context) => LoginScreen()), (route) => false);
        },
        backgroundColor: Colors.black,
        label: const Text("Logout"),
        icon: const Icon(Icons.login_outlined),
      ),
      body: Form(
        key: formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 15),
                child: Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    profileImage != null
                        ? ClipRRect(
                            borderRadius:
                                BorderRadius.circular(height(context) * .1),
                            child: Image.file(File(profileImage!),
                                width: height(context) * .1,
                                height: height(context) * .1,
                                fit: BoxFit.cover),
                          )
                        : ClipRRect(
                            borderRadius:
                                BorderRadius.circular(height(context) * .1),
                            child: Image.network(
                                "${widget.chatUserModel!.image}",
                                fit: BoxFit.cover,
                                width: height(context) * .1,
                                height: height(context) * .1,
                                errorBuilder: (context, error, stackTrace) =>
                                    Icon(
                                      CupertinoIcons.profile_circled,
                                      size: 80.h,
                                    )),
                          ),
                    Positioned(
                      left: 25.w,
                      child: MaterialButton(
                        elevation: 1,
                        height: 25.w,
                        color: Colors.white,
                        onPressed: () {
                          showBottomSheet();
                        },
                        shape: const CircleBorder(),
                        child: Icon(Icons.edit, size: 15.w),
                      ),
                    )
                  ],
                ),
              ),
              Text(widget.chatUserModel!.email.toString(),
                  style: TextStyle(fontSize: 18.sp)),
              SizedBox(
                height: 15.h,
              ),
              TextFormField(
                initialValue: widget.chatUserModel!.name,
                onSaved: (value) => APIs.me!.name = value ?? "",
                validator: (value) =>
                    value != null && value.isNotEmpty ? null : "Require Field",
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.person, color: Colors.black38),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  hintText: "eg. Rinkal Sudani",
                  label: const Text("Name"),
                ),
              ),
              SizedBox(
                height: 15.h,
              ),
              TextFormField(
                initialValue: widget.chatUserModel!.about,
                onSaved: (value) => APIs.me!.about = value ?? "",
                validator: (value) =>

                    ///both condition is true then ?null othervise "Require Field"
                    value != null && value.isNotEmpty ? null : "Require Field",
                decoration: InputDecoration(
                  prefixIcon:
                      const Icon(Icons.info_outline, color: Colors.black38),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  hintText: "eg. Feellig Happy",
                  label: const Text("About"),
                ),
              ),
              SizedBox(
                height: 25.h,
              ),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.yellow.shade300,
                    shape: const StadiumBorder(),
                    minimumSize:
                        Size(width(context) / 2, height(context) / 18)),
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    log('inner validator');
                    formKey.currentState!.save();
                    APIs.updateUserInfo().then((value) {
                      Dialogs.showSnackbar(
                          context, "Profile updayed Successfully");
                    });
                  }
                },
                icon: const Icon(Icons.edit, color: Colors.black),
                label: Text(
                  "Update",
                  style: TextStyle(fontSize: 18.sp, color: Colors.black),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> showBottomSheet() async {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15), topRight: Radius.circular(15)),
      ),
      builder: (context) {
        return ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.only(
            top: 10,
            bottom: 10,
          ),
          children: [
            Text(
              "Pick Profile Picture",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
            ),
            Padding(
              padding: EdgeInsets.only(top: 15.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                      onPressed: () async {
                        final ImagePicker picker = ImagePicker();
                        final XFile? image =
                            await picker.pickImage(source: ImageSource.gallery);
                        if (image != null) {
                          setState(() {
                            profileImage = image.path;
                          });
                          debugPrint(
                              "Image Path:${image.path}---MimeType:${image.mimeType}");
                          APIs.updateProfilePicture(File(profileImage!));
                          Navigator.pop(context);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                          shape: const CircleBorder(),
                          fixedSize: Size(80.w, 80.h),
                          backgroundColor: Colors.white70),
                      child: Image.asset(
                        AppImages.galleryImage,
                      )),
                  ElevatedButton(
                      onPressed: () async {
                        final ImagePicker picker = ImagePicker();
                        final XFile? image =
                            await picker.pickImage(source: ImageSource.camera);
                        if (image != null) {
                          setState(() {
                            profileImage = image.path;
                          });
                          debugPrint("Image Path:${image.path}");
                          APIs.updateProfilePicture(File(profileImage!));
                          Navigator.pop(context);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                          shape: const CircleBorder(),
                          fixedSize: Size(80.w, 80.h),
                          backgroundColor: Colors.white70),
                      child: Image.asset(AppImages.cameraImage)),
                ],
              ),
            )
          ],
        );
      },
    );
  }
}
