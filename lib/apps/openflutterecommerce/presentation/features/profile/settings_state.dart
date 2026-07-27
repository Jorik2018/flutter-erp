import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_erp/apps/openflutterecommerce/domain/entities/user/settings.dart';

@immutable
abstract class SettingsState extends Equatable {
  final UserSettingsEntity settings;

  SettingsState({required this.settings});

  @override
  List<Object> get props => [settings];
}

@immutable
class SettingsInitialState extends SettingsState {
  SettingsInitialState({required UserSettingsEntity settings})
    : super(settings: settings);
}

@immutable
class FullNameUpdatedState extends SettingsState {
  FullNameUpdatedState({required UserSettingsEntity settings})
    : super(settings: settings);
}

@immutable
class DateOfBirthUpdatedState extends SettingsState {
  DateOfBirthUpdatedState({required UserSettingsEntity settings})
    : super(settings: settings);
}

@immutable
class NotifySalesUpdatedState extends SettingsState {
  NotifySalesUpdatedState({required UserSettingsEntity settings})
    : super(settings: settings);
}

@immutable
class NotifyArrivalsUpdatedSate extends SettingsState {
  NotifyArrivalsUpdatedSate({required UserSettingsEntity settings})
    : super(settings: settings);
}

@immutable
class NotifyDeliveryUpdatedState extends SettingsState {
  NotifyDeliveryUpdatedState({required UserSettingsEntity settings})
    : super(settings: settings);
}

@immutable
class ChangeSettingsErrorState extends SettingsState {
  final String errorMessage;

  ChangeSettingsErrorState({
    required UserSettingsEntity settings,
    required this.errorMessage,
  }) : super(settings: settings);
  @override
  List<Object> get props => [settings, errorMessage];
}
