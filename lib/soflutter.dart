library soflutter;

import 'package:soflutter/exceptions/service_error.dart';

export 'core/builder.dart';
export 'core/controller.dart';
export 'core/page.dart';
export 'core/state.dart';

export 'validators/validator.dart';
export 'validators/email_validator.dart';
export 'validators/required_validator.dart';

export 'views/busy_indicator.dart';
export 'views/error_view.dart';
export 'views/text_input.dart';

class SOFlutter {
  static TService Function<TService>()? _serviceProvider;

  static TService Function<TService>()? get serviceProvider => _serviceProvider;

  static addServiceProvider(
    TService Function<TService>()? serviceProvider,
  ) {
    _serviceProvider = serviceProvider;
  }

  static TService get<TService>(
      {TService Function<TService>()? serviceProvider}) {
    if (serviceProvider != null) {
      return serviceProvider<TService>();
    } else if (_serviceProvider != null) {
      return _serviceProvider!<TService>();
    } else {
      throw ServiceError(
          message: 'No service provider found! Try call addServiceProvider');
    }
  }
}
