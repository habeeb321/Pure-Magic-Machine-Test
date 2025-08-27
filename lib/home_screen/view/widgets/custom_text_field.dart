import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String placeholder;
  final IconData prefixIcon;
  final bool obscureText;
  final TextEditingController? controller;
  final void Function(String)? onChanged;

  const CustomTextField({
    super.key,
    required this.placeholder,
    required this.prefixIcon,
    required this.onChanged,
    this.obscureText = false,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoTextField(
      controller: controller,
      placeholder: placeholder,
      obscureText: obscureText,
      onChanged: onChanged,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      prefix: Padding(
        padding: const EdgeInsets.only(left: 8, right: 8),
        child: Icon(prefixIcon, color: Colors.grey.shade600, size: 20),
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.15),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: Colors.grey.shade300, width: 1),
      ),
      style: const TextStyle(fontSize: 16),
      cursorColor: Colors.blue,
    );
  }
}
