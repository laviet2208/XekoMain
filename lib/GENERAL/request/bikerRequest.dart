import 'package:flutter/material.dart';

import '../NormalUser/accountNormal.dart';

class bikeRequest {
  String id;
  String name;
  String phoneNumber;
  String cmnd;
  String address;
  int type;
  accountNormal owner;

  bikeRequest({
    required this.id,
    required this.phoneNumber,
    required this.cmnd,
    required this.name,
    required this.address,
    required this.type,
    required this.owner
  });

  Map<dynamic, dynamic> toJson() => {
    'id' :id,
    'address' : address,
    'phoneNumber' : phoneNumber,
    'name' : name,
    'cmnd' : cmnd,
    'type' : type,
    'owner' : owner.toJson()
  };

  factory bikeRequest.fromJson(Map<dynamic, dynamic> json) {
    return bikeRequest(
      id: json['id'],
      address: json['address'].toString(),
      phoneNumber: json['phoneNumber'].toString(),
      name: json['name'].toString(),
      cmnd: json['cmnd'].toString(),
      type: int.parse(json['type'].toString()),
      owner: accountNormal.fromJson(json['owner'])
    );
  }
}
