import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kanban/core/i18n/bloc/locale_bloc.dart';
import 'package:kanban/core/i18n/l10n.dart';
import 'package:kanban/core/widgets/bottom_page_navigator.dart';
import 'package:kanban/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:kanban/features/calendar/presentation/pages/calendar_page.dart';
import 'package:kanban/features/enternainment/presentation/pages/entertainment_page.dart';
import 'package:kanban/features/finance/presentation/pages/finance_page.dart';
import 'package:kanban/features/kanban/presentation/pages/kanban_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final LocaleBloc localeBloc;
  int selectedIndex = 0;

  final List<BottomPageNavigatorItem> pages = [
    BottomPageNavigatorItem(
      title: 'Kanban',
      icon: Icons.task,
      page: const KanbanPage(),
    ),
    BottomPageNavigatorItem(
      title: 'Finances',
      icon: Icons.savings,
      page: const FinancePage(),
    ),
    BottomPageNavigatorItem(
      title: 'Entertainment',
      icon: Icons.travel_explore,
      page: const EntertainmentPage(),
    ),
    BottomPageNavigatorItem(
      title: 'Calendar',
      icon: Icons.calendar_month,
      page: const CalendarPage(),
    ),
  ];

  void pageChanged(index) {
    setState(() => selectedIndex = index);
  }

  @override
  void initState() {
    super.initState();
    localeBloc = context.read<LocaleBloc>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
      appBar: AppBar(
        forceMaterialTransparency: true,
        centerTitle: true,
        title: Text(
          L10n.of(context).appTitle.toUpperCase() + L10n.getflag(context),
          style: const TextStyle(letterSpacing: 4),
        ),
        actions: [
          IconButton(
            onPressed: () {
              //TODO: implement notifications
            },
            icon: const Icon(Icons.notifications),
          ),
          IconButton(
            onPressed: () {
              //TODO: implement profile page
            },
            icon: const Icon(Icons.person),
          ),
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
      body: pages[selectedIndex].page,
      bottomNavigationBar: BottomPageNavigator(
        pages: pages,
        onPageChange: pageChanged,
      ),
    );
  }
}
