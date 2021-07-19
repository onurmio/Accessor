library accessor;

import 'dart:async';
import 'dart:collection';

import 'package:accessor/accessorException.dart';

class Accessor<T> {
  static SplayTreeMap<String, _AccessorItem> _data = SplayTreeMap();
  String _key;

  Accessor(String key) : _key = key;

  void remove() => _checkKey(_key, () {
        _data[_key]!.data = null;
        _data[_key]!.notify();
        _data.remove(_key);
      });

  void listen(Function(dynamic) listener) =>
      _checkKey(_key, () => _data[_key]!.addListener(listener));

  static void removeAll() {
    _data.forEach((key, value) {
      value.data = null;
      value.notify();
    });
    _data.clear();
  }

  static bool exists(String key) => _data.containsKey(key);

  static Type getType(String key) =>
      _checkKey(key, () => _data[key]!.data.runtimeType);

  static bool checkType(String key, Type type) => getType(key) == type;

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
      _data[_key]!.data = variable;
      _data[_key]!.notify();
      return;
    }
    _data[_key] = _AccessorItem(variable);
  }

  T get value => _checkKey(_key, () => _data[_key]!.data);
}

class _AccessorItem {
  StreamController streamController = StreamController.broadcast();
  var data;

  _AccessorItem(data) : data = data;

  void addListener(Function(dynamic) listener) =>
      streamController.stream.listen(listener);

  void notify() => streamController.add(data);
}
