import 'dart:io';
import 'package:buzzzchat/entrypage.dart';
import 'package:buzzzchat/features/auth/screen/userinformationscreen.dart';
import 'package:buzzzchat/features/auth/widget/varificationbox.dart';
import 'package:buzzzchat/features/storage.dart';
import 'package:buzzzchat/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:buzzzchat/models/user.dart' as model;

final authRepositoryProvider = Provider(
  (ref) => Repository(
    auth: FirebaseAuth.instance,
    firestore: FirebaseFirestore.instance,
  ),
);

class Repository {
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;
  Repository({
    required this.auth,
    required this.firestore,
  });

  Future<model.User?> getCurrentUserData() async {
    var userData =
        await firestore.collection('users').doc(auth.currentUser?.uid).get();

    model.User? user;
    if (userData.data() != null) {
      user = model.User.fromMap(userData.data()!);
    }
    return user;
  }

  Future<model.User> getUserDetails({required final String uid}) async {
    DocumentSnapshot documentSnapshot =
        await firestore.collection('users').doc(uid).get();

    return model.User.fromSnap(documentSnapshot);
  }

  void signInWithPhone(
      BuildContext context, String phoneNumber, WidgetRef ref) async {
    try {
      await auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          await auth.signInWithCredential(credential);
        },
        verificationFailed: (e) {
          showSnackBar(context: context, content: e.message!);
        },
        codeSent: ((String verificationId, int? resendToken) async {
          Varificationbox(verificationId: verificationId).varify(context, ref);
        }),
        codeAutoRetrievalTimeout: (String verificationId) {},
      );
    } on FirebaseAuthException catch (e) {
      showSnackBar(context: context, content: e.message!);
    }
  }

  void verifyOTP({
    required BuildContext context,
    required String verificationId,
    required String userOTP,
  }) async {
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: userOTP,
      );
      await auth.signInWithCredential(credential);
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => EntryPage(
          index: 0,
        ),
      ));
    } on FirebaseAuthException catch (e) {
      showSnackBar(context: context, content: e.message!);
    }
  }

  void loginUserWithMail(
    BuildContext context,
    String email,
    String password,
  ) async {
    try {
      if (email.isNotEmpty || password.isNotEmpty) {
        await auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => EntryPage(
            index: 0,
          ),
        ));
      } else {
        showSnackBar(context: context, content: "Please enter all the fields");
      }
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }

  void signUpUserWithMail(
    BuildContext context,
    String email,
    String password,
  ) async {
    try {
      if (email.isNotEmpty || password.isNotEmpty) {
        await auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        String uid = auth.currentUser!.uid;
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => UserInformationScreen(
            uid: uid,
            update: false,
          ),
        ));
      } else {
        showSnackBar(context: context, content: "Please enter all the fields");
      }
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }

  void saveUserDataToFirebase({
    required String username,
    required String bio,
    required String name,
    required File? profilePic,
    required Ref ref,
    required BuildContext context,
  }) async {
    try {
      String uid = auth.currentUser!.uid;
      String photoUrl =
          'https://png.pngitem.com/pimgs/s/649-6490124_katie-notopoulos-katienotopoulos-i-write-about-tech-round.png';

      if (profilePic != null) {
        photoUrl = await ref.read(storageMethodsProvider).uploadPost(
              profilePic,
            );
      }

      var user = model.User(
        username: username,
        bio: bio,
        email: auth.currentUser!.email == null ? '' : auth.currentUser!.email!,
        followers: [],
        following: [],
        saved: [],
        name: name,
        uid: uid,
        profilePic: photoUrl,
        isOnline: true,
        phoneNumber: (auth.currentUser!.phoneNumber == null)
            ? ''
            : auth.currentUser!.phoneNumber!,
        groupId: [],
      );

      await firestore.collection('users').doc(uid).set(user.toJson());

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => const EntryPage(
            index: 0,
          ),
        ),
        (route) => false,
      );
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }

  void updateData(
      {required String username,
      required String bio,
      required String name,
      required File? profilePic,
      required Ref ref,
      required BuildContext context}) async {
    try {
      String uid = auth.currentUser!.uid;
      String photoUrl = profilePic != null
          ? await ref.read(storageMethodsProvider).uploadPost(
                profilePic,
              )
          : " ";
      profilePic != null
          ? await firestore.collection('users').doc(uid).update({
              "username": username,
              "bio": bio,
              "profilePic": photoUrl,
              "name": name,
            })
          : await firestore.collection('users').doc(uid).update({
              "username": username,
              "bio": bio,
              "name": name,
            });
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => EntryPage(index: 4),
      ));
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }

  Stream<model.User> userData(String userId) {
    return firestore.collection('users').doc(userId).snapshots().map(
          (event) => model.User.fromSnap(
            event,
          ),
        );
  }

  void setUserState(bool isOnline) async {
    await firestore.collection('users').doc(auth.currentUser!.uid).update({
      'isOnline': isOnline,
    });
  }

  Future<void> signOut() async {
    await auth.signOut();
  }
}
