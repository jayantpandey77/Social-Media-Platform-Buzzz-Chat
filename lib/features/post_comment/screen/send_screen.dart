// import 'package:buzzzchat/features/chats/controller.dart';
// import 'package:buzzzchat/models/chat_contact.dart';
// import 'package:buzzzchat/models/message.dart';
// import 'package:buzzzchat/models/post.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

// class SendScreen extends ConsumerStatefulWidget {
//   final Post post;
//   final double size;
//   final Color col;
//   const SendScreen(
//       {super.key, required this.size, required this.col, required this.post});

//   @override
//   ConsumerState<SendScreen> createState() => _SendScreenState();
// }

// class _SendScreenState extends ConsumerState<SendScreen> {
//   @override
//   Widget build(BuildContext context) {
//     double width = MediaQuery.of(context).size.width;
//     bool isShowUsers = false;
//     String searchText = "";
//     List<String> sendId = [];

//     Future<QuerySnapshot<Map<String, dynamic>>> getUsers() {
//       return FirebaseFirestore.instance
//           .collection('users')
//           .where('username', isGreaterThanOrEqualTo: searchText.toLowerCase())
//           .get();
//     }

//     void sendtouser() {
//       for (var id in sendId) {
//         ref.read(chatControllerProvider).sendPostMessage(
//               context,
//               widget.post,
//               id,
//               MessageEnum.post,
//               false,
//             );
//       }
//     }

//     return IconButton(
//         onPressed: () => showModalBottomSheet(
//               context: context,
//               builder: (context) {
//                 return Column(
//                   children: [
//                     Padding(
//                         padding: const EdgeInsets.symmetric(horizontal: 12.0),
//                         child: Container(
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(width * 0.075),
//                             color: const Color.fromARGB(188, 241, 235, 211),
//                           ),
//                           height: 55,
//                           child: Center(
//                             child: TextField(
//                               decoration: InputDecoration(
//                                 hintText: "Search your Friend",
//                                 hintStyle: TextStyle(
//                                     fontSize: width * 0.05,
//                                     fontWeight: FontWeight.w400,
//                                     color: Colors.black),
//                                 prefixIcon: Padding(
//                                   padding:
//                                       const EdgeInsets.only(left: 12, right: 8),
//                                   child: Icon(
//                                     Icons.search,
//                                     size: width * 0.075,
//                                     color:
//                                         const Color.fromARGB(255, 255, 143, 7),
//                                   ),
//                                 ),
//                                 focusedBorder: OutlineInputBorder(
//                                     borderRadius:
//                                         BorderRadius.circular(width * 0.075)),
//                                 enabledBorder: InputBorder.none,
//                                 errorBorder: InputBorder.none,
//                                 focusedErrorBorder: InputBorder.none,
//                               ),
//                               onChanged: (string_) {
//                                 setState(() {
//                                   isShowUsers = true;
//                                   searchText = string_;
//                                 });
//                               },
//                             ),
//                           ),
//                         )),
//                     isShowUsers
// ? FutureBuilder(
//     future: getUsers(),
//     builder: (context, snapshot) {
//       if (!snapshot.hasData) {
//         return const Center(
//           child: CircularProgressIndicator(),
//         );
//       }
//       return Expanded(
//         child: ListView.builder(
//           itemCount:
//               (snapshot.data! as dynamic).docs.length,
//           itemBuilder: (context, index) {
//             bool selected = false;
//             return InkWell(
//                 onTap: () {
//                   selected
//                       ? sendId.remove(
//                           (snapshot.data! as dynamic)
//                               .docs[index]['uid'])
//                       : sendId.add(
//                           (snapshot.data! as dynamic)
//                               .docs[index]['uid']);
//                   setState(() {
//                     selected = !selected;
//                   });
//                 },
//                 child: Expanded(
//                   child: MasonryGridView.count(
//                     crossAxisCount: 3,
//                     itemCount:
//                         (snapshot.data! as dynamic)
//                             .docs
//                             .length,
//                     itemBuilder: (context, index) =>
//                         Column(
//                       children: [
//                         CircleAvatar(
//                           backgroundImage: NetworkImage(
//                             (snapshot.data! as dynamic)
//                                     .docs[index]
//                                 ['profilePic'],
//                           ),
//                         ),
//                         SizedBox(
//                           height: 3,
//                         ),
//                         Center(
//                           child: Text((snapshot.data!
//                                   as dynamic)
//                               .docs[index]['username']),
//                         )
//                       ],
//                     ),
//                     mainAxisSpacing: 8.0,
//                     crossAxisSpacing: 8.0,
//                   ),
//                 ));
//           },
//         ),
//       );
//     },
//   )
// : StreamBuilder<List<ChatContact>>(
//     stream: ref
//         .watch(chatControllerProvider)
//         .chatContacts(),
//     builder: (context, snapshot) {
//       if (snapshot.connectionState ==
//           ConnectionState.waiting) {
//         return const Center(
//           child: CircularProgressIndicator(),
//         );
//       }

