import 'package:flutter/material.dart';

class NumericField extends StatelessWidget {
  final TextEditingController textController;
  final String fieldName;
  final ValueChanged<num> onFieldSubmitted;

  const NumericField({
    required this.textController,
    required this.fieldName,
    required this.onFieldSubmitted,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      decoration: InputDecoration(labelText: fieldName),
      onFieldSubmitted: (String value) => onFieldSubmitted(num.parse(value)),
      initialValue: textController.text,
    );
  }
}
