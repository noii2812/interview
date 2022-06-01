import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool? readOnly;
  const CustomTextField(
      {Key? key,
      required this.controller,
      required this.hintText,
      this.readOnly = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          validator: (value) {
            if (value!.isEmpty) {
              return "Required";
            }
            return null;
          },
          controller: controller,
          readOnly: readOnly!,
          decoration: InputDecoration(
              labelText: hintText,
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(4))),
          onChanged: (val) {},
        ),
        const SizedBox(
          height: 15,
        )
      ],
    );
  }
}
