import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:snapmart/screens/login_screen.dart';
import 'package:snapmart/screens/vendorEditProfile.dart';

import '../widgets/constant.dart';


class UserProfile extends StatefulWidget {
  @override
  _userProfile createState() => _userProfile();
}

class _userProfile extends State<UserProfile> {
  // late Future<BrandProfile> brandProfile;

  Map userValue = {};
  @override
  void initState() {
    super.initState();

    FirebaseDatabase.instance
        .ref("users").child(FirebaseAuth.instance.currentUser!.uid.toString())
        .onValue
        .listen((event) {
      if (event.snapshot.exists) {
        Map o = event.snapshot.value as Map;
        if (mounted) {
          setState(() {
            userValue = o;
          });
        }
      }
    });
  }


  void _logout() {
    if(FirebaseAuth.instance.currentUser!=null){
      FirebaseAuth.instance.signOut().then((value) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
              (Route<dynamic> route) => false,
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var name = userValue["name"].toString();
    var image = userValue["image"].toString();
    var email = FirebaseAuth.instance.currentUser!.email;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("Profile",style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 22,
          color: kPrimaryColor,
        ),),
        elevation: 0,
        toolbarHeight: 64,
        actionsIconTheme: IconThemeData(
          color: kPrimaryColor,
        ),
        backgroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Column(
              children: [
                SizedBox(height: 24,),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: CircleAvatar(
                      radius: 75.0,
                      backgroundColor: Colors.grey.shade300,
                      backgroundImage:
                      NetworkImage(image),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    children: [
                      Text(
                        name,
                        style: TextStyle(
                          fontSize: 30.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8.0),
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.center,
                      //   children: [
                      //     Text(
                      //       "profile.category",
                      //       style: TextStyle(
                      //         fontSize: 14.0,
                      //       ),
                      //     ),
                      //     SizedBox(width: 18.0),
                      //     Text(
                      //       ' Followers',
                      //       style: TextStyle(
                      //         fontSize: 14.0,
                      //       ),
                      //     ),
                      //   ],
                      // ),
                      // SizedBox(height: 8.0),
                      Text(
                        email.toString(),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16
                        ),
                      ),
                      SizedBox(height: 16),
                    ],
                  ),
                ),
                SizedBox(height: 24,),
                InkWell(
                  onTap: (){
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => VendorEditProfile(userValue: userValue,),
                          ),
                        );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color:  kPrimaryColor.withAlpha(30)
                    ),
                    width: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.all(14.0),
                      child: Text(
                        'Edit Profile',textAlign: TextAlign.center,
                        style: TextStyle(color: kPrimaryColor,fontWeight: FontWeight.bold,
                            fontSize: 20),
                      ),
                    ),
                  ),
                ),
                // ElevatedButton(
                //   onPressed: () {
                //     Navigator.push(
                //       context,
                //       MaterialPageRoute(
                //         builder: (context) => CreateBrandProfile(),
                //       ),
                //     );
                //   },
                //   style: ElevatedButton.styleFrom(
                //     minimumSize: const Size(150, 37),
                //     backgroundColor: const Color(0xFF684399),
                //     shape: RoundedRectangleBorder(
                //       borderRadius: BorderRadius.circular(15.0),
                //     ),
                //   ),
                //   child: const Text(
                //     'Edit Profile',
                //     style: TextStyle(color: Colors.white),
                //   ),
                // ),
                // ElevatedButton(
                //   onPressed: () {
                //     // Share.share(
                //     //   'Check out this amazing profile: ${profile.name}\n${profile.category}\n${profile.followers} Followers\n${profile.description}',
                //     // );
                //   },
                //   style: ElevatedButton.styleFrom(
                //     backgroundColor: const Color(0xFF684399),
                //     minimumSize: const Size(150, 37),
                //     shape: RoundedRectangleBorder(
                //       borderRadius: BorderRadius.circular(15.0),
                //     ),
                //   ),
                //   child: const Text(
                //     'Share Profile',
                //     style: TextStyle(color: Colors.white),
                //   ),
                // ),
                // InkWell(
                //   onTap: (){
                //
                //   },
                //   child: Container(
                //     decoration: BoxDecoration(
                //         borderRadius: BorderRadius.circular(10),
                //         color: Colors.red.withAlpha(30)
                //     ),
                //     width: double.infinity,
                //     child: Padding(
                //       padding: const EdgeInsets.all(14.0),
                //       child: Text(
                //         'log out',textAlign: TextAlign.center,
                //         style: TextStyle(color: Colors.red,fontWeight: FontWeight.bold,
                //             fontSize: 20),
                //       ),
                //     ),
                //   ),
                // ),
                SizedBox(height: 12,),
                InkWell(
                  onTap: (){
                    _logout();
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.red.withAlpha(30)
                    ),
                    width: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.all(14.0),
                      child: Text(
                        'log out',textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.red,fontWeight: FontWeight.bold,
                        fontSize: 20),
                      ),
                    ),
                  ),
                ),
                // ElevatedButton(
                //   onPressed: () {
                //     // Share.share(
                //     //   'Check out this amazing profile: ${profile.name}\n${profile.category}\n${profile.followers} Followers\n${profile.description}',
                //     // );
                //   },
                //   style: ElevatedButton.styleFrom(
                //     backgroundColor: Colors.red.withAlpha(30),
                //     minimumSize: const Size(150, 37),
                //     shape: RoundedRectangleBorder(
                //       borderRadius: BorderRadius.circular(10.0),
                //     ),
                //   ),
                //   child: const Text(
                //     'log out',
                //     style: TextStyle(color: Colors.white),
                //   ),
                // ),
              ],
            ),
          ),
          SizedBox(height: 20.0),
        ],
      ),
    );
  }
}
