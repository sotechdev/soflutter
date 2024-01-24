library soflutter;

import 'package:soflutter/src/core/constants.dart';

export 'src/core/builder.dart';
export 'src/core/controller.dart';
export 'src/core/page.dart';
export 'src/core/state.dart';

export 'src/di/injector.dart';

export 'src/exceptions/soflutter_exception.dart';
export 'src/exceptions/service_error.dart';

export 'src/validators/validator.dart';
export 'src/validators/email_validator.dart';
export 'src/validators/required_validator.dart';

export 'src/views/busy_indicator.dart';
export 'src/views/error_view.dart';
export 'src/views/list.dart';
export 'src/views/text_input.dart';

class SOFlutter {
  static setServiceProvider(
    TService Function<TService extends Object>()? serviceProvider,
  ) {
    LibraryConstants.setServiceProvider(serviceProvider);
  }
}
