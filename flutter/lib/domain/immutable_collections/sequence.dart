
///
/// Generic Immutable class that extends the [Iterable]
/// class.
/// The [Sequence] class contains a immutable [List]
/// with non-variable elements.
///
class Sequence<T> extends Iterable<T> {
  final List<T> data;
  // constructor
  Sequence({required this.data});

  Sequence.empty() : data = [];

  @override
  int get length => data.length;

  T get(int index) => data[index];

  Sequence<T> put(T tile) => Sequence(data: [...data, tile]);

  Sequence<T> replace(int index, T tile) {
    final newData = [...data]; // create new list instance
    newData[index] = tile; // replace element
    return Sequence(data: newData);
  }

  Sequence<T> plus(Sequence<T> other) => this + other;
  Sequence<T> operator +(Sequence<T> other) => Sequence(data: [...data, ...other.data]);

  Sequence<T> filter(bool Function(T) condition) => Sequence(data: [...data.where(condition)]);
  Sequence<N> filterInstance<N>() => Sequence(data: [...data.whereType<N>()]);

  @override
  Sequence<K> map<K>(K Function(T value) toElement) => Sequence(data: data.map(toElement).toList());

  @override
  Iterator<T> get iterator => data.iterator;
}