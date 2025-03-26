import 'package:buzzzchat/features/post_comment/widget/postcard.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Savescreen extends StatelessWidget {
  final String uid;
  final List Saved;
  const Savescreen({super.key, required this.Saved, required this.uid});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10),
              child: Row(
                children: [
                  IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: Icon(
                        Icons.arrow_back,
                        size: width * 0.07,
                      )),
                  const SizedBox(
                    width: 4,
                  ),
                  Text(
                    "Saved",
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      height: 1,
                      color: Colors.black,
                      fontSize: width * 0.1,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: (Saved.isNotEmpty)
                    ? FirebaseFirestore.instance
                        .collection('posts')
                        .where('postId', whereIn: Saved)
                        .snapshots()
                    : Stream.empty(),
                builder: (context,
                    AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                        snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(
                      child: Text('No saved posts found'),
                    );
                  }
                  return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (ctx, index) {
                      return Container(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 10,
                        ),
                        child: PostCard(
                          userid: uid,
                          snap: snapshot.data!.docs[index].data(),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
