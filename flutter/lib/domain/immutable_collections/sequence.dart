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
    final _data = [...data]; // create new list instance
    _data[index] = tile; // replace element
    return Sequence(data: _data);
  }

  Sequence<T> filter(bool Function(T) condition) => Sequence(data: [...data.where(condition)]);

  Sequence<N> filterInstance<N>() => Sequence(data: [...data.whereType<N>()]);

  void forEachIndexed(void Function(int index, T element) f) {
    final len = data.length;
    for (var i = 0; i < len; i++) {
      f(i, data[i]);
    }
  }

  @override
  Sequence<K> map<K>(K Function(T value) toElement) => Sequence(data: data.map(toElement).toList());

  @override
  Iterator<T> get iterator => data.iterator;
}