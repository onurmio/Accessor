library accessor;

import 'package:accessor/accessorException.dart';

class Accessor<T> {
  static Map<String, dynamic> _data = {};
  String _key;

  Accessor(String key) : _key = key;

  set value(T variable) {
    _data[_key] = variable;
  }

  T get value {
    if (_data.containsKey(_key))
      return _data[_key];
    else
      throw AccessorException("Invalid key!");
  }

  remove() {
    if (_data.containsKey(_key))
      _data.remove(_key);
    else
      throw AccessorException("Invalid key!");
  }
}
