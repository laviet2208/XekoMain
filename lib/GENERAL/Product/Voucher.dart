import '../Tool/Time.dart';

class Voucher {
  String id;
  String tenchuongtrinh;
  double totalmoney;
  double mincost;
  String LocationId;
  Time startTime;
  Time endTime;
  int useCount;
  int maxCount;

  int type; //0: giảm theo tiền cứng , 1: giảm theo phần trăm
  String Otype; //1: giảm cho tất cả loại đơn , 2 : giảm cho nhà hàng

  Voucher({required this.id, required this.totalmoney,required this.mincost,required this.startTime,required this.endTime,required this.useCount,required this.maxCount, required this.tenchuongtrinh, required this.LocationId, required this.type, required this.Otype});

  Map<dynamic, dynamic> toJson() => {
    'id' : id,
    'totalmoney' : totalmoney,
    'mincost' : mincost,
    'startTime' : startTime.toJson(),
    'endTime' : endTime.toJson(),
    'useCount' : useCount,
    'maxCount' : maxCount,
    'tenchuongtrinh' : tenchuongtrinh,
    'LocationId' : LocationId,
    'type' : type,
    'Otype' : Otype
  };

  factory Voucher.fromJson(Map<dynamic, dynamic> json) {
    return Voucher(
      id: json['id'].toString(),
      totalmoney: double.parse(json['totalmoney'].toString()),
      mincost: double.parse(json['mincost'].toString()),
      startTime: Time.fromJson(json['startTime']),
      endTime: Time.fromJson(json['endTime']),
      useCount: int.parse(json['useCount'].toString()),
      maxCount: int.parse(json['maxCount'].toString()),
      tenchuongtrinh: json['tenchuongtrinh'].toString(),
      LocationId: json['LocationId'].toString(),
      type: int.parse(json['type'].toString()),
      Otype: json['Otype'].toString(),
    );
  }

  void changeToDefault() {
    this.id = '';
    this.totalmoney = 0;
  }
}