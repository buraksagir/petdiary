import 'package:flutter/material.dart';

class MyDivider {
  Widget getDivider() {
    return Padding(
      padding: const EdgeInsets.all(1.0),
      child: Divider(
        color: Colors.brown.shade400,
        thickness: 0.2,
        indent: 12,
        endIndent: 12,
      ),
    );
  }
}
