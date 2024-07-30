import 'package:flutter/material.dart';

class NormalTextField extends StatelessWidget {
  const NormalTextField(
      {super.key,
      required this.controller,
      required this.text,
      this.readonly,
      this.iconData,
      this.line});
  final TextEditingController controller;
  final String text;
  final IconData? iconData;
  final int? line;
  final bool? readonly;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16),
      child: TextFormField(
        validator: (value) {
          if (value!.isEmpty) {
            return 'Please enter your $text';
          }
          return null;
        },
        controller: controller,
        readOnly: readonly ?? false,
        maxLines: line ?? 1,
        decoration: InputDecoration(
          fillColor: Colors.brown[300],
          filled: true,
          labelText: text,
          labelStyle: const TextStyle(color: Colors.white, fontSize: 23),
          prefixIcon: Icon(
            iconData,
            color: Colors.white,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}

class SuffixNormalTextField extends StatelessWidget {
  const SuffixNormalTextField(
      {super.key, required this.controller, required this.text, this.iconData});
  final TextEditingController controller;
  final String text;
  final IconData? iconData;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16),
      child: TextFormField(
        validator: (value) {
          if (value!.isEmpty) {
            return 'Please enter your $text';
          }
          return null;
        },
        controller: controller,
        decoration: InputDecoration(
          suffixIconConstraints: const BoxConstraints(minWidth: 70),
          fillColor: Colors.brown[300],
          filled: true,
          labelText: text,
          suffixIcon: Icon(iconData),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}
