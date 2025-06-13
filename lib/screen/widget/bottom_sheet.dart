import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../pages/home_page.dart';
import '../pages/Tag_screen.dart';

class BottomSheetBar extends StatefulWidget {
  const BottomSheetBar({super.key});

  @override
  State<BottomSheetBar> createState() => _BottomSheetBarState();
}

class _BottomSheetBarState extends State<BottomSheetBar> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    Home(),
    TagScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (int index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items:  [
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.tag),
            label: 'By Tag',
          ),
        ],
      ),
    );
  }
}