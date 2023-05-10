class Sequence<T> {
  final List<T> data;
  // constructor
  Sequence({required this.data});

  Sequence.empty() : data = [];

  int get length => data.length;

  T get(int index) => data[index];

  Sequence<T> put(T tile) => Sequence(data: [...data, tile]);

  Sequence<T> replace(int index, T tile) {
    final _data = [...data]; // create new list instance
    _data[index] = tile; // replace element
    return Sequence(data: _data);
  }

  Sequence<K> map<K>(K Function(T value) block) => Sequence(data: data.map(block).toList());
}