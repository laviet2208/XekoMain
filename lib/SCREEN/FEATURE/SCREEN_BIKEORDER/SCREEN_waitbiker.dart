import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:xekomain/GENERAL/Order/catchOrder.dart';
import 'package:xekomain/GENERAL/utils/utils.dart';
import 'package:xekomain/OTHER/Button/Buttontype1.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:xekomain/SCREEN/INUSER/SCREEN_MAIN/SCREENmain.dart';

import '../../../FINAL/finalClass.dart';
import '../../../GENERAL/NormalUser/accountLocation.dart';
import '../../../GENERAL/NormalUser/accountNormal.dart';
import '../../../GENERAL/Tool/Time.dart';
import '../../../GENERAL/Tool/Tool.dart';

class SCREENwaitbiker extends StatefulWidget {
  final accountLocation diemdon;
  final accountLocation diemtra;
  const SCREENwaitbiker({Key? key, required this.diemdon, required this.diemtra}) : super(key: key);

  @override
  State<SCREENwaitbiker> createState() => _SCREENwaitbikerState();
}

class _SCREENwaitbikerState extends State<SCREENwaitbiker> {
  late GoogleMapController mapController;
  double _originLatitude = 0, _originLongitude = 0;
  double _destLatitude = 0, _destLongitude = 0;
  Map<MarkerId, Marker> markers = {};
  Map<PolylineId, Polyline> polylines = {};
  List<LatLng> polylineCoordinates = [];
  PolylinePoints polylinePoints = PolylinePoints();
  String googleAPiKey = "AIzaSyBsVQaVVMXw-y3QgvCWwJe02FWkhqP_wRA";
  catchOrder thiscatch = catchOrder(
      id: generateID(10),
      locationSet: accountLocation(phoneNum: "NA", LocationID: "NA", Latitude: -1, Longitude: -1, firstText: "NA", secondaryText: "NA"),
      locationGet: accountLocation(phoneNum: "NA", LocationID: "NA", Latitude: -1, Longitude: -1, firstText: "NA", secondaryText: "NA"),
      cost: -1,
      owner: accountNormal(id: "NA", avatarID: "NA", createTime: Time(second: 0, minute: 0, hour: 0, day: 0, month: 0, year: 0), status: 1, name: "NA", phoneNum: "NA", type: 0, locationHis: accountLocation(phoneNum: '', LocationID: '', Latitude: 0, Longitude: 0, firstText: '', secondaryText: ''), voucherList: [], totalMoney: 0, Area: ''),
      shipper: accountNormal(id: "NA", avatarID: "NA", createTime: Time(second: 0, minute: 0, hour: 0, day: 0, month: 0, year: 0), status: 1, name: "NA", phoneNum: "NA", type: 0, locationHis: accountLocation(phoneNum: '', LocationID: '', Latitude: 0, Longitude: 0, firstText: '', secondaryText: ''), voucherList: [], totalMoney: 0, Area: ''),
      status: 'o',
      endTime: Time(second: 0, minute: 0, hour: 0, day: 0, month: 0, year: 0),
      startTime: Time(second: 0, minute: 0, hour: 0, day: 0, month: 0, year: 0),
      cancelTime: Time(second: 0, minute: 0, hour: 0, day: 0, month: 0, year: 0),
      receiveTime: Time(second: 0, minute: 0, hour: 0, day: 0, month: 0, year: 0),
      type: 1
  );

  String startTime = "";
  String locationset = "";
  String locationget = "";
  String Tmoney = "";
  String status = "";
  String previous = "";

  void getData(String id) {
    final reference = FirebaseDatabase.instance.reference();
    reference.child('catchOrder').onValue.listen((event) {
      final dynamic catchorder = event.snapshot.value;
      catchorder.forEach((key, value) {
        if (accountNormal.fromJson(value['owner']).id == id) {
          if (value['status'].toString() == 'A' || value['status'].toString() == 'B' || value['status'].toString() == 'C') {
            catchOrder thisO = catchOrder.fromJson(value);
            thiscatch.shipper = thisO.shipper;
            thiscatch.locationSet = thisO.locationSet;
            thiscatch.cost = thisO.cost;
            thiscatch.locationGet = thisO.locationGet;
            thiscatch.id = thisO.id;
            thiscatch.owner = thisO.owner;
            thiscatch.status = thisO.status;
            thiscatch.endTime = thisO.endTime;
            thiscatch.startTime = thisO.startTime;
            thiscatch.cancelTime = thisO.cancelTime;
            thiscatch.receiveTime = thisO.receiveTime;
            thiscatch.type = thisO.type;
            previous = thisO.status;

            setState(() {
              _originLatitude = thisO.locationSet.Latitude;
              _originLongitude = thisO.locationSet.Longitude;
              _destLatitude = thisO.locationGet.Latitude;
              _destLongitude = thisO.locationGet.Longitude;
              _addMarker(LatLng(_originLatitude, _originLongitude), "origin", BitmapDescriptor.defaultMarker);

              _addMarker(LatLng(_destLatitude, _destLongitude), "destination", BitmapDescriptor.defaultMarkerWithHue(90));
              _getPolyline();
              startTime = getAllTimeString(thisO.startTime);

              if (thisO.locationSet.firstText == "NA") {
                locationset = thisO.locationSet.Longitude.toString() + " , " + thisO.locationSet.Latitude.toString();
              } else {
                locationset = compactString(30, thisO.locationSet.firstText);
              }

              if (thisO.locationGet.firstText == "NA") {
                locationget = thisO.locationGet.Longitude.toString() + " , " + thisO.locationGet.Latitude.toString();
              } else {
                locationget = compactString(30, thisO.locationGet.firstText);
              }

              Tmoney = getStringNumber(thisO.cost) + "đ";

              if (thisO.status == 'A') {
                status = 'đang đợi tài xế nhận đơn';
              }
              if (thisO.status == 'B') {
                status = getAllTimeString(thisO.receiveTime) + ' .Tài xế ' + thisO.shipper.name + " - " + thisO.shipper.phoneNum + ' đang đến , bạn có thể hủy đơn nhưng nghĩ kỹ nhé!';
              }
              if (thisO.status == 'C') {
                status = 'Đã đón bạn , hành trình bắt đầu! đơn được nhận lúc' + getAllTimeString(thisO.receiveTime);
              }

              if (thisO.status == 'E' || thisO.status == 'F' || thisO.status == 'G' || thisO.status == 'D') {
                Navigator.push(context, MaterialPageRoute(builder:(context) => SCREENmain()));
              }
            });
          }
        }
      }
      );
    });
  }

