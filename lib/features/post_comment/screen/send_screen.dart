import 'package:buzzzchat/features/chats/controller.dart';
import 'package:buzzzchat/models/chat_contact.dart';
import 'package:buzzzchat/models/message.dart';
import 'package:buzzzchat/models/post.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class SendScreen extends StatefulWidget {
  final Post post;
  final double size;
  final Color col;

  const SendScreen(
      {super.key, required this.size, required this.col, required this.post});

  @override
  _SendScreenState createState() => _SendScreenState();
}

class _SendScreenState extends State<SendScreen> {
  bool isShowUsers = false;
  String searchText = "";
  List<String> sendId = [];

  Future<QuerySnapshot<Map<String, dynamic>>> getUsers() {
    return FirebaseFirestore.instance
        .collection('users')
        .where('username', isGreaterThanOrEqualTo: searchText.toLowerCase())
        .get();
  }

  void sendToUser(WidgetRef ref) {
    for (var id in sendId) {
      ref.read(chatControllerProvider).sendPostMessage(
            context,
            widget.post,
            id,
            MessageEnum.post,
            false,
          );
    }
    Navigator.pop(context);
    setState(() {
      sendId.clear();
    });
  }

  void showSendModal(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Allows custom height
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return FractionallySizedBox(
          heightFactor: 0.4, // Opens at 40% of screen height
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Drag Handle
                Container(
                  width: 50,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.grey[400],
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                const SizedBox(height: 10),

                // Search Bar
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: const Color.fromARGB(188, 241, 235, 211),
                  ),
                  height: 50,
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: "Search your Friend",
                      prefixIcon: Icon(Icons.search, color: Colors.amber),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(vertical: 15),
                    ),
                    onChanged: (string_) {
                      setState(() {
                        isShowUsers = true;
                        searchText = string_;
                      });
                    },
                  ),
                ),
                const SizedBox(height: 10),

                // User List
                Expanded(
                  child: isShowUsers
                      ? FutureBuilder(
                          future: getUsers(),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                            var users = (snapshot.data! as dynamic).docs;
                            return GridView.builder(
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                mainAxisSpacing: 8.0,
                                crossAxisSpacing: 8.0,
                              ),
                              itemCount: users.length,
                              itemBuilder: (context, index) {
                                bool selected =
                                    sendId.contains(users[index]['uid']);

                                return GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      if (selected) {
                                        sendId.remove(users[index]['uid']);
                                      } else {
                                        sendId.add(users[index]['uid']);
                                      }
                                    });
                                  },
                                  child: Column(
                                    children: [
                                      CircleAvatar(
                                        radius: 30,
                                        backgroundImage: NetworkImage(
                                            users[index]['profilePic']),
                                      ),
                                      const SizedBox(height: 5),
                                      Text(users[index]['username']),
                                      if (selected)
                                        const Icon(Icons.check,
                                            color: Colors.blue),
                                    ],
                                  ),
                                );
                              },
                            );
                          },
                        )
                      : StreamBuilder<List<ChatContact>>(
                          stream:
                              ref.watch(chatControllerProvider).chatContacts(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                  child: CircularProgressIndicator());
                            }
                            if (!snapshot.hasData || snapshot.data == null) {
                              return const Center(child: Text("No contacts"));
                            }
                            final chatContacts = snapshot.data!;

                            return GridView.builder(
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                mainAxisSpacing: 8.0,
                                crossAxisSpacing: 8.0,
                              ),
                              itemCount: chatContacts.length,
                              itemBuilder: (context, index) {
                                var chatContactData = chatContacts[index];
                                bool selected =
                                    sendId.contains(chatContactData.contactId);

                                return GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      if (selected) {
                                        sendId
                                            .remove(chatContactData.contactId);
                                      } else {
                                        sendId.add(chatContactData.contactId);
                                      }
                                    });
                                  },
                                  child: Column(
                                    children: [
                                      CircleAvatar(
                                        radius: 30,
                                        backgroundImage: NetworkImage(
                                            chatContactData.profilePic),
                                      ),
                                      const SizedBox(height: 5),
                                      Text(chatContactData.name),
                                      if (selected)
                                        const Icon(Icons.check,
                                            color: Colors.blue),
                                    ],
                                  ),
                                );
                              },
                            );
                          },
                        ),
                ),

                // Send Button
                if (sendId.isNotEmpty)
                  ElevatedButton(
                    onPressed: () => sendToUser(ref),
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 40),
                    ),
                    child: const Text("Send"),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        return IconButton(
          onPressed: () => showSendModal(context, ref),
          icon: Icon(Icons.send, size: widget.size, color: widget.col),
        );
      },
    );
  }
}
