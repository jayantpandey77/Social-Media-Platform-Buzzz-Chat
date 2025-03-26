import 'dart:io';
import 'package:buzzzchat/features/auth/controller.dart';
import 'package:buzzzchat/models/user.dart' as model;
import 'package:buzzzchat/features/post_comment/controller.dart';
import 'package:buzzzchat/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddPostScreen extends ConsumerStatefulWidget {
  const AddPostScreen({super.key});

  @override
  ConsumerState<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends ConsumerState<AddPostScreen> {
  model.User? user;
  File? _file;
  bool isLoading = false;
  final TextEditingController _descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getData();
  }

  Future<void> getData() async {
    user = await ref.read(authControllerProvider).getUserDetails();
    setState(() {});
  }

  Future<void> _selectImage(BuildContext parentContext) async {
    return showDialog(
      context: parentContext,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: const Text('Create a Post'),
          children: <Widget>[
            SimpleDialogOption(
              padding: const EdgeInsets.all(20),
              child: const Text('Take a photo'),
              onPressed: () async {
                Navigator.pop(context);
                File? file = await pickImageFromCamera(context);
                setState(() {
                  _file = file;
                });
              },
            ),
            SimpleDialogOption(
              padding: const EdgeInsets.all(20),
              child: const Text('Choose from Gallery'),
              onPressed: () async {
                Navigator.of(context).pop();
                File? file = await pickImageFromGallery(context);
                setState(() {
                  _file = file;
                });
              },
            ),
            SimpleDialogOption(
              padding: const EdgeInsets.all(20),
              child: const Text("Cancel"),
              onPressed: () {
                Navigator.pop(context);
              },
            )
          ],
        );
      },
    );
  }

  void postImage() async {
    if (_file == null || user == null) return;
    setState(() => isLoading = true);
    try {
      String res = await ref.read(postControllerProvider).uploadPost(
            ref,
            _descriptionController.text,
            _file!,
            user!.uid,
            user!.username,
            user!.profilePic,
          );
      if (res == "success") {
        setState(() {
          isLoading = false;
          _file = null;
          _descriptionController.clear();
        });
        if (context.mounted) showSnackBar(context: context, content: 'Posted!');
      } else {
        if (context.mounted) showSnackBar(context: context, content: res);
      }
    } catch (err) {
      setState(() => isLoading = false);
      showSnackBar(context: context, content: err.toString());
    }
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text('Create Post', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.upload, color: Colors.amber),
            onPressed: postImage,
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            if (isLoading) LinearProgressIndicator(color: Colors.amber),
            if (_file != null)
              Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.file(_file!,
                        fit: BoxFit.cover,
                        height: MediaQuery.of(context).size.height * 0.45,
                        width: double.infinity),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _descriptionController,
                    decoration: InputDecoration(
                      hintText: "Write a caption...",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12)),
                      filled: true,
                      fillColor: Colors.grey.shade200,
                    ),
                    maxLines: 3,
                  ),
                ],
              ),
            const SizedBox(height: 8),
            ElevatedButton.icon(
              onPressed: () => _selectImage(context),
              icon: Icon(Icons.add_photo_alternate, color: Colors.white),
              label: Text("Select Image or Video",
                  style: TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.amber,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
