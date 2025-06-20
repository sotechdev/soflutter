import 'package:equatable/equatable.dart';

abstract class BaseState extends Equatable {
  @override
  List<Object?> get props => [];
}

class InitialState extends BaseState {}

class ErrorState extends BaseState {
  ErrorState(
    this.message, {
    this.error,
    this.stackTrace,
  });
  final String message;
  final Object? error;
  final StackTrace? stackTrace;
}

class SuccessState<TModel> extends BaseState {
  SuccessState(this.model);
  final TModel model;

  @override
  List<Object?> get props => [model];
}

class LoadingState extends BaseState {
  LoadingState(this.message);
  final String message;
}
