import 'package:accessor/src/accessorException.dart';
import 'package:logger/logger.dart';

import 'accessorStream.dart';

class AccessorItem {
  String? _streamKey;
  bool _logging = false;
  final Logger _logger = Logger(
      printer: PrettyPrinter(
    printTime: true,
    methodCount: 0,
  ));

  String _key;
  var data;

  AccessorItem(String key, this.data) : _key = key;

  void addListener(Function(dynamic) listener) {
    if (_streamKey == null) {
      _streamKey = AccessorStream.add();
      AccessorStream(_streamKey!).bind(this);
    }
    AccessorStream(_streamKey!).addListener(listener);
  }

  void bind(AccessorItem item) {
    if (item.isBonded) throw AccessorException("Accessor already bonded");
    if (isBonded) {
      AccessorStream(_streamKey!).bind(item);
      item._streamKey = _streamKey;
    }
  }

  void unbind(AccessorItem? item) {
    item = item ?? this;
    if (item.isBonded) {
      AccessorStream(_streamKey!).unbind(item);
      item._streamKey = null;
    }
  }

  void notify() {
    if (_logging)
      _logger.d({
        "key": _key,
        "data": data,
        "streamKey": _streamKey,
      });
    if (isBonded) AccessorStream(_streamKey!).notify(data);
  }

  void cleanListeners() {
    if (isBonded) AccessorStream(_streamKey!).cleanListeners();
  }

  enableLogging() => _logging = true;

  disableLogging() => _logging = false;

  bool get isBonded =>
      _streamKey != null ? AccessorStream(_streamKey!).isBonded(this) : false;
}
