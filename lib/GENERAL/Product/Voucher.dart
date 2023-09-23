import '../Tool/Time.dart';

class Voucher {
  String id;
  double totalmoney;
  double mincost;

  Voucher({required this.id, required this.totalmoney,required this.mincost});

  Map<dynamic, dynamic> toJson() => {
    'id' : id,
    'totalmoney' : totalmoney,
    'mincost' : mincost
  };

  factory Voucher.fromJson(Map<dynamic, dynamic> json) {
    return Voucher(
        id: json['id'].toString(),
        totalmoney: double.parse(json['totalmoney'].toString()),
        mincost: double.parse(json['mincost'].toString()),
    );
  }
}