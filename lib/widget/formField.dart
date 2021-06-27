import 'package:flutter/material.dart';

class FormBox extends StatelessWidget {
  final TextEditingController controller;
  final int? maxLines;
  final String label;
  final TextInputType? inputType;
  final bool? isValidate;

  const FormBox({Key? key, required this.controller, this.maxLines, required this.label, this.inputType, this.isValidate}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool validate = isValidate != null;
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
          hintText: label,
          labelText: label,
          border: OutlineInputBorder()
      ),
      keyboardType: inputType,
      validator: (val) {
        if(val!.isNotEmpty || !validate) return null;
        else return "Please fill this form.";
      },
    );
  }
}
