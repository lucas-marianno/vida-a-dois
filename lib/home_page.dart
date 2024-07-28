import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kanban/core/auth/bloc/auth_bloc.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.clear)),
        title: const Text('placeholder'),
        actions: [
          TextButton.icon(
            onPressed: () => context.read<AuthBloc>().add(SignOut()),
            label: const Text('logout'),
            icon: const Icon(Icons.close),
          )
        ],
      ),
      body: const Placeholder(),
    );
  }
}
