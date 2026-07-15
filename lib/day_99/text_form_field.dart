

import 'package:basic_app/day_99/form_field_lable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


class OurTextFormField extends StatefulWidget {
  final TextEditingController controller;
  final bool? isObscureText;
  final String label;
  final String? Function(String?)? validator;
  final List<TextInputFormatter>? inputFormatters;
  const OurTextFormField(
    { 
      super.key, 
      required this.controller,
      this.isObscureText = false,
      required this.label,
      this.validator,
      this.inputFormatters,
    }
  );

  @override
  State<OurTextFormField> createState() => _OurTextFormFieldState();
}

class _OurTextFormFieldState extends State<OurTextFormField> {
  bool isVisible = false;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FormFieldLable(label: widget.label),
        TextFormField(
          obscureText: widget.isObscureText ?? false,
          controller: widget.controller,
          validator: widget.validator,
          inputFormatters: widget.inputFormatters,
          decoration: InputDecoration(
            suffixIcon:  IconButton(
              icon: isVisible ? Icon(Icons.visibility_off) : Icon( Icons.visibility), 
              onPressed: () {
                setState(() {
                  isVisible = !isVisible;
                });
              },
            ),
          ),
          onChanged: (value) {
            // print('$value');
          },
        ),
      ],
    );
  }
}