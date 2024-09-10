import 'package:flutter/material.dart';
import 'package:vida_a_dois/core/extentions/datetime_extension.dart';
import 'package:vida_a_dois/core/i18n/l10n.dart';

class FormDatePicker extends StatefulWidget {
  final String label;
  final bool enabled;
  final DateTime? initialDate;
  final void Function(DateTime? newDate) onChanged;
  final int flex;
  const FormDatePicker({
    super.key,
    required this.label,
    required this.onChanged,
    this.enabled = true,
    this.flex = 0,
    this.initialDate,
  });

  @override
  State<FormDatePicker> createState() => _FormDatePickerState();
}

class _FormDatePickerState extends State<FormDatePicker> {
  late DateTime? deadLine;
  TextEditingController controller = TextEditingController();

  Future<void> pickDate() async {
    final DateTime? response = await showDatePicker(
      context: context,
      initialDate: deadLine,
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );

    if (response != null) updateDeadline(response);
  }

  void updateDeadline(DateTime newDate) async {
    deadLine = newDate;
    widget.onChanged(deadLine);

    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    deadLine = widget.initialDate;
    widget.onChanged(widget.initialDate);
  }

  @override
  Widget build(BuildContext context) {
    controller.text = deadLine?.toShortDate(L10n.of(context)) ?? '';
    return Expanded(
      flex: widget.flex,
      child: TextFormField(
        enabled: widget.enabled,
        style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
        controller: controller,
        decoration: InputDecoration(
          suffixIcon: const Icon(Icons.calendar_today),
          labelText: widget.label,
          border: const OutlineInputBorder(),
          floatingLabelBehavior: FloatingLabelBehavior.always,
        ),
        readOnly: true,
        onTap: pickDate,
      ),
    );
  }
}
