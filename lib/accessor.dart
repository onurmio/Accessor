library accessor;

import 'dart:async';
import 'dart:collection';

import 'package:accessor/accessorException.dart';

class Accessor<T> {
  static SplayTreeMap<String, _AccessorItem> _items = SplayTreeMap();
  String _key;

  Accessor(String key) : _key = key;

  void listen(Function(dynamic) listener) {
    try {
      _checkKey(_key, () => _items[_key]!.addListener(listener));
    } catch (e) {
      _items[_key] = _AccessorItem(null);
      _items[_key]!.addListener(listener);
    }
  }

  void cleanListeners() =>
      _checkKey(_key, () => _items[_key]!.cleanListeners());

  void remove() => _checkKey(_key, () {
        _items[_key]!.data = null;
        _items[_key]!.notify();
        _items.remove(_key);
      });

  static void removeAll() {
    _items.forEach((key, value) {
      value.data = null;
      value.notify();
    });
    _items.clear();
  }

  static bool exists(String key) => _items.containsKey(key);

  static Type getType(String key) =>
      _checkKey(key, () => _items[key]!.data.runtimeType);

  static bool checkType(String key, Type type) {
    Type itemType = getType(key);
    return itemType == type || itemType == Null;
  }

  static _checkKey(String key, Function function) {
    if (_items.containsKey(key))
      return function();
    else
      throw AccessorException("key '$key' does not exist");
  }

  bool get isEmpty => _checkKey(_key, () => _items[_key]!.data == null);

  set data(T variable) {
    if (_items.containsKey(_key)) {
      if (!checkType(_key, T))
        throw AccessorException(
            "type '${variable.runtimeType}' is not a subtype of type '${getType(_key)}'");
      _items[_key]!.data = variable;
      _items[_key]!.notify();
      return;
    }
    _items[_key] = _AccessorItem(variable);
  }

  T get data => _checkKey(_key, () => _items[_key]!.data);
}

class _AccessorItem {
  StreamController _streamController = StreamController.broadcast();
  var data;

  _AccessorItem(this.data);

  void addListener(Function(dynamic) listener) =>
      _streamController.stream.listen(listener);

  void cleanListeners() => _streamController = StreamController.broadcast();

  void notify() => _streamController.add(data);
}
