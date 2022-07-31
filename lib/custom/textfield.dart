import 'package:flutter/material.dart';

class CustomField extends StatefulWidget {
  final TextEditingController controller;
  final String title;
  const CustomField({Key? key, required this.controller, required this.title}) : super(key: key);

  @override
  State<CustomField> createState() => _CustomFieldState();
}

class _CustomFieldState extends State<CustomField> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        controller: widget.controller,
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          labelText: widget.title,
        ),
      ),
    );
  }
}
