import 'package:flutter/material.dart';
import 'package:justeatmockup/widgets/main_button.dart';

class SearchBar extends StatelessWidget {
  const SearchBar({
    super.key,
    required this.controller,
    required this.onSearch,
    required this.labelText,
  });

  final TextEditingController controller;
  final VoidCallback onSearch;
  final String? labelText;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                labelText: labelText,
                border: OutlineInputBorder(),
              ),
              onSubmitted: (_) => onSearch(),
            ),
          ),
          const SizedBox(width: 10),
          MainButton(onPressed: onSearch, label: 'Search', 
            buttonColor: Colors.orange.withOpacity(0.8),
            textColor: Colors.white,
            width: 100,
          ),
        ],
      ),
    );
  }
}
