import 'package:flutter/material.dart';
import 'package:flutter_erp/apps/flutter_todo/widgets/helpers/confirm_dialog.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_erp/apps/flutter_todo/states/settings_provider.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);

    final notifier = ref.read(settingsProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        actions: [
          IconButton(
            icon: const Icon(Icons.lock),
            onPressed: () async {
              final confirm = await ConfirmDialog.show(context);

              if (confirm!) {
                Navigator.pop(context);
                // aquí iría authProvider.logout()
              }
            },
          )
        ],
      ),
      body: ListView(
        children: [
          SwitchListTile(
            value: settings.isShortcutsEnabled,
            onChanged: (_) => notifier.toggleShortcuts(),
            title: const Text('Enable shortcuts'),
          ),
          SwitchListTile(
            value: settings.isDarkThemeUsed,
            onChanged: (_) => notifier.toggleDarkTheme(),
            title: const Text('Use dark theme'),
          ),
        ],
      ),
    );
  }
}