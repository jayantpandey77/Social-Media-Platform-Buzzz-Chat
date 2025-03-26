import 'package:buzzzchat/screens/followpage/widget/unfollowbutton.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FollowerTile extends StatelessWidget {
  final String uid;
  final bool following;
  const FollowerTile({Key? key, required this.uid, required this.following})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
      future: FirebaseFirestore.instance.collection('users').doc(uid).get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.grey,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ),
            title: const Text("Loading..."),
          );
        }
        // If the document doesn't exist or an error occurred, display an error message.
        if (!snapshot.hasData || !snapshot.data!.exists) {
          return const ListTile(
            title: Text("User not found"),
          );
        }
        // Retrieve the user data.
        final userData = snapshot.data!.data() as Map<String, dynamic>;
        final username = userData['username'] as String? ?? "No username";
        final photoUrl = userData['photoUrl'] as String? ?? "";

        return ListTile(
            leading: CircleAvatar(backgroundImage: NetworkImage(photoUrl)),
            title: Text(username),
            trailing: following ? FollowingButton(uid: uid) : null);
      },
    );
  }
}
