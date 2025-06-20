import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:soflutter/soflutter.dart';

class AppObserver extends BlocObserver with Logging {
  AppObserver._();

  static AppObserver? instance;

  factory AppObserver() => instance ??= AppObserver._();

  @override
  void onChange(BlocBase<dynamic> bloc, Change<dynamic> change) {
    super.onChange(bloc, change);
    logger.verbose('onChange(${bloc.runtimeType}, $change)');
  }

  @override
  void onError(BlocBase<dynamic> bloc, Object error, StackTrace stackTrace) {
    logger.error(
      'onError(${bloc.runtimeType})',
      error: error,
      stackTrace: stackTrace,
    );
    super.onError(bloc, error, stackTrace);
  }
}
