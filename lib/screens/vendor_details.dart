import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'add_item_page.dart';

class VendorDetailsPage extends StatelessWidget {
  static const String id = 'VendorDetailsPage';
 
  final String vendorId;
  final String vendorName;
 
  VendorDetailsPage({required this.vendorId, required this.vendorName});
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(200.0),
        child: ClipPath(
          clipper: RoundedAppBarClipper(),
          child: Container(
            height: 200,
            color: Colors.blue,
            child: AppBar(
              backgroundColor: Colors.transparent,
              centerTitle: true,
              title: Text(
                'Vendor: $vendorName',
                style: TextStyle(
                  fontFamily: 'Pacifico',
                  fontSize: 40,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder<List<Product>>(
              future: fetchVendorProducts(vendorId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('No products found'));
                }
 
                List<Product> products = snapshot.data!;
                return ListView.builder(
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    final product = products[index];
                    return ListTile(
                      title: Text(product.name),
                      subtitle: Text('\$${product.price.toStringAsFixed(2)}'),
                      leading: Image.network(product.photoUrl),
                      onTap: () {
                        // Navigate to product details or other action
                      },
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddItemPage(vendorId: vendorId),
                  ),
                );
              },
              child: Text(
                'Add Item',
                style: TextStyle(color: Colors.blue),
              ),
            ),
          ),
        ],
      ),
    );
  }
 
  Future<List<Product>> fetchVendorProducts(String vendorId) async {
    final response = await http
        .get(Uri.parse('http://127.0.0.1:8000/vendors/$vendorId/products'));
 
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((json) => Product.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load products');
    }
  }
}
 
class Product {
  final String id;
  final String name;
  final double price;
  final String photoUrl;
  final String size;
  final String location;
 
  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.photoUrl,
    required this.size,
    required this.location,
  });
 
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'].toString(),
      name: json['name'],
      price: json['price'].toDouble(),
      photoUrl: json['photo_url'],
      size: json['size'],
      location: json['location'],
    );
  }
}
 
// Custom Clipper for Rounded AppBar Shape
class RoundedAppBarClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height - 50);
    path.quadraticBezierTo(
        size.width / 2, size.height, size.width, size.height - 50);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }
 
  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}