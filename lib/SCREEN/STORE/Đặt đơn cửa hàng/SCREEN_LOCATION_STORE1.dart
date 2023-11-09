import 'dart:convert';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:http/http.dart' as http;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:xekomain/FINAL/finalClass.dart';
import 'package:xekomain/GENERAL/Order/foodOrder.dart';
import 'package:xekomain/GENERAL/Tool/Tool.dart';
import 'package:xekomain/OTHER/Button/Buttontype1.dart';
import 'package:xekomain/SCREEN/RESTAURANT/SCREENshopmain.dart';
import 'package:xekomain/SCREEN/STORE/SCREENstoremain.dart';

import '../../../GENERAL/NormalUser/accountLocation.dart';
import '../../../GENERAL/NormalUser/accountNormal.dart';
import '../../../GENERAL/Product/Voucher.dart';
import '../../../GENERAL/Tool/Time.dart';
import '../../../GENERAL/utils/utils.dart';
import '../../INUSER/SCREEN_MAIN/SCREENmain.dart';
import '../../VOUCHER/SCREENvoucherchosen.dart';

class SCREENlocationstore1 extends StatefulWidget {
  final double Distance;
  final accountLocation diemlay;
  final accountLocation diemtra;
  const SCREENlocationstore1({Key? key, required this.Distance, required this.diemlay, required this.diemtra}) : super(key: key);

  @override
  State<SCREENlocationstore1> createState() => _SCREENlocationbikest2State();
}