//       return ListView.builder(
//         shrinkWrap: true,
//         itemCount: snapshot.data!.length,
//         itemBuilder: (context, index) {
//           var chatContactData = snapshot.data![index];
//           bool selected = false;
//           return InkWell(
//               onTap: () {
//                 selected
//                     ? sendId.remove(
//                         chatContactData.contactId)
//                     : sendId
//                         .add(chatContactData.contactId);
//                 setState(() {
//                   selected = !selected;
//                 });
//               },
//               child: Expanded(
//                 child: MasonryGridView.count(
//                   crossAxisCount: 3,
//                   itemCount: (snapshot.data! as dynamic)
//                       .docs
//                       .length,
//                   itemBuilder: (context, index) =>
//                       Column(
//                     children: [
//                       CircleAvatar(
//                         backgroundImage: NetworkImage(
//                           chatContactData.profilePic,
//                         ),
//                       ),
//                       SizedBox(
//                         height: 3,
//                       ),
//                       Center(
//                         child: Text((snapshot.data!
//                                 as dynamic)
//                             .docs[index]['username']),
//                       )
//                     ],
//                   ),
//                   mainAxisSpacing: 8.0,
//                   crossAxisSpacing: 8.0,
//                 ),
//               ));
//         },
//       );
//     }),
//                     sendId.isNotEmpty
//                         ? ElevatedButton(
//                             onPressed: sendtouser,
//                             style: ElevatedButton.styleFrom(
//                                 minimumSize: const Size(double.infinity, 32)),
//                             child: Padding(
//                               padding: EdgeInsets.all(width * 0.03),
//                               child: Text("Send",
//                                   style: Theme.of(context)
//                                       .textTheme
//                                       .displayMedium
//                                       ?.copyWith(color: Colors.black)),
//                             ),
//                           )
//                         : Center(child: Text("Select User"))
//                   ],
//                 );
//               },
//             ),
//         icon: Icon(
//           Icons.send,
//           size: widget.size,
//           color: widget.col,
//         ));
//   }
// }

