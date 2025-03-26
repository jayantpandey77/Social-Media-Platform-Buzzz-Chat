import 'package:buzzzchat/screens/profilescreen/friendscreen.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Searchscreen extends StatefulWidget {
  const Searchscreen({super.key});

  @override
  State<Searchscreen> createState() => _SearchscreenState();
}

class _SearchscreenState extends State<Searchscreen> {
  bool isShowUsers = false;
  String searchText = "";

  // Updated to return typed Future
  Future<QuerySnapshot<Map<String, dynamic>>> getUsers() {
    return FirebaseFirestore.instance
        .collection('users')
        .where('username',
            isLessThanOrEqualTo:
                searchText + '\uf8ff') // To ensure the search is accurate
        .get();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(width * 0.075),
                color: const Color.fromARGB(188, 241, 235, 211),
              ),
              height: 55,
              child: Center(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: "Search your Friend",
                    hintStyle: TextStyle(
                        fontSize: width * 0.05,
                        fontWeight: FontWeight.w400,
                        color: Colors.black),
                    prefixIcon: Padding(
                      padding: const EdgeInsets.only(left: 12, right: 8),
                      child: Icon(
                        Icons.search,
                        size: width * 0.075,
                        color: const Color.fromARGB(255, 255, 143, 7),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(width * 0.075)),
                    enabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    focusedErrorBorder: InputBorder.none,
                  ),
                  onChanged: (string_) {
                    setState(() {
                      isShowUsers = true;
                      searchText = string_;
                    });
                  },
                ),
              ),
            ),
          ),
          // Showing users search or posts based on user input
          isShowUsers
              ? FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
                  future: getUsers(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    if (snapshot.hasError) {
                      return const Center(
                        child: Text("Error loading users"),
                      );
                    }

                    if (snapshot.data == null || snapshot.data!.docs.isEmpty) {
                      return const Center(
                        child: Text("No users found"),
                      );
                    }

                    return Expanded(
                      child: ListView.builder(
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          var userData = snapshot.data!.docs[index].data();
                          return InkWell(
                            child: ListTile(
                              onTap: () =>
                                  Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) =>
                                    FriendScreen(uid: userData['uid']),
                              )),
                              leading: CircleAvatar(
                                backgroundImage:
                                    NetworkImage(userData['profilePic']),
                                radius: 16,
                              ),
                              title: Text(userData['username']),
                            ),
                          );
                        },
                      ),
                    );
                  },
                )
              : FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
                  future: FirebaseFirestore.instance
                      .collection('posts')
                      .orderBy('datePublished')
                      .get(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    if (snapshot.hasError) {
                      return const Center(
                        child: Text("Error loading posts"),
                      );
                    }

                    if (snapshot.data == null || snapshot.data!.docs.isEmpty) {
                      return const Center(
                        child: Text("No posts available"),
                      );
                    }

                    return Expanded(
                      child: MasonryGridView.count(
                        crossAxisCount: 3,
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          var postData = snapshot.data!.docs[index].data();
                          return Image.network(
                            postData['postUrl'],
                            fit: BoxFit.cover,
                          );
                        },
                        mainAxisSpacing: 8.0,
                        crossAxisSpacing: 8.0,
                      ),
                    );
                  },
                ),
        ],
      ),
    );
  }
}
