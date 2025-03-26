import 'package:buzzzchat/features/post_comment/controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FollowingButton extends ConsumerStatefulWidget {
  final String uid;
  const FollowingButton({super.key, required this.uid});

  @override
  ConsumerState<FollowingButton> createState() => _FollowingButtonState();
}

class _FollowingButtonState extends ConsumerState<FollowingButton> {
  bool follow = true;

  void followfuc() {
    ref
        .read(postControllerProvider)
        .followUser(FirebaseAuth.instance.currentUser!.uid, widget.uid);
    setState(() {
      follow = !follow;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: followfuc,
      child: Text(
        follow ? "Following" : "Follow",
        style: TextStyle(
            color: Colors.amber, fontSize: 15, fontWeight: FontWeight.w700),
      ),
    );
  }
}
