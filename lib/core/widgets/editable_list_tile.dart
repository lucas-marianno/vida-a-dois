import 'package:flutter/material.dart';

class EditableListTile extends StatefulWidget {
  final String text;
  final String? floatingLabel;
  final void Function(String value)? onSubmitted;
  final int? maxLength;

  const EditableListTile(
    this.text, {
    this.floatingLabel,
    this.onSubmitted,
    this.maxLength,
    super.key,
  });

  @override
  State<EditableListTile> createState() => _EditableListTileState();
}

class _EditableListTileState extends State<EditableListTile> {
  bool editMode = false;

  void toggleEditMode() => setState(() => editMode = !editMode);

  @override
  Widget build(BuildContext context) {
    if (editMode) {
      final controller = TextEditingController();
      controller.text = widget.text;
      return ListTile(
        title: TextField(
          controller: controller,
          autofocus: true,
          onSubmitted: widget.onSubmitted,
          onTapOutside: (_) => toggleEditMode(),
          maxLength: widget.maxLength,
          decoration: InputDecoration(
            labelText: widget.floatingLabel,
            border: const OutlineInputBorder(),
            prefixIcon: IconButton(
              onPressed: () => toggleEditMode(),
              icon: const Icon(Icons.close),
            ),
            suffixIcon: IconButton(
              onPressed: () {
                toggleEditMode();
                widget.onSubmitted?.call(controller.text);
              },
              icon: const Icon(Icons.check),
            ),
          ),
        ),
      );
    }
    return ListTile(
      title: Text(widget.text),
      trailing: IconButton(
        onPressed: widget.onSubmitted == null ? null : toggleEditMode,
        icon: const Icon(Icons.edit),
      ),
    );
  }
}
