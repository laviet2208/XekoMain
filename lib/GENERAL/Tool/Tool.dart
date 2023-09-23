import 'dart:math';

import '../Tool/Time.dart';

import '../Product/Evaluate.dart';

//Tool khởi tạo 1 chuỗi id ngẫu nhiên gồm count ký tự
String generateID(int count) {
  final character = "12CDEFGH3GH789ABCDEFGH";
  var returnString = "";
  final length = count;
  final random = Random();
  var text = List.generate(length, (index) => character[random.nextInt(character.length)]);

  for (var i = 0 ; i < text.length ; i++) {
    returnString += text[i];
  }

  return returnString;
}

//chuyển 1 biến time qua String dưới dạng ngày tháng năm
String getTimeString(Time time) {
  return time.day.toString() + "/" + time.month.toString() + "/" + time.year.toString();
}

//chuyển 1 biến time qua String dưới dạng giờ phút giây ngày tháng năm
String getAllTimeString(Time time) {
  return time.hour.toString() + ":" + time.minute.toString() + ":" + time.second.toString() + "  /" + time.day.toString() + "/" + time.month.toString() + "/" + time.year.toString();
}

//chuyển 1 biến double qua string , phân tách hàng nghìn
String getStringNumber(double number) {
  String result = number.toStringAsFixed(0); // làm tròn số
  result = result.replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]},'); // chuyển đổi phân tách hàng nghìn
  return result;
}

//tính trung bình đánh giá , ép kiểu double
double countRatedb(List<Evaluate> evaluate) {
  if (evaluate.isEmpty) {
    return 0.0;
  } else {
    int sum = 0;
    for (int i = 0; i < evaluate.length; i++) {
      sum += evaluate[i].star;
    }
    double avg = sum / evaluate.length;
    return avg;
  }
}

//tính trung bình đánh giá , ép kiểu string
String countRate(List<Evaluate> evaluate) {
  if (evaluate.isEmpty) {
    return "0.0";
  } else {
    int sum = 0;
    for (int i = 0; i < evaluate.length; i++) {
      sum += evaluate[i].star;
    }
    double avg = sum / evaluate.length;
    return avg.toStringAsFixed(1);
  }
}

//lấy số ngẫu nhiên
int get_randomnumber(int start, int end) { Random random = Random();
return start + random.nextInt(end - start + 1);
}

//rút gọn chuỗi
String compactString(int n, String str) {
  if (n >= str.length) {
    return str;
  }
  return str.substring(0, n) + "...";
}

Time getCurrentTime() {
  DateTime now = DateTime.now();

  Time currentTime = Time(second: 0, minute: 0, hour: 0, day: 0, month: 0, year: 0);
  currentTime.second = now.second;
  currentTime.minute = now.minute;
  currentTime.hour = now.hour;
  currentTime.day = now.day;
  currentTime.month = now.month;
  currentTime.year = now.year;

  return currentTime;
}