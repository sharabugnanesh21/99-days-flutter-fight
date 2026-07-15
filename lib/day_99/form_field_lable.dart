

import 'package:flutter/material.dart';

class FormFieldLable extends StatelessWidget {
  final String label;
  const FormFieldLable({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return Text(label);
  }
}