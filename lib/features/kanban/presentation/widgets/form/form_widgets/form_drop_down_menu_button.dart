import 'package:flutter/material.dart';
import 'package:kanban/features/kanban/presentation/widgets/form/form_widgets/form_field.dart';

class FormDropDownMenuButton extends StatefulWidget {
  final String label;
  final bool enabled;
  final List<String> items;
  final void Function(String? newValue) onChanged;
  final String? initialValue;
  final double? maxHeight;
  final double? maxWidth;

  const FormDropDownMenuButton({
    required this.label,
    this.enabled = true,
    required this.items,
    required this.onChanged,
    this.initialValue,
    this.maxHeight,
    this.maxWidth,
    super.key,
  });

  @override
  State<FormDropDownMenuButton> createState() => _FormDropDownMenuButtonState();
}

class _FormDropDownMenuButtonState extends State<FormDropDownMenuButton> {
  late String value;

  void changeValue(String newValue) {
    setState(() {
      value = newValue;
      widget.onChanged(newValue);
    });
  }

  void checkInitialValue() {
    if (widget.initialValue == null) return;

    assert(
      widget.items.contains(widget.initialValue),
      "initialValue: '${widget.initialValue}' "
      "must be an available value in items: '${widget.items}'",
    );
  }

  @override
  void initState() {
    widget.onChanged(widget.initialValue);

    checkInitialValue();
    value = widget.initialValue ?? widget.items.first;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.enabled) {
      return SizedBox(
        height: widget.maxHeight,
        width: widget.maxWidth,
        child: MyFormField(
          label: widget.label,
          initialValue: value,
          enabled: false,
          onChanged: (_) {},
        ),
      );
    }
    return SizedBox(
      height: widget.maxHeight,
      width: widget.maxWidth,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: DropdownButtonFormField<String>(
          value: value,
          decoration: InputDecoration(
            labelText: widget.label,
            border: const OutlineInputBorder(),
            floatingLabelBehavior: FloatingLabelBehavior.always,
          ),
          icon: const Icon(Icons.expand_more),
          alignment: AlignmentDirectional.topStart,
          items: [
            for (String item in widget.items)
              DropdownMenuItem(
                value: item,
                child: Text(item),
              ),
          ],
          onChanged: (item) => changeValue(item!),
        ),
      ),
    );
  }
}