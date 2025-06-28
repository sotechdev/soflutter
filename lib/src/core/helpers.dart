import 'dart:io' show Platform;

import 'package:flutter/foundation.dart';

const bool isDebug = kDebugMode;
final bool isMobile = Platform.isAndroid || Platform.isIOS;