class _SCREENlocationbikest2State extends State<SCREENlocationstore1> {
  late GoogleMapController mapController;
  final vouchercontroller = TextEditingController();
  double _originLatitude = 0, _originLongitude = 0;
  double _destLatitude = 0, _destLongitude = 0;
  Map<MarkerId, Marker> markers = {};
  Map<PolylineId, Polyline> polylines = {};
  List<LatLng> polylineCoordinates = [];
  PolylinePoints polylinePoints = PolylinePoints();
  String googleAPiKey = "AIzaSyBsVQaVVMXw-y3QgvCWwJe02FWkhqP_wRA";
  bool Loading1 = false;
  double total = 0;
  bool isLoading = false;
  String voucherMoney = '0đ';
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
    if (distance >= FoodCost.departKM) {
      cost += FoodCost.departKM.toInt() * FoodCost.departCost.toInt();
      distance -= FoodCost.departKM;
      cost = cost + ((distance - FoodCost.departKM) * FoodCost.perKMcost).toInt();
    } else {
      cost += (distance * FoodCost.departCost).toInt();
    }
    return cost;
  }

  Future<void> pushfoodOrder(foodOrder foodorder) async {
    try {
      DatabaseReference databaseRef = FirebaseDatabase.instance.reference();
      await databaseRef.child('Order/productOrder').child(foodorder.id).set(foodorder.toJson());
      storeList.clear();
      if (mounted) {
        toastMessage('Đặt đơn thành công , vui lòng kiểm tra lịch sử');
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SCREENmain()));
      }
    } catch (error) {
      print('Đã xảy ra lỗi khi đẩy catchOrder: $error');
      throw error;
    }
  }

  void VoucherChange() {
    if (chosenvoucher.id != '') {
      voucherMoney = getStringNumber(chosenvoucher.totalmoney) + 'đ';
    } else {
      voucherMoney = '0đ';
    }
  }

  Future<void> getData1(String id) async {
    final reference = FirebaseDatabase.instance.reference();
    await reference.child("VoucherStorage/" + id).onValue.listen((event) {
      final dynamic orders = event.snapshot.value;
      if (orders != null) {
        Voucher a = Voucher.fromJson(orders);
        if (a.useCount < a.maxCount) {
          if (compareTimes(Time(second: DateTime.now().second, minute: DateTime.now().minute, hour: DateTime.now().hour, day: DateTime.now().day, month: DateTime.now().month, year: DateTime.now().year), a.endTime) && compareTimes(a.startTime, Time(second: DateTime.now().second, minute: DateTime.now().minute, hour: DateTime.now().hour, day: DateTime.now().day, month: DateTime.now().month, year: DateTime.now().year))) {
            if (a.mincost <= getCost(widget.Distance)) {
              if (a.totalmoney < getCost(widget.Distance)) {
                if (a.LocationId == currentAccount.Area) {
                  chosenvoucher.totalmoney = a.totalmoney;
                  chosenvoucher.id = a.id;
                  chosenvoucher.startTime = a.startTime;
                  chosenvoucher.endTime = a.endTime;
                  chosenvoucher.LocationId = a.LocationId;
                  chosenvoucher.tenchuongtrinh = a.tenchuongtrinh;
                  chosenvoucher.useCount = a.useCount;
                  VoucherChange();
                  Navigator.of(context).pop();
                  setState(() {

                  });
                } else {
                  toastMessage('Voucher không áp dụng cho khu vực này');
                }
              } else {
                toastMessage('Giá trị đơn phái lớn hơn số tiền giảm');
              }
            } else {
              toastMessage('Đơn của bạn chưa đủ điều kiện áp dụng');
            }
          } else {
            toastMessage('Voucher không trong thời hạn dùng');
          }
        } else {
          toastMessage('Voucher này đã hết lượt dùng');
        }

      }

      setState(() {

      });
    });
  }

  Future<void> pushVoucherData(int count, String id) async {
    try {
      DatabaseReference databaseRef = FirebaseDatabase.instance.reference();
      await databaseRef.child("VoucherStorage/" + id).child('useCount').set(count);
      if (mounted) {
        toastMessage('Đặt đơn thành công , vui lòng kiểm tra lịch sử');
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SCREENmain()));
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

    _originLatitude = widget.diemlay.Latitude;
    _originLongitude = widget.diemlay.Longitude;
    _destLatitude = widget.diemtra.Latitude;
    _destLongitude = widget.diemtra.Longitude;


    for (int i = 0 ; i < storeList.length ; i++) {
      total = total + storeList[i].cost;
    }

    if (chosenvoucher.id != 'NA') {
      total = total - chosenvoucher.totalmoney;
    }

    _addMarker(LatLng(_originLatitude, _originLongitude), "origin", BitmapDescriptor.defaultMarker);

    _addMarker(LatLng(_destLatitude, _destLongitude), "destination", BitmapDescriptor.defaultMarkerWithHue(90));
    _getPolyline();
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
                      height: screenHeight/2,
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
                              "Đơn đi chợ hộ ( " + double.parse(widget.Distance.toStringAsFixed(1)).toString() + " km )",
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
                                              image: AssetImage('assets/image/bikeLogo1.png')
                                          )
                                      ),
                                    ),
                                  ),

                                  Positioned(
                                    top: (screenHeight/10)/3,
                                    left: 10 + screenHeight/14 + 15,
                                    child: Container(
                                      child: Text(
                                        'Phí ship',
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
                                    bottom: (screenHeight/10)/5,
                                    right: 10,
                                    child: Text(
                                      "- " + voucherMoney,
                                      style: TextStyle(
                                          fontFamily: 'arial',
                                          color: Colors.green,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14
                                      ),
                                    ),
                                  ),

                                  Positioned(
                                    top: (screenHeight/10)/3,
                                    right: 10,
                                    child: Text(
                                      getStringNumber(getCost(widget.Distance).toDouble()) + "đ",
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
                            top: 50 +  screenHeight/10 + 10,
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
                                              image: AssetImage('assets/image/linhtinh5.png')
                                          )
                                      ),
                                    ),
                                  ),

                                  Positioned(
                                    top: (screenHeight/10)/3,
                                    left: 10 + screenHeight/14 + 15,
                                    child: Container(
                                      child: Text(
                                        'Giá trị đơn',
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
                                      getStringNumber(total) + "đ",
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


                                  ///Nút đặt đơn
                                  Positioned(
                                    bottom: 10,
                                    left: 10,
                                    child: Container(
                                      width: screenWidth/2 - 20,
                                      height: screenHeight/15,
                                      child: ButtonType1(Height: screenHeight/10, Width: screenWidth/2 - 20, color: Color.fromARGB(255, 244, 164, 84), radiusBorder: 30, title: 'Đặt đơn', fontText: 'arial', colorText: Colors.white,
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
                                        }

                                            foodOrder foodorder = foodOrder(
                                                id: generateID(12),
                                                locationSet: widget.diemlay,
                                                locationGet: widget.diemtra,
                                                cost: total,
                                                owner: currentAccount,
                                                shipper: accountNormal(id: "NA", avatarID: "NA", createTime: Time(second: 0, minute: 0, hour: 0, day: 0, month: 0, year: 0), status: 1, name: "NA", phoneNum: "NA", type: 0, locationHis: accountLocation(phoneNum: '', LocationID: '', Latitude: 0, Longitude: 0, firstText: '', secondaryText: ''), voucherList: [], totalMoney: 0, Area: ''),
                                                status: 'A',
                                                endTime: Time(second: 0, minute: 0, hour: 0, day: 0, month: 0, year: 0),
                                                startTime: getCurrentTime(),
                                                productList: storeList,
                                                cancelTime: Time(second: 0, minute: 0, hour: 0, day: 0, month: 0, year: 0),
                                                receiveTime: Time(second: 0, minute: 0, hour: 0, day: 0, month: 0, year: 0),
                                                shipcost: getCost(widget.Distance).toDouble(),
                                                voucher: chosenvoucher,
                                                costFee: bikeCost,
                                                costBiker: bikeCost

                                            );
                                        if (chosenvoucher.id != '') {
                                          await pushVoucherData(chosenvoucher.useCount + 1, chosenvoucher.id);
                                        }
                                        await pushfoodOrder(foodorder);
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
                                            vouchercontroller.clear();
                                            chosenvoucher.changeToDefault();
                                            VoucherChange();
                                            setState(() {

                                            });
                                            showDialog(
                                                context: context,
                                                builder: (BuildContext context) {
                                                  return AlertDialog(
                                                    content: Container(
                                                        width: screenWidth,
                                                        height: 90,
                                                        child: Stack(
                                                          children: <Widget>[
                                                            Positioned(
                                                              top: 0,
                                                              left: 0,
                                                              child: Container(
                                                                height: 15,
                                                                child: AutoSizeText(
                                                                  'Nhập mã voucher',
                                                                  style: TextStyle(
                                                                      fontSize: 100,
                                                                      color: Color.fromARGB(255, 244, 164, 84),
                                                                      fontWeight: FontWeight.bold
                                                                  ),
                                                                ),
                                                              ),
                                                            ),

                                                            Positioned(
                                                              top: 50,
                                                              left: 0,
                                                              child: Container(
                                                                height: 40,
                                                                width: screenWidth/1.5,
                                                                decoration: BoxDecoration(
                                                                    borderRadius: BorderRadius.circular(10),
                                                                    border: Border.all(
                                                                        color: Colors.orange,
                                                                        width: 1
                                                                    )
                                                                ),
                                                                child: Padding(
                                                                  padding: EdgeInsets.only(left: 10),
                                                                  child: Form(
                                                                    child: TextFormField(
                                                                      controller: vouchercontroller,
                                                                      style: TextStyle(
                                                                        color: Colors.black,
                                                                        fontFamily: 'arial',
                                                                      ),

                                                                      decoration: InputDecoration(
                                                                        border: InputBorder.none,
                                                                        hintText: 'Nhập mã voucher',
                                                                        hintStyle: TextStyle(
                                                                          color: Colors.grey,
                                                                          fontFamily: 'arial',
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            )
                                                          ],
                                                        )
                                                    ),

                                                    actions: <Widget>[
                                                      TextButton(
                                                        child: isLoading ? CircularProgressIndicator() : Text('Xác nhận'),
                                                        onPressed: isLoading ? null : () async {
                                                          setState(() {
                                                            isLoading = true;
                                                          });
                                                          if (vouchercontroller.text.isNotEmpty) {
                                                            await getData1(vouchercontroller.text.toString());
                                                          } else {
                                                            toastMessage('Vui lòng nhập mã');
                                                          }
                                                          setState(() {
                                                            isLoading = false; // Dừng hiển thị loading
                                                          });
                                                        },
                                                      ),

                                                      TextButton(
                                                        child: Text('Hủy'),
                                                        onPressed: () {
                                                          chosenvoucher.changeToDefault();
                                                          vouchercontroller.clear();
                                                          VoucherChange();
                                                          Navigator.of(context).pop();
                                                          setState(() {

                                                          });
                                                        },
                                                      ),
                                                    ],
                                                  );
                                                });
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
                        Navigator.push(context, MaterialPageRoute(builder:(context) => SCREENstoremain()));
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
