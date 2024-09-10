import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vida_a_dois/core/constants/routes.dart';
import 'package:vida_a_dois/core/widgets/app_title.dart';
import 'package:vida_a_dois/core/widgets/bottom_page_navigator.dart';
import 'package:vida_a_dois/core/widgets/user_initials.dart';
import 'package:vida_a_dois/features/calendar/presentation/pages/calendar_page.dart';
import 'package:vida_a_dois/features/enternainment/presentation/pages/entertainment_page.dart';
import 'package:vida_a_dois/features/finance/presentation/pages/finance_page.dart';
import 'package:vida_a_dois/features/kanban/presentation/pages/kanban_page.dart';
import 'package:vida_a_dois/features/user_settings/presentation/bloc/user_settings_bloc.dart';

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
    bool isShittyDevice = MediaQuery.of(context).size.height < 1000;
    return BlocBuilder<UserSettingsBloc, UserSettingsState>(
      builder: (context, state) {
        Widget userIcon = const Icon(Icons.person);
        if (state is UserSettingsLoaded) {
          userIcon = UserInitials(state.userSettings.initials);
        }

        return Scaffold(
          resizeToAvoidBottomInset: !isShittyDevice,
          appBar: AppBar(
            toolbarHeight: isShittyDevice ? 40 : null,
            title: Padding(
              padding: isShittyDevice
                  ? EdgeInsets.zero
                  : const EdgeInsets.only(left: 15),
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
