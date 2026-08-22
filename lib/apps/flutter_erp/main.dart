import 'package:built_value/built_value.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app.dart';
import 'data/contact_repository_impl.dart';
import 'data/local/app_database.dart';
import 'domain/contact_repository.dart';
import 'utils.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  newBuiltValueToStringHelper = (className) => kReleaseMode
      ? const EmptyBuiltValueToStringHelper()
      : CustomIndentingBuiltValueToStringHelper(className, true);

  final appDatabase = AppDatabase();

  final ContactRepository contactRepository = ContactRepositoryImpl(
    appDatabase.contactDao,
  );

  runApp(
    Provider<ContactRepository>.value(
      value: contactRepository,
      child: const MyApp(),
    ),
  );
}
