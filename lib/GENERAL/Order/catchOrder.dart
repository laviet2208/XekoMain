

import 'package:xekomain/FINAL/finalClass.dart';

import '../NormalUser/accountLocation.dart';
import '../NormalUser/accountNormal.dart';
import '../Tool/Time.dart';

class catchOrder {
  String id;
  accountLocation locationSet;
  accountLocation locationGet;
  int type;
  double cost;
  Time startTime;
  Time receiveTime;
  Time endTime;
  Time cancelTime;
  accountNormal owner;
  accountNormal shipper;
  String status;

  catchOrder({
    required this.id,
    required this.locationSet,
    required this.locationGet,
    required this.cost,
    required this.owner,
    required this.shipper,
    required this.status,
    required this.endTime,
    required this.startTime,
    required this.cancelTime,
    required this.receiveTime,
    required this.type
  });

  Map<dynamic, dynamic> toJson() => {
    'id' : id,
    'locationSet' : locationSet.toJson(),
    'locationGet' : locationGet.toJson(),
    'cost' : cost,
    'startTime' : startTime.toJson(),
    'receiveTime' : receiveTime.toJson(),
    'endTime' : endTime.toJson(),
    'cancelTime' : cancelTime.toJson(),
    'owner' : owner.toJson(),
    'status' : status,
    'shipper' : shipper.toJson(),
    'type' : type
  };

  factory catchOrder.fromJson(Map<dynamic, dynamic> json) {
    accountNormal shipper;

    if (json['shipper'] != null) {
      shipper = accountNormal.fromJson(json['shipper']);
    } else {
      shipper = accountNormal(id: "NA", avatarID: "NA", createTime: Time(second: 0, minute: 0, hour: 0, day: 0, month: 0, year: 0), status: 1, name: "NA", phoneNum: "NA", type: 0, locationHis: accountLocation(phoneNum: '', LocationID: '', Latitude: 0, Longitude: 0, firstText: '', secondaryText: ''), voucherList: [], totalMoney: 0, Area: currentAccount.Area);
    }

    return catchOrder(
        id: json['id'].toString(),
        locationSet: accountLocation.fromJson(json['locationSet']),
        locationGet: accountLocation.fromJson(json['locationGet']),
        cost: double.parse(json['cost'].toString()),
        owner: accountNormal.fromJson(json['owner']),
        status: json['status'].toString(),
        endTime: Time.fromJson(json['endTime']),
        startTime: Time.fromJson(json['startTime']),
        cancelTime: Time.fromJson(json['cancelTime']),
        receiveTime: Time.fromJson(json['receiveTime']),
        shipper: shipper,
        type: int.parse(json['type'].toString()),
    );
  }
}