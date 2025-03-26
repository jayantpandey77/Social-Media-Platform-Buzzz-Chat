import 'package:buzzzchat/features/post_comment/widget/postcard.dart';
import 'package:buzzzchat/screens/messagehome/messagehomesceen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Homescreen extends StatelessWidget {
  const Homescreen({super.key});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    String userid = FirebaseAuth.instance.currentUser!.uid;

    // Function to navigate to messages screen
    void change() {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => HomeMessageScreen()));
    }

    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              children: [
                SizedBox(width: 4),
                Text(
                  "Buzzz",
                  style: GoogleFonts.hurricane(
                    fontWeight: FontWeight.w800,
                    height: 1,
                    color: Colors.black,
                    fontSize: width * 0.17,
                  ),
                ),
                const Spacer(),
                Material(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(width * 0.06),
                  ),
                  child: GestureDetector(
                    child: Icon(
                      Icons.notifications,
                      size: width * 0.08,
                    ),
                  ),
                ),
                SizedBox(width: 9),
                Material(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(width * 0.06),
                  ),
                  child: GestureDetector(
                    onTap: change,
                    child: Icon(
                      Icons.message,
                      size: width * 0.08,
                    ),
                  ),
                ),
                SizedBox(width: 6),
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream:
                  FirebaseFirestore.instance.collection('posts').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                // Check if there are no posts
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(
                    child: Text('No posts available'),
                  );
                }

                return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (ctx, index) {
                    var postData = snapshot.data!.docs[index].data();

                    return Container(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 10,
                      ),
                      child: PostCard(
                        userid: userid,
                        snap: postData,
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
