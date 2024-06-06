import 'package:intl/intl.dart';

// Bu sınıf, tarih ve saat biçimlendirme işlevselliği sağlar
class DateTimeFormatService {
  // Verilen DateTime nesnesini belirli bir biçimde stringe dönüştürür
  String formatDateTime(DateTime dateTime) {
    final formatter =
        DateFormat('yyyy-MM-dd HH:mm:ss'); // Tarih ve saat biçimi belirlenir
    return formatter
        .format(dateTime); // Belirlenen biçimde stringe dönüştürülür
  }
}
