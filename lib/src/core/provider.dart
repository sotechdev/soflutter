import 'package:auto_injector/auto_injector.dart'
    show AutoInjector, BindConfig, Bind, ParamTransform;

class ServiceProvider {
  ServiceProvider._();

  final injector = AutoInjector();

  static final _instance = ServiceProvider._();

  factory ServiceProvider() {
    return _instance;
  }

  /// Request an instance by [Type]
  /// <br>
  /// [transform] : Transform a param. This can be used for example
  /// to replace an instance with a mock in tests.
  /// <br>
  /// When [key] is provided it will search the instance that have the same key
  T get<T>({ParamTransform? transform, String? key}) => injector.get<T>(
        transform: transform,
        key: key,
      );

  /// Request an instance by [Type]
  /// <br>
  /// [transform]: Transform a param. This can be used for example
  /// to replace an instance with a mock in tests.
  /// <br>
  /// When [key] is provided it will search the instance that have the same key
  T call<T>({ParamTransform? transform, String? key}) =>
      injector.call(transform: transform, key: key);

  /// Register a factory instance.
  /// A new instance will be generated whenever requested.
  /// ```dart
  /// injector.add(MyController.new);
  /// ```
  /// <br>
  /// When [key] is provided this instance only can be found by key
  void add<T>(Function constructor, {BindConfig<T>? config, String? key}) =>
      injector.add(constructor, config: config, key: key);

  /// Register a instance.
  /// A concrete object (Not a function).
  /// ```dart
  /// injector.addInstance(MyController());
  /// ```
  /// <br>
  /// When [key] is provided this instance only can be found by key
  void addInstance<T>(T instance, {BindConfig<T>? config, String? key}) {
    injector.addInstance(instance, config: config, key: key);
  }

  /// Register a Singleton instance.
  /// It will generate a single instance for the duration of
  /// the application, or until manually removed.<br>
  /// The object will be started as soon as it is registered.
  /// ```dart
  /// injector.addSingleton(MyController.new);
  /// ```
  /// <br>
  /// When [key] is provided this instance only can be found by key
  void addSingleton<T>(
    Function constructor, {
    BindConfig<T>? config,
    String? key,
  }) =>
      injector.addSingleton(constructor, config: config, key: key);

  /// Register a LazySingleton instance.
  /// It will generate a single instance for the duration of
  /// the application, or until manually removed.<br>
  /// The object will be started only when requested the first time.
  /// ```dart
  /// injector.addLazySingleton(MyController.new);
  /// ```
  /// <br>
  /// When [key] is provided this instance only can be found by key
  void addLazySingleton<T>(
    Function constructor, {
    BindConfig<T>? config,
    String? key,
  }) =>
      injector.addLazySingleton(constructor, config: config, key: key);

  void addBind<T>(Bind<T> bind) => injector.addBind(bind);

  void commit() => injector.commit();

  void dispose() => injector.dispose();

  /// Request an notifier property by [Type]
  /// <br>
  /// When [key] is provided it will search the instance that have the same key
  dynamic getNotifier<T>({String? key}) => injector.getNotifier<T>(key: key);
}

final serviceProvider = ServiceProvider();
