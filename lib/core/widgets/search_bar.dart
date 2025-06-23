import 'package:flutter/material.dart';

class NewsSearchBar extends StatelessWidget {
  final String hintText;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onSearch;
  final TextEditingController controller;

  const NewsSearchBar({
    super.key,
    required this.hintText,
    required this.controller,
    this.onChanged,
    this.onSearch,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: hintText,
          prefixIcon: const Icon(Icons.search),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          suffixIcon: IconButton(
            icon: const Icon(Icons.clear),
            onPressed: () {
              controller.clear();
              onChanged?.call('');
            },
          ),
        ),
        onChanged: onChanged,
        onSubmitted: (_) => onSearch?.call(),
      ),
    );
  }
}