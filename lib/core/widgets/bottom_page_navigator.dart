import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:vida_a_dois/core/util/color_util.dart';

class BottomPageNavigator extends StatelessWidget {
  final List<BottomPageNavigatorItem> pages;
  final void Function(int) onPageChange;

  const BottomPageNavigator({
    required this.pages,
    required this.onPageChange,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final isShittyDevice = MediaQuery.of(context).size.height < 1000;
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary,
        border: BorderDirectional(
          top: BorderSide(color: Theme.of(context).colorScheme.shadow),
        ),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(15),
          topRight: Radius.circular(15),
        ),
      ),
      child: Padding(
        padding: isShittyDevice
            ? const EdgeInsets.all(5)
            : const EdgeInsets.symmetric(vertical: 10, horizontal: 25),
        child: GNav(
          padding: isShittyDevice
              ? const EdgeInsets.all(2)
              : const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          activeColor: Theme.of(context).colorScheme.secondary,
          tabBackgroundColor: Theme.of(context).colorScheme.onSecondary,
          color: ColorUtil.makeTransparencyFrom(
            Theme.of(context).colorScheme.onSecondary,
          ),
          tabs: [
            for (int i = 0; i < pages.length; i++)
              GButton(
                icon: pages[i].icon,
                text: pages[i].title,
              )
          ],
          onTabChange: onPageChange,
        ),
      ),
    );
  }
}

class BottomPageNavigatorItem {
  final String title;
  final IconData icon;
  final Widget page;

  BottomPageNavigatorItem({
    required this.title,
    required this.icon,
    required this.page,
  });
}
