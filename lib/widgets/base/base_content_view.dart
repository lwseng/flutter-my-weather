import 'package:flutter/material.dart';

class BaseContentView extends StatelessWidget {
  final bool _isLoading;
  final String? _errorMessage;
  final Widget _content;
  final VoidCallback? onRetry;

  const BaseContentView({
    required this._isLoading,
    required this._errorMessage,
    required this._content,
    this.onRetry,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: .center,
          children: [
            Text(_errorMessage),
            if (onRetry != null)
            IconButton(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              iconSize: 40,
            ),
          ],
        ),
      );
    }

    return _content;
  }
}
