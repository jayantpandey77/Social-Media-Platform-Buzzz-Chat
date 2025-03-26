import 'package:buzzzchat/screens/followpage/widget/followercard.dart';
import 'package:flutter/material.dart';

class FollowersScreen extends StatelessWidget {
  final List<dynamic> followerUids;
  final bool following;
  const FollowersScreen(
      {Key? key, required this.followerUids, required this.following})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(following ? 'Following' : 'Followers'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: ListView.builder(
        itemCount: followerUids.length,
        itemBuilder: (context, index) {
          final uid = followerUids[index];
          return FollowerTile(
            uid: uid,
            following: following,
          );
        },
      ),
    );
  }
}
