import 'package:flutter/material.dart';
import 'package:snapmart/screens/vendorHome.dart';
import 'package:snapmart/screens/vendorProfile.dart';
import 'package:snapmart/widgets/constant.dart';

import 'chats_screen.dart';

class VendorMain extends StatefulWidget {
  const VendorMain({super.key});

  @override
  State<VendorMain> createState() => _vendorMain();
}

class _vendorMain extends State<VendorMain> {
  int currentTab = 0;
  List<Widget> screens = [
    VendorHome(),
    ChatsScreen(),
    VendorProfile()
    // BrandProfile(name: name, category: category, followers: followers, description: description, coverImage: coverImage, profileImage: profileImage),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        elevation: 0,
        currentIndex: currentTab,
        selectedItemColor: kPrimaryColor,
        unselectedItemColor: Colors.grey.shade500,
        onTap: (index){
          setState(() {
            currentTab = index;
          });
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home),label: 'Home',),
          BottomNavigationBarItem(icon: Icon(Icons.message),label: 'Chats',),
          BottomNavigationBarItem(icon: Icon(Icons.person),label: 'Profile',)
        ],

      ),
      body: screens[currentTab],
    );
  }

}
