import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Typedef para a função de criação de uma Controller.
/// Recebe um BuildContext que pode ser usado para resolver dependências
/// (por exemplo, usando context.read<Dependency>()).
typedef ServiceFactory<TService extends StateStreamableSource<TState>, TState>
    = TService Function(BuildContext context);

extension ServiceProviderExtension on BuildContext {
  T get<T>() => ReadContext(this).read<T>();
  T watch<T>() => WatchContext(this).watch<T>();
}

class ServiceProvider extends StatelessWidget {
  final List<Provider> providers;
  final Widget child;

  const ServiceProvider({
    super.key,
    required this.providers,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: providers,
      child: child,
    );
  }
}

class Provider<TService extends StateStreamableSource<Object?>>
    extends BlocProvider<TService> {
  const Provider({super.key, required super.create});
}
