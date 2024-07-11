import 'package:flutter/material.dart';

class MyFormField extends StatelessWidget {
  final String label;
  final void Function(String? newString) onChanged;
  final String? initialValue;
  final bool mandatory;
  final bool multilineFormField;
  final double? maxHeight;
  final double? maxWidth;

  const MyFormField({
    required this.label,
    required this.onChanged,
    this.initialValue,
    this.mandatory = false,
    this.multilineFormField = false,
    this.maxHeight,
    this.maxWidth,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    onChanged(initialValue);

    return SizedBox(
      height: maxHeight,
      width: maxWidth,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: TextFormField(
          initialValue: mandatory ? initialValue ?? label : initialValue,
          autovalidateMode: AutovalidateMode.always,
          decoration: InputDecoration(
            labelText: mandatory ? '$label *' : label,
            border: const OutlineInputBorder(),
            floatingLabelBehavior: FloatingLabelBehavior.always,
          ),
          textAlignVertical: TextAlignVertical.top,
          maxLines: multilineFormField ? 6 : 1,
          onChanged: onChanged,
          validator: (value) {
            if (!mandatory) return null;

            if (value == null || value.isEmpty) {
              return "'$label' é obrigatório!";
            }
            return null;
          },
        ),
      ),
    );
  }
}
