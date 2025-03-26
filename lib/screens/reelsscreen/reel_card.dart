
import 'package:buzzzchat/features/auth/controller.dart';
import 'package:buzzzchat/features/post_comment/controller.dart';
import 'package:buzzzchat/features/post_comment/screen/commentscreen.dart';
import 'package:buzzzchat/features/post_comment/screen/send_screen.dart';
import 'package:buzzzchat/features/post_comment/widget/discription_card.dart';
import 'package:buzzzchat/features/post_comment/widget/like_animation.dart';
import 'package:buzzzchat/models/post.dart';
import 'package:buzzzchat/models/user.dart' as model;
import 'package:buzzzchat/screens/profilescreen/friendscreen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:video_player/video_player.dart';

const primaryColor = Colors.white;
const secondaryColor = Colors.black;
const amberAccent = Colors.amber;

class ReelCard extends ConsumerStatefulWidget {
  final Map<String, dynamic> snap;
  final String userid;

  const ReelCard({required this.userid, required this.snap, super.key});

  @override
  ConsumerState<ReelCard> createState() => _ReelCardState();
}

class _ReelCardState extends ConsumerState<ReelCard> {
  model.User? user;
  bool isLikeAnimating = false;
  bool ini = true;
  VideoPlayerController? _videoController;

  @override
  void initState() {
    super.initState();
    _initializeData();
    _setupVideoPlayer();
  }

  Future<void> _initializeData() async {
    user = await ref.read(authControllerProvider).getUserDetails();
    setState(() {
      ini = false;
    });
  }

  void _setupVideoPlayer() {
    if (widget.snap['postUrl'].toString().endsWith(".mp4")) {
      _videoController = VideoPlayerController.network(widget.snap['postUrl'])
        ..initialize().then((_) {
          if (mounted) setState(() {});
        })
        ..setLooping(true)
        ..play();
    }
  }

  Stream<int> _fetchCommentLen() {
    return FirebaseFirestore.instance
        .collection('posts')
        .doc(widget.snap['postId'])
        .collection('comments')
        .snapshots()
        .map((snapshot) => snapshot.docs.length);
  }

  @override
  void dispose() {
    _videoController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ini
        ? const Center(child: CircularProgressIndicator())
        : Stack(
            children: [
              // Background (Video or Image)
              GestureDetector(
                onTap: () {
                  if (_videoController != null) {
                    if (_videoController!.value.isPlaying) {
                      _videoController!.pause();
                    } else {
                      _videoController!.play();
                    }
                    setState(() {});
                  }
                },
                child: Container(
                  height: double.infinity,
                  width: double.infinity,
                  color: Colors.black,
                  child: widget.snap['postUrl'].toString().endsWith(".mp4")
                      ? _videoController != null &&
                              _videoController!.value.isInitialized
                          ? AspectRatio(
                              aspectRatio: _videoController!.value.aspectRatio,
                              child: VideoPlayer(_videoController!),
                            )
                          : const Center(child: CircularProgressIndicator())
                      : Image.network(widget.snap['postUrl'],
                          fit: BoxFit.cover),
                ),
              ),

              // Like, Comment, Save Buttons (Right Side)
              Positioned(
                right: 16,
                bottom: 40,
                child: Column(
                  children: [
                    LikeAnimation(
                      isAnimating: widget.snap['likes'].contains(widget.userid),
                      smallLike: true,
                      child: IconButton(
                        icon: widget.snap['likes'].contains(widget.userid)
                            ? const Icon(
                                Icons.favorite,
                                color: Colors.red,
                              )
                            : const Icon(
                                Icons.favorite_border,
                                color: Colors.white,
                              ),
                        onPressed: () =>
                            ref.read(postControllerProvider).likePost(
                                  widget.snap['postId'].toString(),
                                  widget.userid,
                                  widget.snap['likes'],
                                ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.comment_outlined,
                        size: 22,
                        color: Colors.white,
                      ),
                      onPressed: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => CommentsScreen(
                            postId: widget.snap['postId'].toString(),
                            user: user!,
                          ),
                        ),
                      ),
                    ),
                    SendScreen(
                        size: 22,
                        col: Colors.white,
                        post: Post(
                            description: widget.snap["description"],
                            uid: widget.snap["uid"],
                            username: widget.snap["username"],
                            likes: widget.snap["likes"],
                            postId: widget.snap["postId"],
                            datePublished: DateTime.now(),
                            postUrl: widget.snap["postUrl"],
                            profImage: widget.snap["profImage"])),
                    LikeAnimation(
                      isAnimating: user!.saved.contains(widget.snap["postId"]),
                      smallLike: true,
                      child: IconButton(
                        icon: Icon(
                          user!.saved.contains(widget.snap["postId"])
                              ? Icons.bookmark
                              : Icons.bookmark_border,
                          size: 22,
                          color: user!.saved.contains(widget.snap["postId"])
                              ? Colors.amber
                              : Colors.white,
                        ),
                        onPressed: () {
                          ref.read(postControllerProvider).savePost(
                              widget.snap["postId"], user!.uid, user!.saved);
                        },
                      ),
                    ),
                  ],
                ),
              ),

              // Profile, Caption, Comment Count (Left Side)
              Positioned(
                left: 16,
                bottom: 10,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) =>
                            FriendScreen(uid: widget.snap['uid'].toString()),
                      )),
                      child: Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.black,
                            radius: 20.5,
                            child: CircleAvatar(
                              radius: 20,
                              backgroundImage: NetworkImage(
                                  widget.snap['profImage'].toString()),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Column(
                            children: [
                              Text(
                                widget.snap['username'].toString(),
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18),
                              ),
                              Text(
                                DateFormat.yMMMd().format(
                                    widget.snap['datePublished'].toDate()),
                                style: const TextStyle(
                                    color: Color.fromARGB(255, 40, 15, 164),
                                    fontSize: 11),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    DiscriptionCard(
                        text: widget.snap['description'].toString()),
                    StreamBuilder<int>(
                      stream: _fetchCommentLen(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) return Container();
                        return InkWell(
                          child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              child: Text(
                                'View all ${snapshot.data ?? 0} comments',
                                style: const TextStyle(
                                    fontSize: 12,
                                    color: Color.fromARGB(182, 0, 0, 0)),
                              )),
                          onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => CommentsScreen(
                                postId: widget.snap['postId'].toString(),
                                user: user!,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          );
  }
}
