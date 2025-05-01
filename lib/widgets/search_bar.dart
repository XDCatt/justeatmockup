import 'package:flutter/material.dart';

class SearchBar extends StatelessWidget {
  const SearchBar({
    super.key,
    required this.controller,
    required this.onSearch,
    required this.labelText,
    this.validator,
  });

  final TextEditingController controller;
  final VoidCallback onSearch;
  final String? labelText;
  final String? Function(String?)? validator;

  static final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    // Give the embedded TextFormField its own Form so we don’t have to create
    // one in every screen that uses SearchBar.
    return Form(
      key: _formKey, // Use a unique key to avoid conflicts with other forms
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: TextFormField(
        controller: controller,
        validator: validator,
        keyboardType: TextInputType.text,
        textInputAction: TextInputAction.search,
        style: const TextStyle(fontSize: 16),
        decoration: InputDecoration(
          labelText: labelText,
          border: OutlineInputBorder(),
          contentPadding: const EdgeInsets.symmetric(horizontal: 10),
          suffixIcon: IconButton(
            icon: const Icon(Icons.search),
              onPressed: () {
                // If the validator passes, perform the search.
                if (_formKey.currentState!.validate()) onSearch();
              },
            ),
        ),
      ),
    );
  }
}
