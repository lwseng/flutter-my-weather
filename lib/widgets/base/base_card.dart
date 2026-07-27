import 'package:flutter/material.dart';

class BaseCard extends StatelessWidget {
  final String titleText;
  final Widget content;
  const BaseCard({required this.titleText, required this.content, super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: .start,
          spacing: 5,
          children: [
            Text(titleText, style: Theme.of(context).textTheme.titleSmall),
            const Divider(height: 1),
            content,
          ],
        ),
      ),
    );
  }
}
