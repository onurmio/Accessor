library accessor;

import 'package:accessor/accessorException.dart';

class Accessor<T> {
  static Map<String, dynamic> _data = {};
  String _key;

  Accessor(String key) : _key = key;

  void remove() {
    _checkKey(_key, () => _data.remove(_key));
  }

  static void removeAll(){
    _data.clear();
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
      throw AccessorException("key '$key' does not exist");
  }

  bool get isEmpty => _checkKey(_key, () => _data[_key] == null);

  set value(T variable) {
    if (_data.containsKey(_key)) {
      if (!checkType(_key, T))
        throw AccessorException(
            "type '${variable.runtimeType}' is not a subtype of type '${getType(_key)}'");
    }
    _data[_key] = variable;
  }

  T get value => _checkKey(_key, () => _data[_key]);
}