  Future<void> updateData(String status) async {
    try {
      DatabaseReference databaseRef = FirebaseDatabase.instance.reference();
      await databaseRef.child('catchOrder/' + thiscatch.id + "/status").set(status);
      databaseRef = FirebaseDatabase.instance.reference();
      await databaseRef.child('catchOrder/' + thiscatch.id + "/cancelTime").set(getCurrentTime().toJson());
      toastMessage('đã hủy đơn');
      Navigator.push(context, MaterialPageRoute(builder:(context) => SCREENmain()));
    } catch (error) {
      print('Đã xảy ra lỗi khi đẩy catchOrder: $error');
      throw error;
    }
  }

  void listenToCatchOrderStatus(String id) {
    DatabaseReference catchOrderRef = FirebaseDatabase.instance.reference().child('catchOrder/' + id);

    catchOrderRef.onChildChanged.listen((event) {
      final dynamic catchOrder = event.snapshot.value;

      String status = catchOrder['status'];
      if (status == 'D') {
        // Xử lý khi status chuyển sang 'D'
        print('Status changed to D');
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _originLatitude = widget.diemdon.Latitude;
    _originLongitude = widget.diemdon.Longitude;
    _destLatitude = widget.diemtra.Latitude;
    _destLongitude = widget.diemtra.Longitude;
    getData(currentAccount.id);
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
                      height: screenHeight/2.2,
                      width: screenWidth,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(25),
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
                            child: Text(
                              "Đợi tài xế xe máy phản hồi nhé!",
                              style: TextStyle(
                                color: Colors.black,
                                fontFamily: "arial",
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                          ),

                          Positioned(
                            top: 40,
                            left: 20,
                            child: Text(
                              "+) Thời gian đặt xe : " + startTime,
                              style: TextStyle(
                                color: Colors.blueAccent,
                                fontFamily: "arial",
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ),

                          Positioned(
                            top: 70,
                            left: 20,
                            child: Text(
                              "+) Đón tại : " + locationset,
                              style: TextStyle(
                                color: Colors.blueAccent,
                                fontFamily: "arial",
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ),

                          Positioned(
                            top: 100,
                            left: 20,
                            child: Text(
                              "+) Điểm đến : " + locationget,
                              style: TextStyle(
                                color: Colors.blueAccent,
                                fontFamily: "arial",
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ),

                          Positioned(
                            top: 130,
                            left: 20,
                            child: Text(
                              "+) Tổng tiền : " + Tmoney,
                              style: TextStyle(
                                color: Colors.orangeAccent,
                                fontFamily: "arial",
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ),

                          Positioned(
                            top: 160,
                            left: 20,
                            child: Container(
                              width: screenWidth - 40,
                              child: Text(
                                "+) Tình trạng : " + status,
                                style: TextStyle(
                                  color: Colors.orangeAccent,
                                  fontFamily: "arial",
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),

                          Positioned(
                            bottom: 0,
                            left: 0,
                            child: Container(
                              width: screenWidth,
                              height: screenHeight/9,
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
                                    bottom: 10,
                                    left: 10,
                                    child: Container(
                                      width: screenWidth/2 - 20,
                                      height: screenHeight/15,
                                      child: ButtonType1(Height: screenHeight/10, Width: screenWidth/2 - 20, color: Color.fromARGB(255, 244, 164, 84), radiusBorder: 30, title: 'Hủy chuyến', fontText: 'arial', colorText: Colors.white,
                                          onTap: () async {
                                              if (thiscatch.status == "A") {
                                                await updateData('E');
                                              }

                                              if (thiscatch.status == "B") {
                                                await updateData('F');
                                              }
                                          }
                                      ),
                                    ),
                                  ),

                                  Positioned(
                                    bottom: 10,
                                    right: 10,
                                    child: Container(
                                      width: screenWidth/2 - 20,
                                      height: screenHeight/15,
                                      child: ButtonType1(Height: screenHeight/10, Width: screenWidth/2 - 20, color: Color.fromARGB(255, 255, 247, 237), radiusBorder: 30, title: 'Về trang chủ', fontText: 'arial', colorText: Color.fromARGB(255, 255, 123, 64),
                                          onTap: () {
                                            Navigator.push(context, MaterialPageRoute(builder:(context) => SCREENmain()));
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
}
