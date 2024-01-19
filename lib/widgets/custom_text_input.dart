import 'package:flutter/material.dart';

class CustomTextInput extends StatelessWidget {
  const CustomTextInput({
    super.key,
    this.controller,
    this.labelText,
    this.hintText,
  });
  final TextEditingController? controller;
  final String? labelText;
  final String? hintText;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (labelText != null)
          Padding(
            padding: const EdgeInsets.only(left: 4.0, bottom: 4.0),
            child: Text(
              labelText!,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
        TextFormField(
          controller: controller,
          decoration: InputDecoration(hintText: hintText),          
        ),
      ],
    );
  }
}
