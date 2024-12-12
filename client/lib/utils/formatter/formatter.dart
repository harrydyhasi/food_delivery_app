import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class MyFormatter {
  static String formatDate(String date) {
    final DateTime parsedDate = DateTime.parse(date).toLocal();
    final DateFormat formatter = DateFormat('dd/MM/yyyy');
    return formatter.format(parsedDate);
  }

  static String formatDateTime(DateTime date) {
    date = date.toLocal();
    final DateFormat formatter = DateFormat('dd/MM/yyyy');
    return formatter.format(date);
  }

  static String formatCurrency(int amout) {
    var formatter = NumberFormat('#,###,###');
    var t = NumberFormat.currency(locale: "vi");
    return "${formatter.format(amout)} ${t.currencySymbol}";
  }

  static String formatDouble(double number) {
    if (number == number.toInt()) {
      return number.toInt().toString();
    } else {
      return number.toStringAsFixed(1);
    }
  }

  static String formatTime(String time) {
    try {
      final DateTime parsedTime = DateTime.parse(time).toLocal();
      final DateFormat formatter = DateFormat('HH:mm');
      return formatter.format(parsedTime);
    } catch (e) {
      return 'Invalid time';
    }
  }

  static TextInputFormatter thousandsSeparatorFormatter() {
    return TextInputFormatter.withFunction(
      (oldValue, newValue) {
        final text = newValue.text
            .replaceAll(RegExp(r'\D'), ''); // Remove non-numeric characters
        if (text.isEmpty) {
          return newValue.copyWith(text: '');
        }
        final number = int.tryParse(text);
        if (number == null) {
          return newValue;
        }
        final formattedNumber = NumberFormat('#,###')
            .format(number); // Format the number with thousands separator
        return newValue.copyWith(text: formattedNumber);
      },
    );
  }

  static String removeVietnameseTones(String str) {
    const withDiacritics =
        'áàảạãăắằẳẵặâấầẩẫậđéèẻẽẹêếềểễệíìỉĩịóòỏõọôốồổỗộơớờởỡợúùủũụưứừửữựýỳỷỹỵ';
    const withoutDiacritics =
        'aaaaaăăăăăâââââđeêêêêêêiiiiiõoôôôôôôoôôôôuụuụuuuyyyyy';
    for (int i = 0; i < withDiacritics.length; i++) {
      str = str.replaceAll(withDiacritics[i], withoutDiacritics[i]);
    }
    return str;
  }
}
