import 'package:buzzzchat/models/user.dart' as model;
import 'package:buzzzchat/screens/add_post_screen/screen.dart';
import 'package:buzzzchat/screens/homescreen/homescreen.dart';
import 'package:buzzzchat/screens/profilescreen/profilescreen.dart';
import 'package:buzzzchat/screens/reelsscreen/reel_screem.dart';
import 'package:buzzzchat/screens/searchscreen/search_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:line_icons/line_icons.dart';

class EntryPage extends ConsumerStatefulWidget {
  final int index;
  const EntryPage({super.key, required this.index});

  @override
  ConsumerState<EntryPage> createState() {
    return _EntryPageState();
  }
}

class _EntryPageState extends ConsumerState<EntryPage> {
  model.User? user;
  String uid = FirebaseAuth.instance.currentUser!.uid;
  int _selectedIndex = 0;
  final List<Widget> _widgetOptions = [
    Homescreen(),
    Searchscreen(),
    AddPostScreen(),
    Consumer(builder: (context, ref, child) {
      final uid = FirebaseAuth.instance.currentUser!.uid;
      return ReelScreen(uid: uid);
    }),
    Consumer(builder: (context, ref, child) {
      final uid = FirebaseAuth.instance.currentUser!.uid;
      return ProfileScreen(uid: uid);
    }),
  ];

  @override
  void initState() {
    _selectedIndex = widget.index;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: _widgetOptions.elementAt(_selectedIndex)),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              blurRadius: 20,
              color: const Color.fromARGB(44, 0, 0, 0),
            )
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
            child: GNav(
              rippleColor: Colors.grey[300]!,
              hoverColor: Colors.grey[100]!,
              gap: 8,
              activeColor: Colors.black,
              iconSize: 24,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              duration: Duration(milliseconds: 400),
              tabBackgroundColor: Colors.grey[100]!,
              color: Colors.black,
              tabs: [
                GButton(
                  icon: LineIcons.home,
                  text: 'Home',
                ),
                GButton(
                  icon: LineIcons.search,
                  text: 'Search',
                ),
                GButton(
                  icon: LineIcons.plus,
                  text: 'Post',
                ),
                GButton(
                  icon: LineIcons.squarespace,
                  text: 'Reels',
                ),
                GButton(
                  icon: LineIcons.user,
                  text: 'Profile',
                ),
              ],
              selectedIndex: _selectedIndex,
              onTabChange: (index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
            ),
          ),
        ),
      ),
    );
  }
}
