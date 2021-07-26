import 'dart:collection';

import 'package:accessor/src/accessorItem.dart';
import 'package:accessor/src/streamItem.dart';
import 'package:uuid/uuid.dart';

import 'accessorException.dart';

class AccessorStream {
  static SplayTreeMap<String, StreamItem> _items = SplayTreeMap();
  String _key;

  AccessorStream(this._key);

  static String add() {
    String key = Uuid().v4();
    _items[key] = StreamItem();
    return key;
  }

  static _checkKey(String key, Function function) {
    if (_items.containsKey(key))
      return function();
    else
      throw AccessorException("key '$key' does not exist");
  }

  void addListener(Function(dynamic) listener) =>
      _checkKey(_key, () => _items[_key]!.addListener(listener));

  void cleanListeners() =>
      _checkKey(_key, () => _items[_key]!.cleanListeners());

  void bind(AccessorItem item) =>
      _checkKey(_key, () => _items[_key]!.bind(item));

  void unbind(AccessorItem item) =>
      _checkKey(_key, () => _items[_key]!.unbind(item));

  void notify(var data) => _checkKey(_key, () => _items[_key]!.notify(data));

  bool isBonded(AccessorItem item) =>
      _checkKey(_key, () => _items[_key]!.isBonded(item));
}
