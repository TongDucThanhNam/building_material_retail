// variant_input_field.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class VariantInputField extends StatelessWidget {
  final TextEditingController? controller;
  final String labelText;
  final String hintText;

  const VariantInputField({
    Key? key,
    required this.controller,
    required this.labelText,
    required this.hintText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return controller == null
        ? const SizedBox()
        : Expanded(
            child: TextField(
              controller: controller,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
              ],
              decoration: InputDecoration(
                border: InputBorder.none,
                labelText: labelText,
                hintText: hintText,
              ),
            ),
          );
  }
}
