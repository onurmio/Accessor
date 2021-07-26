import 'dart:async';

import 'package:accessor/src/accessorItem.dart';

class StreamItem {
  StreamController _streamController = StreamController.broadcast();
  List<String> _bindings = [];

  void bind(AccessorItem item) => _bindings.add(item.hashCode.toString());

  void unbind(AccessorItem item) => _bindings.remove(item.hashCode.toString());

  bool isBonded(AccessorItem item) =>
      _bindings.contains(item.hashCode.toString());

  void addListener(Function(dynamic) listener) =>
      _streamController.stream.listen(listener);

  void cleanListeners() {
    close();
    _streamController = StreamController.broadcast();
  }

  void clean() {
    _bindings.clear();
    cleanListeners();
  }

  void close() => _streamController.close();

  void notify(var data) => _streamController.add(data);

  bool get isEmpty => _bindings.isEmpty;
}
