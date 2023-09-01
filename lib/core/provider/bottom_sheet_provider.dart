import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BottomSheetController with ChangeNotifier {
  String? formattedDate;
  DateTime _dateTime = DateTime.now();
  DateTime get dateTime => _dateTime;
  void updateDate(DateTime newDate) {
    _dateTime = newDate;
    formattedDate = DateFormat('dd MMMM yyyy').format(_dateTime);
    notifyListeners();
  }

  bool? isCheck;
  // bool get isChecked => _isCheck;
  bool checkIsCompleted() {
    isCheck = !isCheck!;
    notifyListeners();
    return isCheck!;
  }

  int count = 0;

  void updateCount(int newCount) {
    count = newCount;
    notifyListeners();
  }

  int number = 0;

  void updateNumber(int newCount) {
    number = newCount;
    notifyListeners();
  }
}
