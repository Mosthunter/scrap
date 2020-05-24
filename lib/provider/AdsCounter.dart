import 'package:flutter/widgets.dart';

class AdsCounterProvider extends ChangeNotifier {
  int _count = 0;

  int get count => _count;

  set count(int val) {
    _count = val;
    notifyListeners();
  }
}
