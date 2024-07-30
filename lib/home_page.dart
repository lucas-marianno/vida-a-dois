import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kanban/core/i18n/bloc/locale_bloc.dart';
import 'package:kanban/core/i18n/l10n.dart';
import 'package:kanban/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:kanban/features/kanban/presentation/pages/kanban_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final LocaleBloc localeBloc;

  List pages = [
    Placeholder(),
    KanbanPage(),
    Placeholder(),
    Placeholder(),
  ];

  int selectedIndex = 1;

  @override
  void initState() {
    super.initState();
    localeBloc = context.read<LocaleBloc>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        centerTitle: true,
        title: Text(
          L10n.of(context).appTitle.toUpperCase() + L10n.getflag(context),
          style: const TextStyle(letterSpacing: 4),
        ),
        actions: [
          PopupMenuButton(
            itemBuilder: (context) {
              return [
                PopupMenuItem(
                  child: const Text('pt 🇧🇷'),
                  onTap: () => localeBloc.add(
                    const ChangeLocaleEvent(Locale('pt')),
                  ),
                ),
                PopupMenuItem(
                  child: const Text('en 🇺🇸'),
                  onTap: () => localeBloc.add(
                    const ChangeLocaleEvent(Locale('en')),
                  ),
                ),
                PopupMenuItem(
                  child: const Text('sign out'),
                  onTap: () => context.read<AuthBloc>().add(SignOut()),
                ),
              ];
            },
          ),
        ],
      ),
      body: pages[selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        unselectedItemColor: Theme.of(context).colorScheme.onSurface,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        currentIndex: selectedIndex,
        onTap: (value) => setState(() => selectedIndex = value),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.close),
            label: 'placeholder 1',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.task),
            label: 'kanban',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month),
            label: 'placeholder 2',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.music_note),
            label: 'placeholder 3',
          ),
        ],
      ),
    );
  }
}
