
import 'package:xekomain/FINAL/finalClass.dart';

import '../NormalUser/accountLocation.dart';
import '../NormalUser/accountNormal.dart';
import '../Tool/Time.dart';
import 'Receiver.dart';
import 'item_details.dart';

class itemsendOrder {
  final String id;
  final accountLocation locationset;
  final double cost;
  final Time startTime;
  final Time receiveTime;
  final Time endTime;
  final Time cancelTime;
  final accountNormal owner;
  final Receiver receiver;
  final item_details itemdetails;
  final accountNormal shipper;
  final String status;

  itemsendOrder({
    required this.id,
    required this.cost,
    required this.owner,
    required this.shipper,
    required this.status,
    required this.endTime,
    required this.startTime,
    required this.cancelTime,
    required this.receiveTime,
    required this.locationset,
    required this.receiver,
    required this.itemdetails
  });

  Map<dynamic, dynamic> toJson() => {
    'id' : id,
    'locationset' : locationset.toJson(),
    'cost' : cost,
    'startTime' : startTime.toJson(),
    'receiveTime' : receiveTime.toJson(),
    'endTime' : endTime.toJson(),
    'cancelTime' : cancelTime.toJson(),
    'owner' : owner.toJson(),
    'receiver' : receiver.toJson(),
    'itemdetails' : itemdetails.toJson(),
    'shipper' : shipper.toJson(),
    'status' : status
  };

  factory itemsendOrder.fromJson(Map<dynamic, dynamic> json) {
    accountNormal shipper;

    if (json['shipper'] != null) {
      shipper = accountNormal.fromJson(json['shipper']);
    } else {
      shipper = accountNormal(id: "NA", avatarID: "NA", createTime: Time(second: 0, minute: 0, hour: 0, day: 0, month: 0, year: 0), status: 1, name: "NA", phoneNum: "NA", type: 0, locationHis: accountLocation(phoneNum: '', LocationID: '', Latitude: 0, Longitude: 0, firstText: '', secondaryText: ''), voucherList: [], totalMoney: 0, Area: currentAccount.Area);
    }

    return itemsendOrder(
      id: json['id'].toString(),
      cost: double.parse(json['cost'].toString()),
      owner: accountNormal.fromJson(json['owner']),
      status: json['status'].toString(),
      endTime: Time.fromJson(json['endTime']),
      startTime: Time.fromJson(json['startTime']),
      cancelTime: Time.fromJson(json['cancelTime']),
      receiveTime: Time.fromJson(json['receiveTime']),
      shipper: shipper,
      locationset: accountLocation.fromJson(json['locationset']),
      receiver: Receiver.fromJson(json['receiver']),
      itemdetails: item_details.fromJson(json['itemdetails']),
    );
  }
}