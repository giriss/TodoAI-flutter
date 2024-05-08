import 'package:flutter/material.dart';

class NaturalLanguagePrompt extends StatelessWidget {
  final void Function(String) onSubmitted;
  final bool disabled;
  final TextEditingController controller;

  const NaturalLanguagePrompt({
    super.key,
    required this.onSubmitted,
    required this.controller,
    this.disabled = false,
  });

  @override
  Widget build(BuildContext context) => TextField(
        controller: controller,
        minLines: 2,
        maxLines: 3,
        textInputAction: TextInputAction.done,
        enabled: !disabled,
        decoration: const InputDecoration(
          filled: true,
          labelText: "What have you done or need to do?",
          border: UnderlineInputBorder(borderRadius: BorderRadius.zero),
        ),
        onSubmitted: onSubmitted,
      );
}
