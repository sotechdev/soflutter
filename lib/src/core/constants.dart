library soflutter;

import 'package:soflutter/src/exceptions/service_error.dart';

class LibraryConstants {
  static TService Function<TService extends Object>()? _serviceProvider;

  static TService Function<TService extends Object>()? get serviceProvider =>
      _serviceProvider;

  static setServiceProvider(
    TService Function<TService extends Object>()? serviceProvider,
  ) {
    _serviceProvider = serviceProvider;
  }

  static TService get<TService extends Object>(
      {TService Function<TService>()? serviceProvider}) {
    if (serviceProvider != null) {
      return serviceProvider<TService>();
    } else if (_serviceProvider != null) {
      return _serviceProvider!<TService>();
    } else {
      throw ServiceError(
          message:
              'Nenhum provedor de serviços encontrado! Tente chamar o método addServiceProvider');
    }
  }
}