import 'package:buzzzchat/features/chats/controller.dart';
import 'package:buzzzchat/models/chat_contact.dart';
import 'package:buzzzchat/models/message.dart';
import 'package:buzzzchat/models/post.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class SendScreen extends ConsumerWidget {
  final Post post;
  final double size;
  final Color col;

  const SendScreen(
      {super.key, required this.size, required this.col, required this.post});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    bool isShowUsers = false;
    String searchText = "";
    List<String> sendId = [];

    Future<QuerySnapshot<Map<String, dynamic>>> getUsers() {
      return FirebaseFirestore.instance
          .collection('users')
          .where('username', isGreaterThanOrEqualTo: searchText.toLowerCase())
          .get();
    }

    void sendtouser() {
      for (var id in sendId) {
        ref.read(chatControllerProvider).sendPostMessage(
              context,
              post,
              id,
              MessageEnum.post,
              false,
            );
      }
      Navigator.pop(context);
      sendId = [];
    }

    return IconButton(
      onPressed: () => showModalBottomSheet(
        context: context,
        builder: (context) {
          return StatefulBuilder(
            builder: (context, setState) {
              return Padding(
                padding: EdgeInsets.only(left: 15, right: 15, top: 25),
                child: Container(
                  height: height * 0.55,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
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
                                  padding:
                                      const EdgeInsets.only(left: 12, right: 8),
                                  child: Icon(
                                    Icons.search,
                                    size: width * 0.075,
                                    color:
                                        const Color.fromARGB(255, 255, 143, 7),
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.circular(width * 0.075)),
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
                      SizedBox(
                        height: 10,
                      ),
                      SingleChildScrollView(
                        child: isShowUsers
                            ? FutureBuilder(
                                future: getUsers(),
                                builder: (context, snapshot) {
                                  if (!snapshot.hasData) {
                                    return const Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  }
                                  return Expanded(
                                    child: ListView.builder(
                                      itemCount: (snapshot.data! as dynamic)
                                          .docs
                                          .length,
                                      itemBuilder: (context, index) {
                                        bool selected = false;
                                        return InkWell(
                                            onTap: () {
                                              selected
                                                  ? sendId.remove((snapshot
                                                          .data!
                                                      as dynamic)[index]['uid'])
                                                  : sendId.add((snapshot.data!
                                                          as dynamic)[index]
                                                      ['uid']);
                                              setState(() {
                                                selected = !selected;
                                              });
                                            },
                                            child: Expanded(
                                              child: MasonryGridView.count(
                                                crossAxisCount: 3,
                                                itemCount:
                                                    (snapshot.data! as dynamic)
                                                        .docs
                                                        .length,
                                                itemBuilder: (context, index) =>
                                                    Column(
                                                  children: [
                                                    CircleAvatar(
                                                      radius: height * 0.05,
                                                      backgroundImage:
                                                          NetworkImage(
                                                        (snapshot.data!
                                                                    as dynamic)[
                                                                index]
                                                            ['profilePic'],
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 3,
                                                    ),
                                                    Center(
                                                      child: Text((snapshot
                                                                  .data!
                                                              as dynamic)[index]
                                                          ['username']),
                                                    )
                                                  ],
                                                ),
                                                mainAxisSpacing: 8.0,
                                                crossAxisSpacing: 8.0,
                                              ),
                                            ));
                                      },
                                    ),
                                  );
                                },
                              )
                            : Expanded(
                                child: StreamBuilder<List<ChatContact>>(
                                  stream: ref
                                      .watch(chatControllerProvider)
                                      .chatContacts(),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return const Center(
                                          child: CircularProgressIndicator());
                                    }

                                    if (snapshot.hasError) {
                                      return Center(
                                          child:
                                              Text("Error: ${snapshot.error}"));
                                    }

                                    if (!snapshot.hasData ||
                                        snapshot.data == null) {
                                      return const Center(
                                          child: Text("No contacts"));
                                    }
                                    final chatContacts = snapshot.data!;

                                    return ListView.builder(
                                      shrinkWrap: true,
                                      itemCount: chatContacts.length,
                                      itemBuilder: (context, index) {
                                        var chatContactData =
                                            chatContacts[index];
                                        bool selected = sendId.contains(
                                            chatContactData.contactId);

                                        return InkWell(
                                          onTap: () {
                                            setState(() {
                                              if (selected) {
                                                sendId.remove(
                                                    chatContactData.contactId);
                                              } else {
                                                sendId.add(
                                                    chatContactData.contactId);
                                              }
                                            });
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Column(
                                              children: [
                                                CircleAvatar(
                                                  radius: height * 0.05,
                                                  backgroundImage: NetworkImage(
                                                      chatContactData
                                                          .profilePic),
                                                ),
                                                const SizedBox(width: 8),
                                                Text(
                                                  chatContactData.name,
                                                  style: TextStyle(
                                                      fontSize: height * 0.016,
                                                      fontWeight:
                                                          FontWeight.w700),
                                                ),
                                                if (selected)
                                                  const Icon(Icons.check,
                                                      color: Colors.blue),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  },
                                ),
                              ),
                      ),
                      sendId.isNotEmpty
                          ? ElevatedButton(
                              onPressed: sendtouser,
                              style: ElevatedButton.styleFrom(
                                  minimumSize: const Size(double.infinity, 32)),
                              child: const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text("Send"),
                              ),
                            )
                          : const Center(child: Text("Select User")),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      icon: Icon(Icons.send, size: size, color: col),
    );
  }
}
