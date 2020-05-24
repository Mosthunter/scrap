import 'package:flutter/widgets.dart';

class Report extends ChangeNotifier {
  String _text, _targetId;
  String _topic = 'กล่าวอ้างถึงบุคคลที่สามในทางเสียหาย  ';

  String get reportText => _text;
  String get targetId => _targetId;
  String get topic => _topic;


  set reportText(String val) {
    _text = val;
    notifyListeners();
  }

  set topic(String val) {
    _topic = val;
    notifyListeners();
  }

  set targetId(String val) {
    _targetId = val;
    notifyListeners();
  }

}
