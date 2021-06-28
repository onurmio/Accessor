library accessor;

import 'package:accessor/accessorException.dart';

class Accessor<T> {
  static Map<String, dynamic> _data = {};
  String _key;

  Accessor(String key) : _key = key;

  void remove() {
    _checkData(_key, _data.remove(_key));
  }

  static bool exists(String key) {
    return _data.containsKey(key);
  }

  static Type getType(String key) {
    return _checkKey(key, () => _data[key].runtimeType);
  }

  static bool checkType(String key, Type type) {
    return getType(key) == type;
  }

  static _checkKey(String key, Function function) {
    if (_data.containsKey(key))
      return function();
    else
      throw AccessorException("Invalid key!");
  }

  static _checkData(String key, Function function) {
    return _checkKey(key, () {
      if (_data[key] != null)
        return function();
      else
        throw AccessorException("Data does not exist!");
    });
  }

  bool get isEmpty => _checkKey(_key, () => _data[_key] == null);

  set value(T variable) {
    _data[_key] = variable;
  }

  T get value => _checkData(_key, () => _data[_key]);
}
