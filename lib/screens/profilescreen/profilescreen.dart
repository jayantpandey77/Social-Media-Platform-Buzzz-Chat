import 'dart:io';
import 'package:buzzzchat/screens/followpage/followscreen.dart';
import 'package:buzzzchat/screens/profilescreen/savescreen.dart';
import 'package:buzzzchat/screens/profilescreen/widget/followbottom.dart';
import 'package:buzzzchat/screens/profilescreen/widget/fullscreen.dart';
import 'package:buzzzchat/screens/profilescreen/widget/post_foll.dart';
import 'package:buzzzchat/screens/profilescreen/widget/showpost.dart';
import 'package:buzzzchat/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  final String uid;
  const ProfileScreen({super.key, required this.uid});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  bool isScrolled = false;
  File? image;
  Map<String, dynamic> userData = {};
  int postLen = 0;
  List<dynamic> followersList = [];
  List<dynamic> followingList = [];
  List<dynamic> savedPosts = [];
  bool isFollowing = false;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    getData();
  }

  Future<void> getData() async {
    setState(() => isLoading = true);

    try {
      var userSnap = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.uid)
          .get();

      var postSnap = await FirebaseFirestore.instance
          .collection('posts')
          .where('uid', isEqualTo: widget.uid)
          .get();

      setState(() {
        userData = userSnap.data() ?? {};
        postLen = postSnap.docs.length;
        followersList = userData['followers'] ?? [];
        followingList = userData['following'] ?? [];
        savedPosts = userData['saved'] ?? [];
        isFollowing =
            followersList.contains(FirebaseAuth.instance.currentUser!.uid);
        isLoading = false;
      });
    } catch (e) {
      showSnackBar(content: e.toString(), context: context);
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return isLoading
        ? const Center(child: CircularProgressIndicator())
        : SafeArea(
            child: Scaffold(
              body: NotificationListener<ScrollNotification>(
                onNotification: (scrollNotification) {
                  if (scrollNotification is ScrollUpdateNotification) {
                    setState(() {
                      isScrolled =
                          scrollNotification.metrics.pixels > height * 0.37;
                    });
                  }
                  return false;
                },
                child: NestedScrollView(
                  headerSliverBuilder: (context, innerBoxIsScrolled) => [
                    SliverAppBar(
                      expandedHeight: height * 0.58,
                      floating: false,
                      pinned: true,
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.white,
                      elevation: 0,
                      actions: [
                        IconButton(
                          onPressed: () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => Savescreen(
                                  Saved: savedPosts, uid: widget.uid),
                            ),
                          ),
                          icon: Icon(Icons.bookmark_border,
                              color: !isScrolled ? Colors.black : Colors.amber,
                              size: 25),
                        ),
                      ],
                      title: Text(
                        userData['username'],
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: width * 0.07,
                          // fontWeight: FontWeight.bold,
                        ),
                      ),
                      flexibleSpace:
                          LayoutBuilder(builder: (context, constraints) {
                        bool isFullyScrolled =
                            constraints.biggest.height == kToolbarHeight;
                        return FlexibleSpaceBar(
                          background: Stack(
                            children: [
                              SizedBox(
                                  height: height * 0.58,
                                  width: double.infinity),
                              Container(
                                height: height * 0.27,
                                decoration: BoxDecoration(
                                  color: isFullyScrolled ? Colors.white : null,
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.amber.shade700,
                                      Colors.amber.shade400
                                    ],
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                  ),
                                  borderRadius: BorderRadius.only(
                                    bottomRight: Radius.circular(height * 0.08),
                                  ),
                                ),
                              ),
                              Positioned(
                                top: height * 0.223,
                                left: width * 0.05,
                                child: GestureDetector(
                                  onTap: () {
                                    if (userData['profilePic'] != null) {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) => FullScreenImage(
                                              imageUrl: userData['profilePic']),
                                        ),
                                      );
                                    }
                                  },
                                  child: Hero(
                                    tag: "profilePic-${widget.uid}",
                                    child: CircleAvatar(
                                      backgroundColor: Colors.orange,
                                      radius: width * 0.184,
                                      child: CircleAvatar(
                                        radius: width * 0.18,
                                        backgroundImage: userData[
                                                    'profilePic'] !=
                                                null
                                            ? NetworkImage(
                                                userData['profilePic'])
                                            : const AssetImage(
                                                    "assets/images/user.png")
                                                as ImageProvider,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                top: height * 0.223,
                                right: width * 0.14,
                                child: Text(
                                  userData['name'] ?? '',
                                  style: TextStyle(
                                      fontSize: width * 0.047,
                                      color: Colors.black),
                                ),
                              ),
                              Positioned(
                                top: height * 0.29,
                                right: width * 0.18,
                                child: Text(
                                  userData['bio'] ?? '',
                                  style: TextStyle(
                                      fontSize: width * 0.041,
                                      color: Colors.black),
                                  textAlign: TextAlign.end,
                                ),
                              ),
                              Positioned(
                                top: height * 0.1,
                                child: Row(
                                  children: [
                                    SizedBox(width: width * 0.14),
                                    Display(
                                        num: postLen,
                                        label: "Posts",
                                        width: width),
                                    SizedBox(width: width * 0.14),
                                    GestureDetector(
                                      onTap: () => Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) => FollowersScreen(
                                            followerUids: followersList,
                                            following: false,
                                          ),
                                        ),
                                      ),
                                      child: Display(
                                          num: followersList.length,
                                          label: "Followers",
                                          width: width),
                                    ),
                                    SizedBox(width: width * 0.14),
                                    GestureDetector(
                                      onTap: () => Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) => FollowersScreen(
                                            followerUids: followingList,
                                            following: true,
                                          ),
                                        ),
                                      ),
                                      child: Display(
                                          num: followingList.length,
                                          label: "Following",
                                          width: width),
                                    ),
                                    SizedBox(width: width * 0.14),
                                    Positioned(
                                      top: height * 0.48,
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: width * 0.1),
                                        child: FollowButton(
                                            follow: isFollowing,
                                            width: width,
                                            uid: widget.uid),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Positioned(
                                  top: height * 0.48,
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: width * 0.1),
                                    child: FollowButton(
                                      follow: isFollowing,
                                      width: width,
                                      uid: widget.uid,
                                    ),
                                  ))
                            ],
                          ),
                        );
                      }),
                    ),
                  ],
                  body: FutureBuilder(
                    future: FirebaseFirestore.instance
                        .collection('posts')
                        .where('uid', isEqualTo: widget.uid)
                        .get(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      return CustomScrollView(
                        slivers: [
                          SliverPadding(
                            padding: EdgeInsets.all(4),
                            sliver: SliverGrid(
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                crossAxisSpacing: 5,
                                mainAxisSpacing: 1.5,
                                childAspectRatio: 1,
                              ),
                              delegate: SliverChildBuilderDelegate(
                                (context, index) {
                                  DocumentSnapshot snap =
                                      (snapshot.data! as dynamic).docs[index];
                                  var postData =
                                      snap.data() as Map<String, dynamic>;

                                  return GestureDetector(
                                    onTap: () =>
                                        showPost(context, widget.uid, postData),
                                    child: Image.network(snap['postUrl'],
                                        fit: BoxFit.cover),
                                  );
                                },
                                childCount:
                                    (snapshot.data! as dynamic).docs.length,
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ),
          );
  }
}
