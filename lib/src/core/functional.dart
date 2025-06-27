abstract class Option<T> {
  const Option();
  R fold<R>(R Function() ifNone, R Function(T) ifSome);
}

class Some<T> extends Option<T> {
  final T value;
  const Some(this.value);

  @override
  R fold<R>(R Function() ifNone, R Function(T) ifSome) => ifSome(value);
}

class None<T> extends Option<T> {
  const None();

  @override
  R fold<R>(R Function() ifNone, R Function(T) ifSome) => ifNone();
}

abstract class Either<L, R> {
  const Either();
  T fold<T>(T Function(L) ifLeft, T Function(R) ifRight);
}

class Left<L, R> extends Either<L, R> {
  final L value;
  const Left(this.value);

  @override
  T fold<T>(T Function(L) ifLeft, T Function(R) ifRight) => ifLeft(value);
}

class Right<L, R> extends Either<L, R> {
  final R value;
  const Right(this.value);

  @override
  T fold<T>(T Function(L) ifLeft, T Function(R) ifRight) => ifRight(value);
}