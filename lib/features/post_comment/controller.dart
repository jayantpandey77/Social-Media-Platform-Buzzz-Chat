import 'dart:io';
import 'package:buzzzchat/features/post_comment/repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final postControllerProvider = Provider((ref) {
  final postRepository = ref.watch(postRepositoryProvider);
  return PostController(postMethods: postRepository, ref: ref);
});

class PostController {
  final PostMethods postMethods;
  final Ref ref;
  PostController({
    required this.postMethods,
    required this.ref,
  });

  Future<String> uploadPost(WidgetRef ref, String description, File file,
      String uid, String username, String profImage) async {
    // asking uid here because we dont want to make extra calls to firebase auth when we can just get from our state management
    return postMethods.uploadPost(
        ref, description, file, uid, username, profImage);
  }

  Future<String> likePost(String postId, String uid, List likes) async {
    return postMethods.likePost(postId, uid, likes);
  }

  // Save Post
  Future<String> savePost(String postId, String uid, List saved) async {
    return postMethods.savePost(postId, uid, saved);
  }

  // Post comment
  Future<String> postComment(String postId, String text, String uid,
      String name, String profilePic) async {
    return postMethods.postComment(postId, text, uid, name, profilePic);
  }

  // Delete Post
  Future<String> deletePost(String postId) async {
    return postMethods.deletePost(postId);
  }

  Future<void> followUser(String uid, String followId) async {
    postMethods.followUser(uid, followId);
  }
}
