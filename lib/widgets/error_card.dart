import 'package:flutter/material.dart';
import 'package:justeatmockup/widgets/main_button.dart';

class ErrorCard extends StatelessWidget {
  const ErrorCard({
    super.key, 
    this.errorMessage,
    required this.onRetry
  });

  final String? errorMessage;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        elevation: 4,
        margin: const EdgeInsets.all(16),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline, color: Colors.red, size: 50),
              const SizedBox(height: 10),
              Text(
                errorMessage ??
                'Oops! Something went wrong, please try again '
                'or contact info@justeat.com.',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              MainButton(
                onPressed: onRetry, 
                label: 'Retry', 
                buttonColor: Colors.orange.withOpacity(0.8),
                textColor: Colors.white,
                width: 100,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
