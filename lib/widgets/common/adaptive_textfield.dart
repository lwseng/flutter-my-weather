// widgets/common/adaptive_text_field.dart

import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AdaptiveTextField extends StatelessWidget {
  final String hintText;
  final String? Function(String?)? validator;
  final TextEditingController? controller;
  final bool autofocus;

  const AdaptiveTextField({
    super.key,
    required this.hintText,
    this.validator,
    this.controller,
    this.autofocus = false,
  });

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;

    if (Platform.isIOS) {
      return CupertinoTextField(
        controller: controller,
        autofocus: autofocus,
        placeholder: hintText,
        padding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 10,
        ),
        decoration: BoxDecoration(
          color: CupertinoColors.systemGrey6,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: primaryColor,
            width: 1.5,
          ),
        ),
      );
    }

    return TextFormField(
      controller: controller,
      autofocus: autofocus,
      validator: validator,
      decoration: InputDecoration(
        hintText: hintText,
        filled: true,
        fillColor: CupertinoColors.systemGrey6,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: primaryColor,
            width: 1.5,
          ),
        ),
      ),
    );
  }
}