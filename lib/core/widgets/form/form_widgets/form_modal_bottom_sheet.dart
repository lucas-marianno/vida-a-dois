import 'package:flutter/material.dart';

import 'form_title.dart';

class ModalBottomForm<T> {
  final BuildContext context;
  final FormTitle formTitle;
  final List<Widget> body;

  ModalBottomForm({
    required this.context,
    required this.formTitle,
    required this.body,
  });

  Future<T?> show() async {
    return await showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return _ModalBottomForm(formTitle: formTitle, body: body);
      },
    );
  }

  StatelessWidget widget() => _ModalBottomForm(
        formTitle: formTitle,
        body: body,
      );
}

class _ModalBottomForm extends StatelessWidget {
  final FormTitle formTitle;
  final List<Widget> body;
  const _ModalBottomForm({
    required this.formTitle,
    required this.body,
  });

  @override
  Widget build(BuildContext context) {
    double padding = 15;
    return Container(
      height: MediaQuery.of(context).viewInsets.bottom +
          MediaQuery.of(context).size.height * 0.6,
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: padding,
        right: padding,
        top: padding,
      ),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            formTitle,
            const Divider(),
            Expanded(child: ListView(children: body)),
          ]),
    );
  }
}
