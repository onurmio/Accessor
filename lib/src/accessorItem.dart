import 'package:accessor/src/accessorException.dart';

import 'accessorStream.dart';

class AccessorItem {
  String? _streamKey;
  var data;

  AccessorItem(this.data);

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
    if (isBonded) AccessorStream(_streamKey!).notify(data);
  }

  void cleanListeners() {
    if (isBonded) AccessorStream(_streamKey!).cleanListeners();
  }

  bool get isBonded =>
      _streamKey != null ? AccessorStream(_streamKey!).isBonded(this) : false;
}
