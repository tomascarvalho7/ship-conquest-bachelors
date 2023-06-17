/// Represents a value of one of two possible types.
/// Instances of [Either] are either an instance of [Left] or [Right].
///
/// [Left] is used for "failure".
/// [Right] is used for "success".
abstract class Either<L, R> {
  const Either();

  // Represents the left side of [Either] class which by convention is a "Failure".
  bool get isLeft => this is Left<L, R>;

  // Represents the right side of [Either] class which by convention is a "Success"
  bool get isRight => this is Right<L, R>;

  /// Get [Left] value, may throw an exception when the value is [Right]
  L get left => this.fold<L>(
          (value) => value,
          (right) => throw Exception(
          'Illegal use. You should check isLeft before calling'));

  /// Get [Right] value, may throw an exception when the value is [Left]
  R get right => this.fold<R>(
          (left) => throw Exception(
          'Illegal use. You should check isRight before calling'),
          (value) => value);

  /// Transform values of [Left] and [Right]
  Either<TL, TR> either<TL, TR>(TL Function(L left) fnL, TR Function(R right) fnR);

  /// Fold [Left] and [Right] into the value of one type
  T fold<T>(T Function(L left) fnL, T Function(R right) fnR);
}

/// Used for "failure"
class Left<L, R> extends Either<L, R> {
  final L value;
  // constructor
  const Left(this.value);

  @override
  Either<TL, TR> either<TL, TR>(TL Function(L left) fnL, TR Function(R right) fnR) =>
    Left<TL, TR>(fnL(value));

  @override
  T fold<T>(T Function(L left) fnL, T Function(R right) fnR) => fnL(value);
}

/// Used for "success"
class Right<L, R> extends Either<L, R> {
  final R value;
  // constructor
  const Right(this.value);

  @override
  Either<TL, TR> either<TL, TR>(TL Function(L left) fnL, TR Function(R right) fnR) =>
    Right<TL, TR>(fnR(value));

  @override
  T fold<T>(T Function(L left) fnL, T Function(R right) fnR) => fnR(value);
}