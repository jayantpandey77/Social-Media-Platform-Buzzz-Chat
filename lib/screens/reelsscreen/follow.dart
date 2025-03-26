import 'package:buzzzchat/features/post_comment/controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FollowButtonSet extends ConsumerStatefulWidget {
  final String uid;
  final bool follow;
  final bool useri;
  const FollowButtonSet(
      {super.key,
      required this.uid,
      required this.follow,
      required this.useri});

  @override
  ConsumerState<FollowButtonSet> createState() {
    return _FollowButtonSetState();
  }
}

class _FollowButtonSetState extends ConsumerState<FollowButtonSet> {
  bool follow = false;
  bool useri = true;

  @override
  void initState() {
    follow = widget.follow;
    useri = widget.useri;
    super.initState();
  }

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
    double width = MediaQuery.of(context).size.width;
    return useri
        ? SizedBox()
        : ElevatedButton(
            onPressed: () {
              followfuc();
            },
            style: ElevatedButton.styleFrom(
              elevation: 0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(width * 0.035)),
              backgroundColor: Colors.transparent,
              side: BorderSide(color: Colors.white, width: 2.5),
              fixedSize: Size(width * 0.28, width * 0.03),
            ),
            child: Text(
              follow ? "Following" : "Follow",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w700),
            ),
          );
  }
}
