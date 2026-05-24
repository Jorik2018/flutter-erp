import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter_erp/apps/flutter_todo/models/priority.dart';
import 'package:flutter_erp/apps/flutter_todo/models/todo.dart';

import 'package:flutter_erp/apps/flutter_todo/states/auth_provider.dart';
import 'package:flutter_erp/apps/flutter_todo/states/todo_provider.dart';

class ShortcutsEnabledTodoFab extends ConsumerStatefulWidget {
  const ShortcutsEnabledTodoFab({super.key});

  @override
  ConsumerState<ShortcutsEnabledTodoFab> createState() =>
      _ShortcutsEnabledTodoFabState();
}

class _ShortcutsEnabledTodoFabState
    extends ConsumerState<ShortcutsEnabledTodoFab>
    with TickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _createTodo(Priority priority) {
    final auth = ref.read(authProvider);
    final todoNotifier = ref.read(todoProvider.notifier);

    final user = auth!.user;
    if (user == null) return;

    todoNotifier.setCurrentTodo(
      Todo(
        title: '',
        userId: user.id,
        priority: priority,
      ),
    );

    Navigator.pushNamed(context, '/editor');
  }

  Widget _buildMiniFab({
    required String heroTag,
    required Color color,
    required Priority priority,
    required double interval,
  }) {
    return SizedBox(
      height: 50,
      child: ScaleTransition(
        scale: CurvedAnimation(
          parent: _controller,
          curve: Interval(0.0, interval, curve: Curves.easeOut),
        ),
        child: FloatingActionButton(
          heroTag: heroTag,
          backgroundColor: color,
          mini: true,
          onPressed: () => _createTodo(priority),
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildMiniFab(
          heroTag: 'low',
          color: Colors.lightGreen,
          priority: Priority.Low,
          interval: 1.0,
        ),
        _buildMiniFab(
          heroTag: 'medium',
          color: Colors.amber,
          priority: Priority.Medium,
          interval: 0.6,
        ),
        _buildMiniFab(
          heroTag: 'high',
          color: Colors.redAccent,
          priority: Priority.High,
          interval: 0.2,
        ),

        FloatingActionButton(
          heroTag: 'main',
          onPressed: () {
            if (_controller.isDismissed) {
              _controller.forward();
            } else {
              _controller.reverse();
            }
          },
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Transform(
                alignment: Alignment.center,
                transform: Matrix4.rotationZ(
                  _controller.value * 0.75 * math.pi,
                ),
                child: const Icon(Icons.add),
              );
            },
          ),
        ),
      ],
    );
  }
}