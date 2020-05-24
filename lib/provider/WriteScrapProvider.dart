import 'package:flutter/widgets.dart';

class WriteScrapProvider extends ChangeNotifier {
  String _text;
  bool _public;

  String get text => _text;
  bool get public => _public;

  set text(String val) {
    _text = val;
    notifyListeners();
  }

  set public(bool val) {
    _public = val;
    notifyListeners();
  }
}
