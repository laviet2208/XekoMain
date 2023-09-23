import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:http/http.dart' as http;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:xekomain/FINAL/finalClass.dart';
import 'package:xekomain/GENERAL/Order/catchOrder.dart';
import 'package:xekomain/GENERAL/Tool/Tool.dart';
import 'package:xekomain/OTHER/Button/Buttontype1.dart';
import 'package:xekomain/SCREEN/FEATURE/SCREEN_CARORDER/SCREENcarorder.dart';
import 'package:xekomain/SCREEN/FEATURE/SCREEN_CARORDER/SCREEN_waitdriver.dart';

import '../../../GENERAL/NormalUser/accountLocation.dart';
import '../../../GENERAL/NormalUser/accountNormal.dart';
import '../../../GENERAL/Product/Voucher.dart';
import '../../../GENERAL/Tool/Time.dart';
import '../../VOUCHER/SCREENvoucherchosen.dart';

class SCREENlocationcarst2 extends StatefulWidget {
  final double Distance;
  final accountLocation diemdon;
  final accountLocation diemtra;
  const SCREENlocationcarst2({Key? key, required this.Distance, required this.diemdon, required this.diemtra}) : super(key: key);

  @override
  State<SCREENlocationcarst2> createState() => _SCREENlocationcarst2State();
}

class _SCREENlocationcarst2State extends State<SCREENlocationcarst2> {
  late GoogleMapController mapController;
  double _originLatitude = 0, _originLongitude = 0;
  double _destLatitude = 0, _destLongitude = 0;
  Map<MarkerId, Marker> markers = {};
  Map<PolylineId, Polyline> polylines = {};
  List<LatLng> polylineCoordinates = [];
  PolylinePoints polylinePoints = PolylinePoints();
  String googleAPiKey = "AIzaSyBsVQaVVMXw-y3QgvCWwJe02FWkhqP_wRA";
  bool Loading1 = false;
  double cost = 0;

  void _onMapCreated(GoogleMapController controller) async {
    mapController = controller;
  }

  _addMarker(LatLng position, String id, BitmapDescriptor descriptor) {
    MarkerId markerId = MarkerId(id);
    Marker marker =
    Marker(markerId: markerId, icon: descriptor, position: position);
    markers[markerId] = marker;
  }


  _addPolyLine() {
    PolylineId id = PolylineId("poly");
    Polyline polyline = Polyline(
        polylineId: id, color: Colors.red, points: polylineCoordinates);
    polylines[id] = polyline;
    setState(() {});
  }

