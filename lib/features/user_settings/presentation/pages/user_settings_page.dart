import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kanban/core/extentions/icon_extension.dart';
import 'package:kanban/core/extentions/theme_mode_extension.dart';
import 'package:kanban/core/i18n/l10n.dart';
import 'package:kanban/core/util/dialogs/info_dialog.dart';
import 'package:kanban/core/widgets/divider_with_label.dart';
import 'package:kanban/core/widgets/editable_list_tile.dart';
import 'package:kanban/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:kanban/features/user_settings/bloc/user_settings_bloc.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final userSettingsBloc = context.read<UserSettingsBloc>();
    final authBloc = context.read<AuthBloc>();
    final l10n = L10n.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.settings)),
      body: BlocBuilder<UserSettingsBloc, UserSettingsState>(
        builder: (context, state) {
          if (state is UserSettingsLoading) {
            return const LinearProgressIndicator();
          }
          if (state is UserSettingsLoaded) {
            return Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                    child: ListView(
                      children: [
                        DividerWithLabel(label: l10n.userSettings),
                        EditableListTile(
                          state.userSettings.userName ?? l10n.username,
                          floatingLabel: l10n.username,
                          onSubmitted: (value) {
                            userSettingsBloc.add(ChangeUserName(value));
                          },
                        ),
                        EditableListTile(
                          state.userSettings.initials.toUpperCase(),
                          floatingLabel: l10n.userInitials,
                          onSubmitted: (value) {
                            userSettingsBloc.add(ChangeUserInitials(value));
                          },
                          maxLength: 2,
                        ),
                        DividerWithLabel(label: l10n.appSettings),
                        ListTile(
                          title: Text(l10n.appLanguage),
                          trailing: PopupMenuButton(
                            icon: Text(
                              l10n.currentLaguageFlag,
                              style: TextStyle(
                                fontSize: Theme.of(context)
                                    .textTheme
                                    .bodyLarge
                                    ?.fontSize,
                              ),
                            ),
                            itemBuilder: (context) {
                              return [
                                PopupMenuItem(
                                  child: const Text('🇧🇷   Português'),
                                  onTap: () => userSettingsBloc.add(
                                    const ChangeLocale(Locale('pt')),
                                  ),
                                ),
                                PopupMenuItem(
                                  child: const Text('🇺🇸   English'),
                                  onTap: () => userSettingsBloc.add(
                                    const ChangeLocale(Locale('en')),
                                  ),
                                ),
                              ];
                            },
                          ),
                        ),
                        ListTile(
                          title: Text(l10n.appTheme),
                          trailing: PopupMenuButton(
                            icon: Icon(state.userSettings.themeMode.icon),
                            itemBuilder: (context) {
                              return [
                                PopupMenuItem(
                                  child: Text('☀️  ${l10n.light}'),
                                  onTap: () => userSettingsBloc.add(
                                    const ChangeThemeMode(ThemeMode.light),
                                  ),
                                ),
                                PopupMenuItem(
                                  child: Text('🌙  ${l10n.dark}'),
                                  onTap: () => userSettingsBloc.add(
                                    const ChangeThemeMode(ThemeMode.dark),
                                  ),
                                ),
                                PopupMenuItem(
                                  child: Text('📱  ${l10n.system}'),
                                  onTap: () => userSettingsBloc.add(
                                    const ChangeThemeMode(ThemeMode.system),
                                  ),
                                ),
                              ];
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.logout).flipVertical(),
                    label: Text(
                      l10n.signOut,
                      style: TextStyle(
                        fontSize:
                            Theme.of(context).textTheme.bodyLarge?.fontSize,
                      ),
                    ),
                    onPressed: () async {
                      final response = await InfoDialog.show(
                        context,
                        l10n.areYouSureYouWantToLeave,
                        title: l10n.leaveTheApp,
                        showCancel: true,
                      );

                      if (response != true) return;

                      authBloc.add(SignOut());
                    },
                  ),
                ],
              ),
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}
