// import 'package:buzzzchat/features/auth/controller.dart';
// import 'package:buzzzchat/features/auth/screen/loginscreen.dart';
// import 'package:buzzzchat/features/auth/screen/userinformationscreen.dart';
// import 'package:buzzzchat/features/chats/screen/chatscreen.dart';
// import 'package:buzzzchat/features/post_comment/controller.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// class FollowButton extends ConsumerStatefulWidget {
//   final String uid;
//   final double width;
//   final bool follow;
//   const FollowButton(
//       {super.key,
//       required this.uid,
//       required this.width,
//       required this.follow});

//   @override
//   ConsumerState<FollowButton> createState() {
//     return _FollowButtonState();
//   }
// }

// class _FollowButtonState extends ConsumerState<FollowButton> {
//   bool follow = false;
//   bool useri = true;

//   @override
//   void initState() {
//     follow = widget.follow;
//     useri = widget.uid == FirebaseAuth.instance.currentUser!.uid;
//     super.initState();
//   }

//   void followfuc() {
//     ref
//         .read(postControllerProvider)
//         .followUser(FirebaseAuth.instance.currentUser!.uid, widget.uid);
//     setState(() {
//       follow = !follow;
//     });
//   }

//   void editprof() {
//     Navigator.of(context).push(MaterialPageRoute(
//       builder: (context) =>
//           UserInformationScreen(uid: widget.uid, update: true),
//     ));
//   }

//   void signout() {
//     ref.read(authControllerProvider).signOut();
//     Navigator.of(context).pushReplacement(MaterialPageRoute(
//       builder: (context) => LoginScreen(),
//     ));
//   }

//   void messge() async {
//     var user = await ref.read(authControllerProvider).getDetails(widget.uid);
//     Navigator.of(context).push(MaterialPageRoute(
//         builder: (context) => MobileChatScreen(
//             name: "none",
//             uid: widget.uid,
//             isGroupChat: false,
//             profilePic: user!.profilePic)));
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//       children: [
//         ElevatedButton(
//           onPressed: () {
//             useri ? editprof() : followfuc();
//           },
//           style: ElevatedButton.styleFrom(
//               side: BorderSide(
//                   color: Color.fromARGB(255, 252, 127, 3), width: 1.5),
//               fixedSize: Size(widget.width * 0.35, widget.width * 0.07),
//               backgroundColor: useri
//                   ? Colors.white
//                   : follow
//                       ? Colors.white
//                       : Color.fromARGB(255, 252, 127, 3)),
//           child: useri
//               ? Text(
//                   "Edit Profile",
//                   style: TextStyle(color: Color.fromARGB(255, 252, 127, 3)),
//                 )
//               : Text(
//                   follow ? "Follow" : "Following",
//                   style: TextStyle(
//                       color: follow
//                           ? Color.fromARGB(255, 252, 127, 3)
//                           : Colors.white),
//                 ),
//         ),
//         SizedBox(width: widget.width * 0.1),
//         ElevatedButton(
//           onPressed: () {
//             useri ? signout() : messge();
//           },
//           style: ElevatedButton.styleFrom(
//               side: BorderSide(
//                   color: Color.fromARGB(255, 252, 127, 3), width: 1.5),
//               fixedSize: Size(widget.width * 0.35, widget.width * 0.07),
//               backgroundColor: Colors.white),
//           child: useri
//               ? Text(
//                   "SignOut",
//                   style: TextStyle(color: Color.fromARGB(255, 252, 127, 3)),
//                 )
//               : Text(
//                   "Message",
//                   style: TextStyle(color: Color.fromARGB(255, 252, 127, 3)),
//                 ),
//         )
//       ],
//     );
//   }
// }
import 'package:buzzzchat/features/auth/controller.dart';
import 'package:buzzzchat/features/auth/screen/loginscreen.dart';
import 'package:buzzzchat/features/auth/screen/userinformationscreen.dart';
import 'package:buzzzchat/features/chats/screen/chatscreen.dart';
import 'package:buzzzchat/features/post_comment/controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FollowButton extends ConsumerStatefulWidget {
  final String uid;
  final double width;
  final bool follow;

  const FollowButton({
    super.key,
    required this.uid,
    required this.width,
    required this.follow,
  });

  @override
  ConsumerState<FollowButton> createState() => _FollowButtonState();
}

class _FollowButtonState extends ConsumerState<FollowButton> {
  late bool follow;
  late bool isCurrentUser;

  @override
  void initState() {
    super.initState();
    follow = widget.follow;
    isCurrentUser = widget.uid == FirebaseAuth.instance.currentUser?.uid;
  }

  void toggleFollow() {
    ref
        .read(postControllerProvider)
        .followUser(FirebaseAuth.instance.currentUser!.uid, widget.uid);
    setState(() {
      follow = !follow;
    });
  }

  void editProfile() {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) =>
          UserInformationScreen(uid: widget.uid, update: true),
    ));
  }

  void signOut() {
    ref.read(authControllerProvider).signOut();
    Navigator.of(context).pushReplacement(MaterialPageRoute(
      builder: (context) => const LoginScreen(),
    ));
  }

  void openChat() async {
    var user = await ref.read(authControllerProvider).getDetails(widget.uid);
    if (user != null) {
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => MobileChatScreen(
          name: user.name, // Pass the actual name
          uid: widget.uid,
          isGroupChat: false,
          profilePic: user.profilePic,
        ),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton(
          onPressed: isCurrentUser ? editProfile : toggleFollow,
          style: ElevatedButton.styleFrom(
            side: const BorderSide(
                color: Color.fromARGB(255, 252, 127, 3), width: 1.5),
            fixedSize: Size(widget.width * 0.35, widget.width * 0.07),
            backgroundColor: isCurrentUser
                ? Colors.white
                : follow
                    ? Color.fromARGB(255, 252, 127, 3)
                    : Colors.white,
          ),
          child: Text(
            isCurrentUser
                ? "Edit Profile"
                : follow
                    ? "Following"
                    : "Follow",
            style: TextStyle(
              color: isCurrentUser || !follow
                  ? Color.fromARGB(255, 252, 127, 3)
                  : Colors.white,
            ),
          ),
        ),
        SizedBox(width: widget.width * 0.1),
        ElevatedButton(
          onPressed: isCurrentUser ? signOut : openChat,
          style: ElevatedButton.styleFrom(
            side: const BorderSide(
                color: Color.fromARGB(255, 252, 127, 3), width: 1.5),
            fixedSize: Size(widget.width * 0.35, widget.width * 0.07),
            backgroundColor: Colors.white,
          ),
          child: Text(
            isCurrentUser ? "Sign Out" : "Message",
            style: const TextStyle(color: Color.fromARGB(255, 252, 127, 3)),
          ),
        ),
      ],
    );
  }
}
