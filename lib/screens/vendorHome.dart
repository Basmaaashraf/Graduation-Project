import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import '../widgets/constant.dart';
import 'AddProduct.dart';
import 'editProduct.dart';

class VendorHome extends StatefulWidget {
  //  Map brand;
  //  String brandId;
  // // final String email;
  //  HomeScreen({
  //   required this.brand,
  //   required this.brandId,
  // });
      // required this.phone,
      // required this.email})
      // : super(key: key);

  @override
  State<VendorHome> createState() => _vendorHome();
}

class _vendorHome extends State<VendorHome> {
  int currentTab = 0;
  List<Map> products = [];
  List<Map> searchList = [];

  @override
  void initState() {

    FirebaseDatabase.instance.ref("products").onValue.listen((event) {
      if(event.snapshot.exists){
        Map o = event.snapshot.value as Map;
        products.clear();
        o.forEach((key, value) {
          var from = value["from"].toString();
          if(from == FirebaseAuth.instance.currentUser!.uid.toString())
          if(mounted){
            setState(() {
              products.add(value);
            });
          }
        });
      }else{
       if(mounted){
         setState(() {
           products.clear();
         });
       }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("Snapmart",style: TextStyle(
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
      floatingActionButton: FloatingActionButton(onPressed: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => AddProductScreen(),));
      },
        backgroundColor: kPrimaryColor,
        child: Icon(Icons.add,color: Colors.white,size: 28,),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 12),
              child: Text("All Items",style: TextStyle(
                color: Colors.black54,
                fontWeight: FontWeight.bold,
                fontSize: 20
              ),),
            ),
            Expanded(
              child: products.isEmpty?Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Text("There is no items yet\nadd your first",textAlign: TextAlign.center,style: TextStyle(
                      fontSize: 20,color: Colors.black54
                  ),),
                ),
              ):
              ListView.builder(
                // physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: products.length,
                padding: EdgeInsets.symmetric(horizontal: 8),
                itemBuilder: (context, index) {
                  Map product = products.elementAt(index);
                  var image = product["image"];
                  var name = product["name"];
                  var price = product["price"];
                  var desc = product["desc"];
                  var id = product["id"];
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: InkWell(
                      onTap: (){
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => EditProductScreen(product: product),
                          ),
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.grey.withAlpha(20)
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,

                          children: [
                            ClipRRect(
                              borderRadius:BorderRadius.circular(15),
                              child: Image.network(
                                image,width: 140,
                                height: 120,
                                fit: BoxFit.cover,
                              ),
                            ),
                            SizedBox(width: 12,),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(name,style: TextStyle(
                                        color: Colors.black,fontWeight: FontWeight.bold,fontSize: 20
                                    ),),
                                    SizedBox(height: 8,),
                                    Text(price+" EGP",style: TextStyle(
                                        color: kPrimaryColor,fontWeight: FontWeight.bold,fontSize: 18
                                    ),),
                                    SizedBox(height: 8,),
                                    Text(desc,maxLines: 2,overflow: TextOverflow.ellipsis,style: TextStyle(
                                        color: Colors.black54,overflow: TextOverflow.ellipsis,fontWeight: FontWeight.normal
                                        ,fontSize: 18
                                    ),),
                                  ],
                                ),
                              ),
                            ),


                          ],
                        ),
                      ),
                    ),
                  );
                },),
            ),
          ],
        ),
      ),

    );
  }
}
