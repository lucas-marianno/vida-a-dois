import 'package:flutter/material.dart';
import 'package:vida_a_dois/core/widgets/form/form_widgets/form_field.dart';

class FormDropDownMenuButton extends StatefulWidget {
  final String label;
  final bool enabled;
  final List<String> items;
  final void Function(String? newValue) onChanged;
  final String? initialValue;
  final int flex;

  const FormDropDownMenuButton({
    required this.label,
    this.enabled = true,
    required this.items,
    required this.onChanged,
    this.initialValue,
    this.flex = 0,
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
    if (widget.flex >= 1) {
      return Expanded(
        flex: widget.flex,
        child: child(),
      );
    }
    return child();
  }

  Widget child() {
    if (!widget.enabled) {
      return MyFormField(
        label: widget.label,
        initialValue: value,
        enabled: false,
        onChanged: (_) {},
      );
    }
    return DropdownButtonFormField<String>(
      key: Key('${widget.label}DropdownField'),
      isExpanded: true,
      padding: const EdgeInsets.symmetric(vertical: 5),
      value: value,
      decoration: InputDecoration(
        labelText: widget.label,
        border: const OutlineInputBorder(),
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
      alignment: AlignmentDirectional.topStart,
      items: [
        for (String item in widget.items)
          DropdownMenuItem(
            value: item,
            child: Text(
              item,
              overflow: TextOverflow.ellipsis,
            ),
          ),
      ],
      onChanged: (item) => changeValue(item!),
    );
  }
}
