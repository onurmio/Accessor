library accessor;

import 'package:accessor/accessorException.dart';

class Accessor<T> {
  static Map<String, dynamic> _data = {};
  String _key;

  Accessor(this._key);

  add(T variable) {
    if (!_data.containsKey(_key))
      _data[_key] = variable;
    else
      throw AccessorException("Invalid key!");
  }

  T get get {
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
