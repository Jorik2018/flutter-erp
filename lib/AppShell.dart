import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_erp/states/auth_state.dart';

class AppShell extends ConsumerWidget {
  final Widget child;

  const AppShell({super.key, required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text("Flutter Template")),
      drawer: Drawer(
        child: ListView(
          children: [
            const DrawerHeader(child: Text("MENU")),
            ListTile(
              title: const Text("Home"),
              onTap: () => navigate(context, "/"),
            ),
            ListTile(
              title: const Text("Screen 1"),
              onTap: () => navigate(context, "/screen1"),
            ),
            ListTile(
              title: const Text("Screen 2"),
              onTap: () => navigate(context, "/screen2"),
            ),
            ListTile(
              title: const Text("Verido"),
              onTap: () => navigate(context, "/verido"),
            ),
            ListTile(
              title: const Text("Shop"),
              onTap: () => navigate(context, "/shop"),
            ),
            ListTile(
              title: const Text("GetTaxi"),
              onTap: () => navigate(context, "/gettaxi"),
            ),
            ListTile(
              title: const Text("Taxi Onboarding"),
              onTap: () => navigate(context, "/flutter_taxi_app_onboarding"),
            ),
            ListTile(
              title: const Text("Plantly"),
              onTap: () => navigate(context, "/plantly"),
            ),
            ListTile(
              title: const Text("LMS"),
              onTap: () => navigate(context, "/lms"),
            ),
            ListTile(
              title: const Text("Todo"),
              onTap: () => navigate(context, "/todo"),
            ),
            ListTile(
              title: const Text("SmartHome"),
              onTap: () => navigate(context, "/smart-home-dashboard"),
            ),
            ListTile(
              title: const Text("Car Rental"),
              onTap: () => navigate(context, "/car-rental"),
            ),
            ListTile(
              title: const Text("Covid"),
              onTap: () => navigate(context, "/covid"),
            ),
            ListTile(
              title: const Text("Google Contact"),
              onTap: () => navigate(context, "/google-contact/:currentUserId"),
            ),
            const Divider(),
            ListTile(
              title: const Text("Logout"),
              onTap: () {
                ref.read(authProvider.notifier).logout();
                context.go("/login");
              },
            ),
          ],
        ),
      ),
      body: child,
    );
  }

  void navigate(BuildContext context, String path) {
    Navigator.of(context).pop(); // cierra el drawer
    context.go(path);
  }
}
