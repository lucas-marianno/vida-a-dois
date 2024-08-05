import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kanban/core/constants/routes.dart';
import 'package:kanban/core/widgets/app_title.dart';
import 'package:kanban/core/widgets/bottom_page_navigator.dart';
import 'package:kanban/core/widgets/user_initials.dart';
import 'package:kanban/features/calendar/presentation/pages/calendar_page.dart';
import 'package:kanban/features/enternainment/presentation/pages/entertainment_page.dart';
import 'package:kanban/features/finance/presentation/pages/finance_page.dart';
import 'package:kanban/features/kanban/presentation/pages/kanban_page.dart';
import 'package:kanban/features/user_settings/bloc/user_settings_bloc.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final UserSettingsBloc userSettings;
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
    userSettings = context.read<UserSettingsBloc>();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserSettingsBloc, UserSettingsState>(
      builder: (context, state) {
        Widget userIcon = const Icon(Icons.person);
        if (state is UserSettingsLoaded) {
          userIcon = UserInitials(
            userInitials: state.userSettings.initials.toUpperCase(),
          );
        }

        return Scaffold(
          appBar: AppBar(
            title: Padding(
              padding: const EdgeInsets.only(left: 15),
              child: AppTitle(
                fontSize: Theme.of(context).textTheme.displayMedium?.fontSize,
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.notifications),
                onPressed: () {
                  //TODO: implement notifications
                },
              ),
              IconButton(
                icon: userIcon,
                onPressed: () {
                  Navigator.pushNamed(context, Routes.settingsPage);
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
      },
    );
  }
}
