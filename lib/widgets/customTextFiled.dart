import 'package:flutter/material.dart';

import 'constant.dart';

class CustomTextField extends StatelessWidget {
  final String hint;
  final IconData icon;

  const CustomTextField({
    required this.icon,
    required this.hint,
    required String? Function(dynamic value) validator,
    required Null Function(dynamic value) onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 1),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your data';
              }
            },
            cursorColor: kPrimaryLightColor,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle:
                  TextStyle(color: const Color.fromARGB(255, 168, 168, 168)),
              prefixIcon: Icon(icon),
              filled: true,
              fillColor: kPrimaryLightColor,
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide(color: kPrimaryColor),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide(color: kPrimaryColor),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
