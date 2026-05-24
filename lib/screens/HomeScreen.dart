import 'package:flutter/material.dart';
import 'package:flutter_erp/providers/data-provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(dataProvider);

    return Center(
      child: data.when(
        loading: () => const CircularProgressIndicator(),
        error: (e, _) => Text("Error: $e"),
        data: (items) => ListView(
          children: items.map((e) => ListTile(title: Text(e))).toList(),
        ),
      ),
    );
  }
}

class Screen1 extends ConsumerWidget {
  const Screen1({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(dataProvider);

    return Center(
      child: data.when(
        loading: () => const CircularProgressIndicator(),
        data: (items) => Text("Screen1: ${items.length} items"),
        error: (e, _) => Text("Error"),
      ),
    );
  }
}

class Screen2 extends ConsumerWidget {
  const Screen2({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const Center(
      child: Text("Screen 2"),
    );
  }
}