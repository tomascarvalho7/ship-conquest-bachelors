import 'dart:async';

import './either.dart';

extension FutureEitherExtension<L, R> on Future<Either<L, R>> {
  /// Represents the left side of [Either] class which by convention is a "Failure".
  Future<bool> get isLeft => then((either) => either.isLeft);

  /// Represents the right side of [Either] class which by convention is a "Success"
  Future<bool> get isRight => then((either) => either.isRight);

  /// Transform values of [Left] and [Right]
  Future<Either<TL, TR>> either<TL, TR>(TL Function(L left) fnL, TR Function(R right) fnR) =>
      then((either) => either.either(fnL, fnR));


  /// Fold [Left] and [Right] into the value of one type
  Future<T> fold<T>(FutureOr<T> Function(L left) fnL, FutureOr<T> Function(R right) fnR,) =>
    then((either) => either.fold(fnL, fnR));
}

typedef FutureEither<L, R> = Future<Either<L, R>>;