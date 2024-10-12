import 'dart:io';
import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../widgets/constant.dart';


class VendorEditProfile extends StatefulWidget {

  Map userValue;
  VendorEditProfile({
    required this.userValue
});
  @override
  _vendorEditProfile createState() => _vendorEditProfile();
}

class _vendorEditProfile extends State<VendorEditProfile> {

  String profileImageUrl = "";
  File? newImage;
  final ImagePicker _picker = ImagePicker();

  // Function to handle image upload
  Future<void> _uploadImage(bool isCoverImage) async {
    final pickedImage = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      setState(() {
        if (isCoverImage) {
          // coverImageUrl = pickedImage.path;
        } else {
          newImage =File( pickedImage.path);

        }
      });
    }
  }
  TextEditingController nameCon = TextEditingController();
  TextEditingController addressCon = TextEditingController();
  TextEditingController phoneCon = TextEditingController();

  bool errorName = false;
  bool errorAddress = false;
  @override
  void initState() {
    if(mounted){
      setState(() {
        profileImageUrl = widget.userValue["image"].toString();
        nameCon.text = widget.userValue["name"].toString();
        addressCon.text = widget.userValue["address"].toString();
        phoneCon.text = widget.userValue["number"].toString();
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        toolbarHeight: 64,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: InkWell(
                  onTap: (){
                    Navigator.pop(context);
                  },
                  child: Icon(Icons.arrow_back_ios,size: 26,color: kPrimaryColor.shade700,)),
            ),
            SizedBox(width: 12,),
            Text('Edit Profile',style: TextStyle(
                color: kPrimaryColor,fontWeight: FontWeight.bold
            ),),
          ],
        ),
        backgroundColor: Colors.white,
        // iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Container(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            Center(
              child: Stack(
                children: [
                  InkWell(
                    onTap: (){
                      _uploadImage(false);
                    },
                    child: CircleAvatar(
                      backgroundImage: getImage(),
                      backgroundColor: Colors.grey.shade300,
                      child: newImage!=null||profileImageUrl.isNotEmpty?null:Icon(Icons.person,
                        size: 80,color: Colors.white,),
                      radius: 64,
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          width: 4,
                          color: Theme.of(context).scaffoldBackgroundColor,
                        ),
                        color: kPrimaryColor,
                      ),
                      child: const Icon(
                        Icons.edit,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),
            TextFormField(
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter Full name';
                }
                return null;
              },
              controller: nameCon,
              decoration: InputDecoration(
                label: const Text('Full Name'),
                hintText: 'Enter Full Name',
                errorText: errorName?"this field is required":null,

                hintStyle: const TextStyle(
                  color: Colors.black26,
                ),
                border: OutlineInputBorder(
                  borderSide: const BorderSide(
                    color: Colors.black12, // Default border color
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(
                    color: Colors.black12, // Default border color
                  ),

                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onChanged: (v){
                if(v.isNotEmpty){
                  setState(() {
                    errorName = false;
                  });
                }
              },
            ),
            const SizedBox(
              height: 25.0,
            ),

            TextFormField(
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter Address';
                }
                return null;
              },
              onChanged: (v){
                if(v.isNotEmpty){
                  setState(() {
                    errorAddress = false;
                  });
                }
              },
              controller: addressCon,
              decoration: InputDecoration(
                label: const Text('Address'),
                hintText: 'Enter Address',
                hintStyle: const TextStyle(
                  color: Colors.black26,
                ),
                errorText: errorAddress?"this field is required":null,
                border: OutlineInputBorder(
                  borderSide: const BorderSide(
                    color: Colors.black12, // Default border color
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(
                    color: Colors.black12, // Default border color
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(
              height: 25.0,
            ),

            TextFormField(
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter Phone Number';
                }
                return null;
              },
              keyboardType: TextInputType.phone,
              controller: phoneCon,
              decoration: InputDecoration(
                label: const Text('Phone Number'),
                hintText: 'Enter Phone Number',
                hintStyle: const TextStyle(
                  color: Colors.black26,
                ),
                border: OutlineInputBorder(
                  borderSide: const BorderSide(
                    color: Colors.black12, // Default border color
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(
                    color: Colors.black12, // Default border color
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(
              height: 25.0,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                var name = nameCon.text.trim().toString();
                var address = addressCon.text.trim().toString();
                var phone = phoneCon.text.trim().toString();
                if(name.isNotEmpty&&address.isNotEmpty){
                  saveData();

                }else{
                  if(name.isEmpty){
                    setState(() {
                      errorName = true;
                    });
                  }
                  if(address.isEmpty){
                    setState(() {
                      errorAddress = true;
                    });
                  }
                }
                // Save profile data
                // You can add your logic here to save the profile data to a database or elsewhere
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: kPrimaryColor.shade700,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                elevation: 2,
              ),
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: const Text(
                  "Save Changes",
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.bold
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),

          ],
        ),
      ),

    );
  }

  Future<void> saveData() async {
    var currentUid = FirebaseAuth.instance.currentUser!.uid.toString();
    if(newImage!=null){
      var firebaseStorageRef = FirebaseStorage.instance
          .ref()
          .child(currentUid)
          .child("profileImage");
      var uploadTask = firebaseStorageRef.putFile(newImage!);
      var taskSnapshot = await uploadTask;
      taskSnapshot.ref.getDownloadURL().then(
              (imageUrl) async {
                FirebaseDatabase.instance.ref("users").child(currentUid).
                update({"name":nameCon.text.trim().toString(),
                  "address":addressCon.text.trim().toString(),
                  "image":imageUrl,
                  "number":phoneCon.text.trim().toString(),}).then((value){
                  Navigator.pop(context);
                });
              });
          }else{
      FirebaseDatabase.instance.ref("users").child(currentUid).
      update({"name":nameCon.text.trim().toString(),
        "address":addressCon.text.trim().toString(),
        "number":phoneCon.text.trim().toString(),}).then((value){
          Navigator.pop(context);
      });
    }
  }

  getImage() {
    return newImage!=null?
    FileImage(newImage!):profileImageUrl.isNotEmpty?
    NetworkImage(profileImageUrl):null;
  }


}
