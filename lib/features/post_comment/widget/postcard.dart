import 'package:buzzzchat/features/auth/controller.dart';
import 'package:buzzzchat/features/post_comment/screen/commentscreen.dart';
import 'package:buzzzchat/features/post_comment/controller.dart';
import 'package:buzzzchat/features/post_comment/screen/send_screen.dart';
import 'package:buzzzchat/features/post_comment/widget/discription_card.dart';
import 'package:buzzzchat/features/post_comment/widget/like_animation.dart';
import 'package:buzzzchat/models/post.dart';
import 'package:buzzzchat/screens/profilescreen/friendscreen.dart';
import 'package:buzzzchat/models/user.dart' as model;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

const primaryColor = Colors.white;
const secondaryColor = Colors.grey;
const amberAccent = Colors.amber;

class PostCard extends ConsumerStatefulWidget {
  final Map<String, dynamic> snap;
  final String userid;
  const PostCard({required this.userid, required this.snap, super.key});

  @override
  ConsumerState<PostCard> createState() => _PostCardState();
}

class _PostCardState extends ConsumerState<PostCard> {
  model.User? user;
  int commentLen = 0;
  bool isLikeAnimating = false;
  bool ini = true;
  VideoPlayerController? _videoController;

  @override
  void initState() {
    super.initState();
    _initializeData();
    if (widget.snap['postUrl'].toString().endsWith(".mp4")) {
      _videoController = VideoPlayerController.network(widget.snap['postUrl'])
        ..initialize().then((_) => setState(() {}));
    }
  }

  Future<void> _initializeData() async {
    user = await ref.read(authControllerProvider).getUserDetails();
    _fetchCommentLen();
    setState(() {
      ini = false;
    });
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
        ? const Center()
        : Card(
            elevation: 8,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: Container(
              width: double.infinity,
              // constraints: const BoxConstraints(maxHeight: 450, minHeight: 400),
              padding: const EdgeInsets.all(12.0),
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
                        const SizedBox(
                          width: 2,
                        ),
                        CircleAvatar(
                          backgroundImage:
                              NetworkImage(widget.snap['profImage'].toString()),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          widget.snap['username'].toString(),
                          style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    height: 250,
                    width: double.infinity,
                    child: widget.snap['postUrl'].toString().endsWith(".mp4")
                        ? (_videoController!.value.isInitialized
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: AspectRatio(
                                  aspectRatio:
                                      _videoController!.value.aspectRatio,
                                  child: VideoPlayer(_videoController!),
                                ),
                              )
                            : const Center(child: CircularProgressIndicator()))
                        : ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(widget.snap['postUrl'],
                                fit: BoxFit.contain,
                                width: double.infinity,
                                height: 250),
                          ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: // LIKE, COMMENT SECTION OF THE POST
                        Row(
                      children: <Widget>[
                        LikeAnimation(
                          isAnimating:
                              widget.snap['likes'].contains(widget.userid),
                          smallLike: true,
                          child: IconButton(
                            icon: widget.snap['likes'].contains(widget.userid)
                                ? const Icon(
                                    Icons.favorite,
                                    color: Colors.red,
                                  )
                                : const Icon(
                                    Icons.favorite_border,
                                    color: Colors.black,
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
                            color: Colors.black,
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
                            col: Colors.black,
                            post: Post(
                                description: widget.snap["description"],
                                uid: widget.snap["uid"],
                                username: widget.snap["username"],
                                likes: widget.snap["likes"],
                                postId: widget.snap["postId"],
                                datePublished: DateTime.now(),
                                postUrl: widget.snap["postUrl"],
                                profImage: widget.snap["profImage"])),
                        const Spacer(),
                        LikeAnimation(
                          isAnimating:
                              user!.saved.contains(widget.snap["postId"]),
                          smallLike: true,
                          child: IconButton(
                            icon: Icon(
                              user!.saved.contains(widget.snap["postId"])
                                  ? Icons.bookmark
                                  : Icons.bookmark_border,
                              size: 22,
                              color: user!.saved.contains(widget.snap["postId"])
                                  ? Colors.amber
                                  : Colors.black,
                            ),
                            onPressed: () {
                              ref.read(postControllerProvider).savePost(
                                  widget.snap["postId"],
                                  user!.uid,
                                  user!.saved);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${widget.snap['likes'].length} likes',
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black87),
                        ),
                        DiscriptionCard(
                            text: widget.snap['description'].toString()),
                        StreamBuilder<int>(
                          stream: _fetchCommentLen(),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) return Container();
                            return InkWell(
                              child: Container(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 4),
                                  child: Text(
                                    'View all ${snapshot.data ?? 0} comments',
                                    style: const TextStyle(
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
                        Text(
                          DateFormat.yMMMd()
                              .format(widget.snap['datePublished'].toDate()),
                          style: const TextStyle(
                              color: Color.fromARGB(178, 0, 0, 0),
                              fontSize: 10),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
  }
}
