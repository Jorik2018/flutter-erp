import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'app/app.dart';
import 'utils/logger.dart';
import 'utils/utils.dart';

class CustomBlocObserver extends BlocObserver {
  const CustomBlocObserver();

  @override
  void onCreate(BlocBase<dynamic> bloc) {
    super.onCreate(bloc);

    logger.d('Bloc creado: ${bloc.runtimeType}');
  }

  @override
  void onEvent(Bloc<dynamic, dynamic> bloc, Object? event) {
    super.onEvent(bloc, event);

    logger.d('${bloc.runtimeType} - Evento: $event');
  }

  @override
  void onChange(BlocBase<dynamic> bloc, Change<dynamic> change) {
    super.onChange(bloc, change);

    logger.d('${bloc.runtimeType} - Cambio: $change');
  }

  @override
  void onTransition(
    Bloc<dynamic, dynamic> bloc,
    Transition<dynamic, dynamic> transition,
  ) {
    super.onTransition(bloc, transition);

    logger.d('${bloc.runtimeType} - Transición: $transition');
  }

  @override
  void onError(BlocBase<dynamic> bloc, Object error, StackTrace stackTrace) {
    logger.e(
      '${bloc.runtimeType} - Error: $error',
      error: error,
      stackTrace: stackTrace,
    );

    super.onError(bloc, error, stackTrace);
  }

  @override
  void onClose(BlocBase<dynamic> bloc) {
    logger.d('Bloc cerrado: ${bloc.runtimeType}');

    super.onClose(bloc);
  }
}

void _initEssentialServices() {
  if (SystemUtils().isInDebugMode) {
    Bloc.observer = const CustomBlocObserver();
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  _initEssentialServices();

  runApp(const ModalApp());
}
