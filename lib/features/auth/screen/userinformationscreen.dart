import 'dart:io';
import 'package:buzzzchat/features/auth/controller.dart';
import 'package:buzzzchat/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:buzzzchat/models/user.dart' as model;

class UserInformationScreen extends ConsumerStatefulWidget {
  final String uid;
  final bool update;
  const UserInformationScreen(
      {super.key, required this.uid, required this.update});

  @override
  ConsumerState<UserInformationScreen> createState() =>
      _UserInformationScreenState();
}

class _UserInformationScreenState extends ConsumerState<UserInformationScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController usernamenameController = TextEditingController();
  final TextEditingController bioController = TextEditingController();
  File? image;
  model.User? usd;
  bool isLoading = false;

  @override
  void initState() {
    widget.update ? getdata() : null;
    super.initState();
  }

  void getdata() async {
    setState(() {
      isLoading = true;
    });
    usd = await ref.read(authControllerProvider).getUserDetails();
    if (usd != null) {
      nameController.text = usd!.name;
      usernamenameController.text = usd!.username;
      bioController.text = usd!.bio;
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
  }

  void selectImage() async {
    image = await pickImageFromGallery(context);
    setState(() {});
  }

  void storeUserData() async {
    String username = usernamenameController.text.trim();
    String name = nameController.text.trim();
    String bio = bioController.text.trim();
    if (name.isNotEmpty) {
      ref
          .read(authControllerProvider)
          .saveUserDataToFirebase(context, name, username, bio, image);
    }
  }

  void update() async {
    String username = usernamenameController.text.trim();
    String name = nameController.text.trim();
    String bio = bioController.text.trim();
    if (name.isNotEmpty) {
      ref
          .read(authControllerProvider)
          .update(context, name, username, bio, image);
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Scaffold(
            body: SafeArea(
              child: Container(
                decoration: const BoxDecoration(
                    gradient: LinearGradient(colors: [
                  Color.fromARGB(255, 253, 216, 3),
                  Color.fromARGB(255, 252, 127, 3)
                ])),
                child: Center(
                  child: Column(
                    children: [
                      SizedBox(
                        height: height * 0.05,
                      ),
                      Stack(
                        children: [
                          image == null
                              ? widget.update
                                  ? CircleAvatar(
                                      backgroundImage:
                                          NetworkImage(usd!.profilePic),
                                      radius: 95,
                                    )
                                  : const CircleAvatar(
                                      backgroundImage:
                                          AssetImage("asset/images/user.png"),
                                      radius: 95,
                                    )
                              : CircleAvatar(
                                  backgroundImage: FileImage(
                                    image!,
                                  ),
                                  radius: 95,
                                ),
                          Positioned(
                            bottom: -6,
                            left: 125,
                            child: IconButton(
                              iconSize: 35,
                              color: Colors.black,
                              onPressed: selectImage,
                              icon: const Icon(
                                Icons.add_a_photo,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: height * 0.03),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            color: Colors.black,
                            Icons.person,
                          ),
                          Container(
                            width: width * 0.85,
                            padding: const EdgeInsets.all(10),
                            child: TextField(
                              controller: nameController,
                              decoration: const InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                hintText: 'Enter your name',
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            color: Colors.black,
                            Icons.circle_outlined,
                          ),
                          Container(
                            width: width * 0.85,
                            padding: const EdgeInsets.all(10),
                            child: TextField(
                              controller: usernamenameController,
                              decoration: const InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                hintText: 'Select Username',
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            color: Colors.black,
                            Icons.insert_drive_file,
                          ),
                          Container(
                            width: width * 0.85,
                            padding: const EdgeInsets.all(10),
                            child: TextField(
                              controller: bioController,
                              minLines: 3,
                              maxLines: 5,
                              decoration: const InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                hintText: 'Enter you Bio',
                              ),
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      Row(
                        children: [
                          const Spacer(),
                          Padding(
                            padding: const EdgeInsets.only(
                                bottom: 24, right: 24, left: 24),
                            child: ElevatedButton(
                              onPressed: widget.update ? update : storeUserData,
                              style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      const Color.fromARGB(255, 97, 174, 79),
                                  fixedSize: const Size(150, 42)),
                              child: Center(
                                child: Text("Save",
                                    style: TextStyle(
                                        fontSize: 27,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w600)),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
  }
}
