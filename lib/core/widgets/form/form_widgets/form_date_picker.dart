import 'package:flutter/material.dart';
import 'package:kanban/core/util/datetime_util.dart';

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
  late DateTime? dueDate;
  TextEditingController controller = TextEditingController();

  Future<void> pickDate() async {
    final DateTime? response = await showDatePicker(
      context: context,
      initialDate: dueDate,
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );

    if (response != null) updateDueDate(response);
  }

  void updateDueDate(DateTime? newDate, {bool initialCall = false}) {
    dueDate = newDate;
    widget.onChanged(dueDate);
    controller.text = DateTimeUtil.dateTimeToStringBrazilDateOnly(dueDate);

    if (!initialCall) setState(() {});
  }

  @override
  void initState() {
    widget.onChanged(widget.initialDate);

    updateDueDate(widget.initialDate, initialCall: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
