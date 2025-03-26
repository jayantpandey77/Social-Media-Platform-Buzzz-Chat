import 'package:buzzzchat/features/chats/screen/chatscreen.dart';
import 'package:buzzzchat/features/chats/widget/contacts_list.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeMessageScreen extends ConsumerStatefulWidget {
  const HomeMessageScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<HomeMessageScreen> createState() => _HomeMessageScreenState();
}

class _HomeMessageScreenState extends ConsumerState<HomeMessageScreen> {
  String searchText = "";
  bool isShowUsers = false;
  final TextEditingController searchController = TextEditingController();

  Future<QuerySnapshot<Map<String, dynamic>>> getUsers() async {
    if (searchText.isEmpty) {
      return FirebaseFirestore.instance.collection('users').limit(10).get();
    }
    return FirebaseFirestore.instance
        .collection('users')
        .orderBy('username')
        .where('username',
            isLessThanOrEqualTo:
                searchText + '\uf8ff') // To ensure the search is accurate
        .get();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        body: Container(
          color: Colors.white,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 14),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      icon: const Icon(
                        Icons.arrow_back,
                        color: Colors.black,
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(width * 0.075),
                        color: const Color.fromARGB(188, 241, 235, 211),
                      ),
                      height: 55,
                      width: width * 0.85,
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: TextField(
                        controller: searchController,
                        onChanged: (value) {
                          setState(() {
                            searchText = value;
                            isShowUsers = value.isNotEmpty;
                          });
                        },
                        decoration: InputDecoration(
                          hintText: "Search your Friend",
                          hintStyle: TextStyle(
                            fontSize: width * 0.05,
                            fontWeight: FontWeight.w400,
                            color: Colors.black,
                          ),
                          prefixIcon: Padding(
                            padding: const EdgeInsets.only(left: 12, right: 8),
                            child: Icon(
                              Icons.search,
                              size: width * 0.075,
                              color: const Color.fromARGB(255, 255, 143, 7),
                            ),
                          ),
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              isShowUsers
                  ? FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
                      future: getUsers(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                          return const Center(child: Text("No users found"));
                        }
                        return Expanded(
                          child: ListView.builder(
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: (context, index) {
                              var user = snapshot.data!.docs[index].data();
                              return InkWell(
                                onTap: () => Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => MobileChatScreen(
                                      name: user['name'],
                                      uid: user['uid'],
                                      isGroupChat: false,
                                      profilePic: user['profilePic'],
                                    ),
                                  ),
                                ),
                                child: ListTile(
                                  leading: CircleAvatar(
                                    backgroundImage:
                                        NetworkImage(user['profilePic']),
                                    radius: 16,
                                  ),
                                  title: Text(user['username']),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    )
                  : const Expanded(child: ContactsList()),
            ],
          ),
        ),
      ),
    );
  }
}
