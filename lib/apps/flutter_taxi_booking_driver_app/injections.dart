import 'package:flutter_erp/apps/flutter_taxi_booking_driver_app/repo/api_provider.dart';
import 'package:flutter_erp/apps/flutter_taxi_booking_driver_app/repo/network_info.dart';
import 'package:flutter_erp/apps/flutter_taxi_booking_driver_app/repo/pref_manager.dart';
import 'package:flutter_erp/apps/flutter_taxi_booking_driver_app/repo/repo_provider.dart';
import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

Future<void> initDependencies() async {
  print("initDependencies()");

  final getIt = GetIt.instance;

  await PrefManager.getInstance();

  getIt.registerLazySingleton<RepoProvider>(
    () => RepoProvider(
      apiProvider: APIProviderIml(),
      networkInfo: NetworkInfoImpl(InternetConnectionChecker()),
    ),
  );
}
