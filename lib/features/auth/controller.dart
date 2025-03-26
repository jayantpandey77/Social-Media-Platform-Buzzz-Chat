import 'dart:io';

import 'package:buzzzchat/features/auth/repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:buzzzchat/models/user.dart' as model;

final authControllerProvider = Provider((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return Controller(authRepository: authRepository, ref: ref);
});

final userDataAuthProvider = FutureProvider((ref) {
  final authController = ref.watch(authControllerProvider);
  return authController.getUserDetails();
});

class Controller {
  final Repository authRepository;
  final Ref ref;
  Controller({
    required this.authRepository,
    required this.ref,
  });

  Future<model.User?> getUserDetails() async {
    return authRepository.getCurrentUserData();
  }

  Future<model.User?> getDetails(final String uid) async {
    return authRepository.getUserDetails(uid: uid);
  }

  void signInWithPhone(
      BuildContext context, String phoneNumber, WidgetRef ref) {
    authRepository.signInWithPhone(context, phoneNumber, ref);
  }

  void verifyOTP(BuildContext context, String verificationId, String userOTP) {
    authRepository.verifyOTP(
      context: context,
      verificationId: verificationId,
      userOTP: userOTP,
    );
  }

  void loginUserWithMail(
    BuildContext context,
    String email,
    String password,
  ) {
    authRepository.loginUserWithMail(context, email, password);
  }

  void signUpUserWithMail(
    BuildContext context,
    String email,
    String password,
  ) {
    authRepository.signUpUserWithMail(context, email, password);
  }

  void saveUserDataToFirebase(BuildContext context, String name,
      String username, String bio, File? profilePic) {
    authRepository.saveUserDataToFirebase(
      username: username,
      bio: bio,
      name: name,
      profilePic: profilePic,
      ref: ref,
      context: context,
    );
  }

  void update(BuildContext context, String name, String username, String bio,
      File? profilePic) {
    authRepository.updateData(
      username: username,
      bio: bio,
      name: name,
      profilePic: profilePic,
      ref: ref,
      context: context,
    );
  }

  Stream<model.User> userDataById(String userId) {
    return authRepository.userData(userId);
  }

  void setUserState(bool isOnline) {
    authRepository.setUserState(isOnline);
  }

  void signOut() {
    authRepository.signOut();
  }
}
