import 'package:flutter_test/flutter_test.dart';
import 'package:ship_conquest/domain/either/either.dart';
import 'package:ship_conquest/domain/either/future_either.dart';

void main() {
  group('Either', () {
    test('isLeft should return true for Left instance', () {
      const either = Left<int, String>(42);

      final result = either.isLeft;

      expect(result, true);
    });

    test('isRight should return true for Right instance', () {
      const either = Right<int, String>('Success');

      final result = either.isRight;

      expect(result, true);
    });

    test('left should return the value of Left instance', () {
      const either = Left<int, String>(42);

      final result = either.left;

      expect(result, 42);
    });

    test('left should throw an exception for Right instance', () {
      final either = const Right<int, String>('Success');

      expect(() => either.left, throwsException);
    });

    test('right should return the value of Right instance', () {
      const either = Right<int, String>('Success');

      final result = either.right;

      expect(result, 'Success');
    });

    test('right should throw an exception for Left instance', () {
      final either = const Left<int, String>(42);

      expect(() => either.right, throwsException);
    });

    test('either should transform the values of Left and Right', () {
      const either = Right<int, String>('Hello');
      final transformed = either.either((left) => left * 2, (right) => right.length);

      final result = transformed.right;

      expect(result, 5);
    });

    test('fold should return the transformed value based on Left or Right', () {
      const leftEither = Left<int, String>(42);
      const rightEither = Right<int, String>('Success');

      final leftResult = leftEither.fold((left) => 'Left $left', (right) => 'Right $right');
      final rightResult = rightEither.fold((left) => 'Left $left', (right) => 'Right $right');

      expect(leftResult, 'Left 42');
      expect(rightResult, 'Right Success');
    });
  });


  group('FutureEitherExtension', () {
    test('isLeft should return true for Left instance', () async {
      final either = Future.value(const Left<int, String>(42));

      final result = await either.isLeft;

      expect(result, true);
    });

    test('isRight should return true for Right instance', () async {
      final either = Future.value(const Right<int, String>('Success'));

      final result = await either.isRight;

      expect(result, true);
    });

    test('either should transform the values of Left and Right', () async {
      final either = Future.value(Right<int, int>(5));
      final transformed = either.either((left) => left * 2, (right) => right * 2);

      final result = await transformed;

      expect(result.right, 10);
    });

    test('fold should fold Left and Right into the value of one type', () async {
      final either = Future.value(const Left<int, String>(42));
      final folded = either.fold((left) => 'Left $left', (right) => 'Right $right');

      final result = await folded;

      expect(result, 'Left 42');
    });
  });
}
