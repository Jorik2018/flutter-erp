import 'package:flutter/material.dart';
import 'package:flutter_erp/apps/cryptomarket/NotificationService.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../Util/SharedPreferencesHelper.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  static const int _notificationId = 0;

  static const List<NotificationFrequency> _frequencies =
      NotificationFrequency.values;

  String? _selectedFrequency;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSelectedFrequency();
  }

  Future<void> _loadSelectedFrequency() async {
    final savedFrequency = await SharedPreferencesHelper.getNotification();

    if (!mounted) return;

    setState(() {
      _selectedFrequency = savedFrequency;
      _isLoading = false;
    });
  }

  Future<void> _selectFrequency(NotificationFrequency frequency) async {
    try {
      var flutterLocalNotificationsPlugin = NotificationService.instance.plugin;

      // Evita conservar una programación anterior con el mismo ID.
      await flutterLocalNotificationsPlugin.cancel(id: _notificationId);

      await SharedPreferencesHelper.setNotification(frequency.storageValue);

      await flutterLocalNotificationsPlugin.periodicallyShow(
        id: _notificationId,
        title: 'Price updated',
        body: 'Check out your favorite coin prices',
        repeatInterval: frequency.repeatInterval,
        notificationDetails: _notificationDetails,
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        payload: frequency.storageValue,
      );

      if (!mounted) return;

      setState(() {
        _selectedFrequency = frequency.storageValue;
      });
    } catch (error) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No se pudo programar la notificación: $error')),
      );
    }
  }

  NotificationDetails get _notificationDetails {
    return const NotificationDetails(
      android: AndroidNotificationDetails(
        'price_updates',
        'Price updates',
        channelDescription: 'Notifications about cryptocurrency price updates',
        importance: Importance.defaultImportance,
        priority: Priority.defaultPriority,
      ),
      iOS: DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        centerTitle: true,
        title: const Text('Notification', style: TextStyle(fontSize: 20)),
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.separated(
              itemCount: _frequencies.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final frequency = _frequencies[index];
                final isSelected = _selectedFrequency == frequency.storageValue;

                return ListTile(
                  title: Text(
                    frequency.label,
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 18,
                    ),
                  ),
                  trailing: isSelected
                      ? const Icon(Icons.check, size: 30)
                      : null,
                  onTap: () => _selectFrequency(frequency),
                );
              },
            ),
    );
  }
}

enum NotificationFrequency {
  everyMinute(
    label: 'Every minute',
    storageValue: 'everyMinute',
    repeatInterval: RepeatInterval.everyMinute,
  ),
  hourly(
    label: 'Hourly',
    storageValue: 'Hourly',
    repeatInterval: RepeatInterval.hourly,
  ),
  daily(
    label: 'Daily',
    storageValue: 'Daily',
    repeatInterval: RepeatInterval.daily,
  ),
  weekly(
    label: 'Weekly',
    storageValue: 'Weekly',
    repeatInterval: RepeatInterval.weekly,
  );

  const NotificationFrequency({
    required this.label,
    required this.storageValue,
    required this.repeatInterval,
  });

  final String label;
  final String storageValue;
  final RepeatInterval repeatInterval;
}
