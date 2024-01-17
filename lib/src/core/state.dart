sealed class BaseState {}

abstract class ErrorState {
  ErrorState(this.message);
  final String message;
}

abstract class SuccessState<TModel> {
  SuccessState(this.model);
  final TModel model;
}

abstract class LoadingState {
  LoadingState(this.message);
  final String message;
}
