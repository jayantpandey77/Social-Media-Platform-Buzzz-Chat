import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String email;
  final String username;
  final String name;
  final String uid;
  final String profilePic;
  final String bio;
  final List followers;
  final List following;
  final List saved;
  final bool isOnline;
  final String phoneNumber;
  final List<String> groupId;
  User({
    required this.email,
    required this.username,
    required this.name,
    required this.uid,
    required this.profilePic,
    required this.bio,
    required this.followers,
    required this.following,
    required this.saved,
    required this.isOnline,
    required this.phoneNumber,
    required this.groupId,
  });

  Map<String, dynamic> toMap() {
    return {
      "email": email,
      'name': name,
      'username': username,
      'uid': uid,
      'profilePic': profilePic,
      "bio": bio,
      "followers": followers,
      "following": following,
      "saved": saved,
      'isOnline': isOnline,
      'phoneNumber': phoneNumber,
      'groupId': groupId,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      email: map['email'] ?? '',
      name: map['name'] ?? '',
      username: map['username'] ?? '',
      uid: map['uid'] ?? '',
      profilePic: map['profilePic'] ?? '',
      bio: map['bio'] ?? '',
      followers: map['followers'] ?? [],
      following: map['following'] ?? [],
      saved: map['saved'] ?? [],
      isOnline: map['isOnline'] ?? false,
      phoneNumber: map['phoneNumber'] ?? '',
      groupId: (map['groupId'] as List).cast<String>(),
    );
  }

  static User fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return User(
        groupId: (snapshot["groupId"] as List).cast<String>(),
        isOnline: snapshot["isOnline"],
        phoneNumber: snapshot["phoneNumber"],
        name: snapshot["name"],
        username: snapshot["username"],
        uid: snapshot["uid"],
        email: snapshot["email"],
        profilePic: snapshot["profilePic"],
        bio: snapshot["bio"],
        followers: snapshot["followers"] ?? [],
        following: snapshot["following"] ?? [],
        saved: snapshot["saved"] ?? []);
  }

  Map<String, dynamic> toJson() => {
        "groupId": groupId,
        "isOnline": isOnline,
        "phoneNumber": phoneNumber,
        "name": name,
        "username": username,
        "uid": uid,
        "email": email,
        "profilePic": profilePic,
        "bio": bio,
        "followers": followers,
        "following": following,
        "saved": saved,
      };
}
