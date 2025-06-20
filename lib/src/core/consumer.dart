import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart'
    show BlocBuilderCondition, BlocListenerCondition, BlocConsumer;
import 'package:soflutter/src/core/controller.dart';

typedef FrameworkBlocWidgetBuilder<TState> = Widget Function(
    BuildContext context, TState state);
typedef FrameworkBlocWidgetListener<TState> = void Function(
    BuildContext context, TState state);

class Consumer<TController extends Controller<TState>, TState>
    extends StatelessWidget {
  const Consumer({
    super.key,
    required this.builder,
    this.listener,
    this.controller,
    this.listenWhen,
    this.buildWhen,
  });

  /// Função que constrói o widget com base no estado do [Controller].
  final FrameworkBlocWidgetBuilder<TState> builder;

  /// Função que é chamada quando o estado do [Controller] muda.
  final FrameworkBlocWidgetListener<TState>? listener;

  /// O [Controller] a ser consumido. Se for nulo, o [Controller] será procurado no contexto.
  final TController? controller;

  /// Condição opcional para disparar o listener.
  final BlocListenerCondition<TState>? listenWhen;

  /// Condição opcional para reconstruir o builder.
  final BlocBuilderCondition<TState>? buildWhen;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TController, TState>(
      builder: builder,
      listener: (context, state) {
        listener?.call(context, state);
      },
      bloc: controller,
      listenWhen: listenWhen,
      buildWhen: buildWhen,
    );
  }
}
