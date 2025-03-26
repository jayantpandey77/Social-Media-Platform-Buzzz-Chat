import 'package:buzzzchat/features/post_comment/widget/postcard.dart';
import 'package:flutter/material.dart';

showPost(BuildContext parentContext, String userid, Map<String, dynamic> snap) {
  return showDialog(
    useSafeArea: false,
    context: parentContext,
    builder: (BuildContext context) {
      return Dialog(
        backgroundColor: Colors.transparent,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight:
                MediaQuery.of(context).size.height * 0.8, // Adjustable height
            maxWidth:
                MediaQuery.of(context).size.width * 0.9, // Adjustable width
          ),
          child: PostCard(userid: userid, snap: snap),
        ),
      );
    },
  );
}
