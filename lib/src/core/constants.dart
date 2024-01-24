library soflutter;

import 'package:soflutter/src/di/injector.dart';
import 'package:soflutter/src/exceptions/service_error.dart';

class LibraryConstants {
  static Injector? injector;

  static TService get<TService extends Object>(
      {TService Function<TService>()? serviceProvider}) {
    if (serviceProvider != null) {
      return serviceProvider<TService>();
    } else if (injector != null) {
      return injector!.get<TService>();
    } else {
      throw ServiceError(
          message:
              'Nenhum provedor de serviços encontrado! Tente chamar o método setInjector');
    }
  }
}
