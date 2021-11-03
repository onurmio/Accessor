import 'dart:collection';

import 'package:accessor/src/accessorException.dart';
import 'package:accessor/src/accessorItem.dart';

class Accessor<T> {
  static SplayTreeMap<String, AccessorItem> _items = SplayTreeMap();
  late String _key;

  Accessor({String? key}) {
    if (key != null)
      _key = key;
    else
      _key = T.hashCode.toString();
  }

  static void removeAll() {
    _items.forEach((key, value) {
      value.data = null;
      value.notify();
    });
    _items.clear();
  }

  bool exist() => _items.containsKey(_key);

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

  static _createKey(String key) {
    try {
      _checkKey(key, () {});
    } catch (e) {
      _items[key] = AccessorItem(key, null);
    }
  }

  void listen(Function(dynamic) listener) {
    _createKey(_key);
    _items[_key]!.addListener(listener);
  }

  void cleanListeners() =>
      _checkKey(_key, () => _items[_key]!.cleanListeners());

  void bind(String key) {
    _createKey(key);
    _items[_key]!.bind(_items[key]!);
  }

  void unbind(String key) {
    _checkKey(
        _key, () => _checkKey(key, () => _items[_key]!.unbind(_items[key]!)));
  }

  void bindList(List<String> keys) => keys.forEach((key) => bind(key));

  void unbindList(List<String> keys) => keys.forEach((key) => unbind(key));

  void enableLogging() {
    _createKey(_key);
    _items[_key]!.enableLogging();
  }

  void disableLogging() {
    _checkKey(_key, () => _items[_key]!.disableLogging());
  }

  void remove() => _checkKey(_key, () {
        _items[_key]!.data = null;
        _items[_key]!.notify();
        _items.remove(_key);
      });

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
    _items[_key] = AccessorItem(_key, variable);
  }

  T get data => _checkKey(_key, () => _items[_key]!.data);
}
