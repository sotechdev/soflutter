import 'package:soflutter/src/controllers/async_state.dart';

abstract class AsyncObserver<T> {
  void onState(AsyncState state);
  void onData(T? data);
  void onError(Exception? error);
}