  _getPolyline() async {
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      googleAPiKey,
      PointLatLng(_originLatitude, _originLongitude),
      PointLatLng(_destLatitude, _destLongitude),
      travelMode: TravelMode.driving,
    );
    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    }
    _addPolyLine();
  }

  int getCost(double distance) {
    int cost = 0;
    if (distance >= 2.0) {
      cost += 20000; // Giá cước cho 2km đầu tiên (10.000 VND/km * 2km)
      distance -= 2.0; // Trừ đi 2km đã tính giá cước
      cost = cost + ((distance - 2) * 5000).toInt();
    } else {
      cost += (distance * 10000).toInt(); // Giá cước cho khoảng cách dưới 2km
    }
    return cost;
  }

  Future<void> pushCatchOrder(catchOrder catchorder) async {
    try {
      DatabaseReference databaseRef = FirebaseDatabase.instance.reference();
      await databaseRef.child('catchOrder').child(catchorder.id).set(catchorder.toJson());
      Navigator.push(context, MaterialPageRoute(builder:(context) => SCREENwaitdriver(diemdon: widget.diemdon, diemtra: widget.diemtra,)));
    } catch (error) {
      print('Đã xảy ra lỗi khi đẩy catchOrder: $error');
      throw error;
    }
  }

  Future<void> pushVoucherdata(List<Voucher> list) async {
    try {
      DatabaseReference databaseRef = FirebaseDatabase.instance.reference();
      await databaseRef.child('normalUser/' + currentAccount.id + "/voucherList").remove();
      if (list.isNotEmpty) {
        for (int i = 0 ; i < list.length ; i++) {
          await databaseRef.child('normalUser/' + currentAccount.id + "/voucherList/" + i.toString()).set(list[i].toJson());
        }
      }
    } catch (error) {
      print('Đã xảy ra lỗi khi đẩy catchOrder: $error');
      throw error;
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _originLatitude = widget.diemdon.Latitude;
    _originLongitude = widget.diemdon.Longitude;
    _destLatitude = widget.diemtra.Latitude;
    _destLongitude = widget.diemtra.Longitude;
    _addMarker(LatLng(_originLatitude, _originLongitude), "origin", BitmapDescriptor.defaultMarker);

    _addMarker(LatLng(_destLatitude, _destLongitude), "destination", BitmapDescriptor.defaultMarkerWithHue(90));
    _getPolyline();
    if (chosenvoucher.id != 'NA') {
      cost = getCost(widget.Distance).toDouble() - chosenvoucher.totalmoney;
    } else {
      cost = getCost(widget.Distance).toDouble();
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return WillPopScope(
      child: SafeArea(
        child: Scaffold(
            body: Container(
              child: Stack(
                children: <Widget>[
                  Positioned(
                    top: 0,
                    left: 0,
                    child: Container(
                      height: screenHeight/1.5,
                      width: screenWidth,
                      child: GoogleMap(
                        initialCameraPosition: CameraPosition(
                            target: LatLng(_originLatitude, _originLongitude), zoom: 12),
                        myLocationEnabled: false,
                        tiltGesturesEnabled: true,
                        compassEnabled: true,
                        scrollGesturesEnabled: true,
                        zoomGesturesEnabled: true,
                        zoomControlsEnabled: false,
                        onMapCreated: _onMapCreated,
                        markers: Set<Marker>.of(markers.values),
                        polylines: Set<Polyline>.of(polylines.values),
                      ),
                    ),
                  ),

                  Positioned(
                    bottom: 0,
                    left: 0,
                    child: Container(
                      height: screenHeight/2.5,
                      width: screenWidth,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15)
                      ),

                      child: Stack(
                        children: <Widget>[
                          Positioned(
                            top: 10,
                            left: 10,
                            child: Text(
                              "Đặt taxi ( " + double.parse(widget.Distance.toStringAsFixed(1)).toString() + " km )",
                              style: TextStyle(
                                color: Colors.black,
                                fontFamily: "arial",
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                          ),

                          Positioned(
                            top: 50,
                            left: 0,
                            child: Container(
                              width: screenWidth,
                              height: screenHeight/10,
                              decoration: BoxDecoration(
                                  color: Color.fromARGB(255, 255, 237, 216)
                              ),

                              child: Stack(
                                children: <Widget>[
                                  Positioned(
                                    top: (screenHeight/10 - screenHeight/14)/2,
                                    left: 10,
                                    child: Container(
                                      height: screenHeight/14,
                                      width: screenHeight/14,
                                      decoration: BoxDecoration(
                                          image: DecorationImage(
                                              fit: BoxFit.cover,
                                              image: AssetImage('assets/image/carLogo1.png')
                                          )
                                      ),
                                    ),
                                  ),

                                  Positioned(
                                    top: (screenHeight/10)/3,
                                    left: 10 + screenHeight/14 + 15,
                                    child: Container(
                                      child: Text(
                                        'XeKo Car',
                                        style: TextStyle(
                                            fontFamily: 'arial',
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18
                                        ),
                                      ),
                                    ),
                                  ),

                                  Positioned(
                                    top: (screenHeight/10)/3,
                                    right: 10,
                                    child: Text(
                                      getStringNumber(cost) + "đ",
                                      style: TextStyle(
                                          fontFamily: 'arial',
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),

                          Positioned(
                            bottom: 0,
                            left: 0,
                            child: Container(
                              width: screenWidth,
                              height: screenHeight/7,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.3), // màu của shadow
                                    spreadRadius: 5, // bán kính của shadow
                                    blurRadius: 7, // độ mờ của shadow
                                    offset: Offset(0, 3), // vị trí của shadow
                                  ),
                                ],
                              ),

                              child: Stack(
                                children: <Widget>[
                                  Positioned(
                                    top: 10,
                                    left: 20,
                                    child: Container(
                                      width: 42,
                                      height: 21,
                                      decoration: BoxDecoration(
                                          image: DecorationImage(
                                              fit: BoxFit.cover,
                                              image: AssetImage('assets/image/realmoneyicon.png')
                                          )
                                      ),
                                    ),
                                  ),

                                  Positioned(
                                    top: 13,
                                    left: 20 + 42 + 10,
                                    child: Text(
                                      'Sử dụng tiền mặt',
                                      style: TextStyle(
                                          fontFamily: 'arial',
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black
                                      ),
                                    ),
                                  ),


                                  ///Nút đặt xe
                                  Positioned(
                                    bottom: 10,
                                    left: 10,
                                    child: Container(
                                      width: screenWidth/2 - 20,
                                      height: screenHeight/15,
                                      child: ButtonType1(Height: screenHeight/10, Width: screenWidth/2 - 20, color: Color.fromARGB(255, 244, 164, 84), radiusBorder: 30, title: 'Đặt xe', fontText: 'arial', colorText: Colors.white,
                                        onTap: () async {
                                          setState(() {
                                            Loading1 = true;
                                          });
                                          if (chosenvoucher.id != 'NA') {
                                            List<Voucher> newlist = [];
                                            for (int i = 0 ; i < currentAccount.voucherList.length ; i++) {
                                              if (chosenvoucher.id != currentAccount.voucherList[i].id) {
                                                newlist.add(currentAccount.voucherList[i]);
                                              }
                                            }
                                            await pushVoucherdata(newlist);
                                          }
                                          accountNormal shipper = accountNormal(id: "NA", avatarID: "NA", createTime: Time(second: 0, minute: 0, hour: 0, day: 0, month: 0, year: 0), status: 1, name: "NA", phoneNum: "NA", type: 0, locationHis: accountLocation(phoneNum: '', LocationID: '', Latitude: 0, Longitude: 0, firstText: '', secondaryText: ''), voucherList: [], totalMoney: 0, Area: '');

                                          catchOrder thiscatch = catchOrder(
                                              id: generateID(10),
                                              locationSet: widget.diemdon,
                                              locationGet: widget.diemtra,
                                              cost: cost,
                                              owner: currentAccount,
                                              shipper: shipper,
                                              status: 'A',
                                              endTime: Time(second: 0, minute: 0, hour: 0, day: 0, month: 0, year: 0),
                                              startTime: getCurrentTime(),
                                              cancelTime: Time(second: 0, minute: 0, hour: 0, day: 0, month: 0, year: 0),
                                              receiveTime: Time(second: 0, minute: 0, hour: 0, day: 0, month: 0, year: 0),
                                              type: 2
                                          );
                                          await pushCatchOrder(thiscatch);
                                          setState(() {
                                            Loading1 = false;
                                          });
                                        }, loading: Loading1,
                                      ),
                                    ),
                                  ),

                                  ///Nút vouvher
                                  Positioned(
                                    bottom: 10,
                                    right: 10,
                                    child: Container(
                                      width: screenWidth/2 - 20,
                                      height: screenHeight/15,
                                      child: ButtonType1(Height: screenHeight/10, Width: screenWidth/2 - 20, color: Color.fromARGB(255, 255, 247, 237), radiusBorder: 30, title: 'Ưu đãi', fontText: 'arial', colorText: Color.fromARGB(255, 255, 123, 64),
                                          onTap: () {
                                            chosenvoucher.id = 'NA';
                                            chosenvoucher.mincost = 0;
                                            chosenvoucher.totalmoney = 0;
                                            Navigator.push(context, MaterialPageRoute(builder:(context) => SCREENvoucherchosen(type: 2, distance: widget.Distance,)));
                                          }
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  ///Nút back
                  Positioned(
                    top: 10,
                    left: 10,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder:(context) => SCREENcarorder()));
                      },
                      child: Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.3),
                              spreadRadius: 5,
                              blurRadius: 7,
                              offset: Offset(0, 3),
                            ),
                          ],
                          borderRadius: BorderRadius.circular(20),
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: AssetImage('assets/image/backicon1.png'),
                          ),
                        ),
                      ),
                    ),
                  )

                ],
              ),
            )
        ),
      ),
      onWillPop: () async {
        return false;
      },
    );
  }
}
