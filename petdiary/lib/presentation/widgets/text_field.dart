import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../themes/app_theme.dart';

// ignore: must_be_immutable
class FieldWidget extends StatelessWidget {
  bool isPassword;

  FieldWidget(
      {super.key,
      required this.regController,
      required this.label,
      required this.keyboardType,
      required this.isPassword,
      this.validator,
      this.errorMessage,
      this.height,
      this.width,
      this.onChanged});

  final TextEditingController regController;
  final String label;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final String? errorMessage;
  final double? height;
  final double? width;
  void Function(String)? onChanged;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: height ?? 290,
      height: width ?? 80,
      child: TextFormField(
        inputFormatters: <TextInputFormatter>[
          FilteringTextInputFormatter.allow(
              RegExp(r'[a-zA-ZğüşöçıĞÜŞÖÇİ\s1-9@.]')),
        ],
        onChanged: onChanged,
        style: AppTheme.lightTheme.textTheme.bodyMedium,
        autovalidateMode: AutovalidateMode.always,
        validator: validator,
        controller: regController,
        keyboardType: keyboardType,
        obscureText: isPassword,
        decoration: InputDecoration(
            errorStyle: const TextStyle(fontSize: 12),
            errorText: errorMessage,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            fillColor: AppTheme.lightTheme.colorScheme.background,
            filled: true,
            labelText: label,
            labelStyle: AppTheme.lightTheme.textTheme.bodySmall),
      ),
    );
  }
}
