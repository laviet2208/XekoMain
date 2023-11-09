import 'package:auto_size_text/auto_size_text.dart';
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
import '../../../GENERAL/Order/Cost.dart';
import '../../../GENERAL/Product/Voucher.dart';
import '../../../GENERAL/Tool/Time.dart';
import '../../../GENERAL/Tool/Tool.dart';

class SCREENwaitdriver extends StatefulWidget {
  final accountLocation diemdon;
  final accountLocation diemtra;
  const SCREENwaitdriver({Key? key, required this.diemdon, required this.diemtra,}) : super(key: key);

  @override
  State<SCREENwaitdriver> createState() => _SCREENwaitdriverState();
}

class _SCREENwaitdriverState extends State<SCREENwaitdriver> {
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
      type: 1,
      voucher: Voucher(id: 'NA', totalmoney: 0, mincost: 0, startTime: Time(second: 0, minute: 0, hour: 0, day: 0, month: 0, year: 0), endTime: Time(second: 0, minute: 0, hour: 0, day: 0, month: 0, year: 0), useCount: 0, maxCount: 0, tenchuongtrinh: '', LocationId: '', type: 1, Otype: ''),
      costFee: Cost(departKM: 0, departCost: 0, perKMcost: 0, discount: 0)
  );

  String startTime = "";
  String locationset = "";
  String locationget = "";
  String Tmoney = "";
  String status = "";
  String previous = "";

  void getData(String id) {
    final reference = FirebaseDatabase.instance.reference();
    reference.child('Order/catchOrder').onValue.listen((event) {
      final dynamic catchorder = event.snapshot.value;
      catchorder.forEach((key, value) {
        if (accountNormal.fromJson(value['owner']).id == id && (value['status'].toString() == 'A' || value['status'].toString() == 'B' || value['status'].toString() == 'C')) {
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
                status = 'đang đợi tài xế , bạn có thể hủy đơn';
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
      await databaseRef.child('Order/catchOrder/' + thiscatch.id + "/status").set(status);
      databaseRef = FirebaseDatabase.instance.reference();
      await databaseRef.child('Order/catchOrder/' + thiscatch.id + "/cancelTime").set(getCurrentTime().toJson());
      toastMessage('đã hủy đơn');
      Navigator.push(context, MaterialPageRoute(builder:(context) => SCREENmain()));
    } catch (error) {
      print('Đã xảy ra lỗi khi đẩy catchOrder: $error');
      throw error;
    }
  }

  void listenToCatchOrderStatus(String id) {
    DatabaseReference catchOrderRef = FirebaseDatabase.instance.reference().child('Order/catchOrder/' + id);

    catchOrderRef.onChildChanged.listen((event) {
      final dynamic catchOrder = event.snapshot.value;

      String status = catchOrder['status'];
      if (status == 'D') {
        // Xử lý khi status chuyển sang 'D'
        print('Status changed to D');
      }
    });
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _originLatitude = widget.diemdon.Latitude;
    _originLongitude = widget.diemdon.Longitude;
    _destLatitude = widget.diemtra.Latitude;
    _destLongitude = widget.diemtra.Longitude;
    getData(currentAccount.id);
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
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 245, 245, 245)
              ),
              child: ListView(
                children: [
                  Container(
                    width: screenWidth,
                    height: 50,
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2), // màu của shadow
                          spreadRadius: 5, // bán kính của shadow
                          blurRadius: 7, // độ mờ của shadow
                          offset: Offset(0, 3), // vị trí của shadow
                        ),
                      ],
                      color: Colors.white
                    ),
                    child: Stack(
                      children: <Widget>[
                        Positioned(
                          bottom: 5,
                          left: 10,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(context, MaterialPageRoute(builder:(context) => SCREENmain()));
                            },
                            child: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: AssetImage('assets/image/backicon1.png')
                                  )
                              ),
                            ),
                          ),
                        ),

                        Positioned(
                            bottom: 14,
                            left: 60,
                            child: Text(
                              'Thông tin chuyến đi',
                              style: TextStyle(
                                  fontWeight: FontWeight.normal,
                                  fontSize: 20,
                                  fontFamily: 'arial',
                                  color: Colors.black
                              ),
                            )
                        ),
                      ],
                    ),
                  ),

                  Container(
                    height: screenHeight/2.5,
                    width: screenWidth,
                    child: GoogleMap(
                      initialCameraPosition: CameraPosition(
                          target: LatLng(_originLatitude, _originLongitude), zoom: 10),
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

                  Container(height: 20,),

                  Padding(
                    padding: EdgeInsets.only(left: 20, right: 20),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20)
                      ),

                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(height: 10,),

                          Container(
                            height: 30,
                            child: Row(
                              children: [
                                Container(
                                  width: 10,
                                ),

                                Container(
                                  width: 30,
                                  height: 30,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: AssetImage('assets/image/ghichu.png')
                                    )
                                  ),
                                ),

                                Container(
                                  width: 10,
                                ),

                                Padding(
                                  padding: EdgeInsets.only(top: 7, bottom: 7),
                                  child: Container(
                                    height: 30,
                                    width: screenWidth - 40 - 30 - 30,
                                    child: AutoSizeText(
                                      'Đơn ' + currentAccount.id,
                                      style: TextStyle(
                                        fontFamily: 'arial',
                                        color: Color.fromARGB(255, 255, 123, 64),
                                        fontSize: 200,
                                        fontWeight: FontWeight.bold
                                      ),
                                    ),
                                  ),
                                ),

                                Container(
                                  width: 10,
                                ),


                              ],
                            ),
                          ),

                          Container(height: 10,),

                          Container(
                            height: 30,
                            child: Row(
                              children: [
                                Container(
                                  width: 10,
                                ),

                                Container(
                                  width: 30,
                                  height: 30,
                                  decoration: BoxDecoration(
                                      image: DecorationImage(
                                          fit: BoxFit.cover,
                                          image: AssetImage('assets/image/clock.png')
                                      )
                                  ),
                                ),

                                Container(
                                  width: 10,
                                ),

                                Padding(
                                  padding: EdgeInsets.only(top: 7, bottom: 7),
                                  child: Container(
                                    height: 30,
                                    width: screenWidth - 40 - 30 - 30,
                                    child: AutoSizeText(
                                      'Đặt lúc : ' + getAllTimeString(thiscatch.startTime),
                                      style: TextStyle(
                                          fontFamily: 'arial',
                                          color: Colors.black,
                                          fontSize: 200,
                                          fontWeight: FontWeight.normal
                                      ),
                                    ),
                                  ),
                                ),

                                Container(
                                  width: 10,
                                ),


                              ],
                            ),
                          ),

                          Container(height: 10,),

                          Container(
                            height: 30,
                            child: Row(
                              children: [
                                Container(
                                  width: 10,
                                ),

                                Container(
                                  width: 30,
                                  height: 30,
                                  decoration: BoxDecoration(
                                      image: DecorationImage(
                                          fit: BoxFit.cover,
                                          image: AssetImage('assets/image/minicar.png')
                                      )
                                  ),
                                ),

                                Container(
                                  width: 10,
                                ),

                                Padding(
                                  padding: EdgeInsets.only(top: 7, bottom: 7),
                                  child: Container(
                                    height: 30,
                                    width: screenWidth - 40 - 30 - 30,
                                    child: AutoSizeText(
                                      'Taxi 4 chỗ',
                                      style: TextStyle(
                                          fontFamily: 'arial',
                                          color: Color.fromARGB(255, 255, 123, 64),
                                          fontSize: 200,
                                          fontWeight: FontWeight.bold
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          Container(height: 10,),

                          Padding(
                            padding: EdgeInsets.only(left: 10, right: 10),
                            child: Container(
                              height: 1,
                              decoration: BoxDecoration(
                                  color: Colors.grey
                              ),
                            ),
                          ),

                          Container(height: 10,),

                          Container(
                            height: 30,
                            child: Row(
                              children: [
                                Container(
                                  width: 10,
                                ),

                                Padding(
                                  padding: EdgeInsets.only(top: 7, bottom: 7),
                                  child: Container(
                                    height: 30,
                                    width: (screenWidth - 40 - 20)/2,
                                    child: AutoSizeText(
                                      'TỔNG CỘNG',
                                      style: TextStyle(
                                          fontFamily: 'arial',
                                          color: Colors.grey,
                                          fontSize: 200,
                                          fontWeight: FontWeight.bold
                                      ),
                                    ),
                                  ),
                                ),

                                Padding(
                                  padding: EdgeInsets.only(top: 7, bottom: 7),
                                  child: Container(
                                    height: 30,
                                    width: (screenWidth - 40 - 20)/2,
                                    alignment: Alignment.centerRight,
                                    child: AutoSizeText(
                                      getStringNumber(thiscatch.cost) + '.đ',
                                      style: TextStyle(
                                          fontFamily: 'arial',
                                          color: Colors.black,
                                          fontSize: 200,
                                          fontWeight: FontWeight.normal
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          Container(height: 10,),

                          Padding(
                            padding: EdgeInsets.only(left: 10, right: 10),
                            child: Container(
                              height: 1,
                              decoration: BoxDecoration(
                                  color: Colors.deepOrange
                              ),
                            ),
                          ),

                          Container(height: 10,),

                          Container(
                            height: 30,
                            child: Row(
                              children: [
                                Container(
                                  width: 10,
                                ),

                                Padding(
                                  padding: EdgeInsets.only(top: 7, bottom: 7),
                                  child: Container(
                                    height: 30,
                                    width: (screenWidth - 40 - 20)/2,
                                    child: AutoSizeText(
                                      'Chi phí vận chuyển',
                                      style: TextStyle(
                                          fontFamily: 'arial',
                                          color: Colors.grey,
                                          fontSize: 200,
                                          fontWeight: FontWeight.bold
                                      ),
                                    ),
                                  ),
                                ),

                                Padding(
                                  padding: EdgeInsets.only(top: 7, bottom: 7),
                                  child: Container(
                                    height: 30,
                                    width: (screenWidth - 40 - 20)/2,
                                    alignment: Alignment.centerRight,
                                    child: RichText(
                                      text: TextSpan(
                                        children: [
                                          TextSpan(
                                            text: getStringNumber(thiscatch.cost) + "đ",
                                            style: TextStyle(
                                              fontFamily: 'arial',
                                              color: Colors.black,
                                              fontWeight: FontWeight.normal,
                                              fontSize: 14,
                                            ),
                                          ),
                                          TextSpan(
                                            text: " - " + getStringNumber(thiscatch.voucher.totalmoney) + "đ",
                                            style: TextStyle(
                                              fontFamily: 'arial',
                                              color: Colors.red, // Đặt màu đỏ cho phần này
                                              fontWeight: FontWeight.normal,
                                              fontSize: 14,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          Container(height: 10,),
                        ],
                      ),
                    ),
                  ),

                  Container(height: 20,),

                  Padding(
                    padding: EdgeInsets.only(left: 20, right: 20),
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20)
                      ),

                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(height: 10,),

                          Padding(
                            padding: EdgeInsets.only(left: 15, right: 15),
                            child: Container(
                              height: 30,
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding: EdgeInsets.only(top: 6, bottom: 6),
                                child: AutoSizeText(
                                  'Tình trạng đơn',
                                  style: TextStyle(
                                      fontFamily: 'arial',
                                      color: Colors.black,
                                      fontSize: 200,
                                      fontWeight: FontWeight.bold
                                  ),
                                ),
                              ),
                            ),
                          ),

                          Container(height: 10,),

                          Container(
                            height: 30,
                            child: Row(
                              children: [
                                Container(
                                  width: 10,
                                ),

                                Container(
                                  width: 30,
                                  height: 30,
                                  decoration: BoxDecoration(
                                      image: DecorationImage(
                                          fit: BoxFit.cover,
                                          image: (thiscatch.status == 'A') ? AssetImage('assets/image/redcircle.png') : AssetImage('assets/image/greycircle.png')
                                      )
                                  ),
                                ),

                                Container(
                                  width: 10,
                                ),

                                Padding(
                                  padding: EdgeInsets.only(top: 7, bottom: 7),
                                  child: Container(
                                    height: 30,
                                    width: screenWidth - 40 - 30 - 30,
                                    child: AutoSizeText(
                                      'Đang đợi tài xế , có thể hủy đơn',
                                      style: TextStyle(
                                          fontFamily: 'arial',
                                          color: Colors.black,
                                          fontSize: 200,
                                          fontWeight: (thiscatch.status == 'A') ?  FontWeight.bold : FontWeight.normal
                                      ),
                                    ),
                                  ),
                                ),

                                Container(
                                  width: 10,
                                ),


                              ],
                            ),
                          ),

                          Container(
                            height: 20,
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: EdgeInsets.only(left: 25, top: 4, bottom: 4),
                              child: Container(
                                alignment: Alignment.centerLeft,
                                width: 1,
                                decoration: BoxDecoration(
                                  color: Colors.grey
                                ),
                              ),
                            ),
                          ),

                          Container(
                            height: 30,
                            child: Row(
                              children: [
                                Container(
                                  width: 10,
                                ),

                                Container(
                                  width: 30,
                                  height: 30,
                                  decoration: BoxDecoration(
                                      image: DecorationImage(
                                          fit: BoxFit.cover,
                                          image: (thiscatch.status == 'B') ? AssetImage('assets/image/redcircle.png') : AssetImage('assets/image/greycircle.png')
                                      )
                                  ),
                                ),

                                Container(
                                  width: 10,
                                ),

                                Padding(
                                  padding: EdgeInsets.only(top: 7, bottom: 7),
                                  child: Container(
                                    height: 30,
                                    width: screenWidth - 40 - 30 - 30,
                                    child: AutoSizeText(
                                      'Tài xế ' + thiscatch.shipper.name + ' đang đến',
                                      style: TextStyle(
                                          fontFamily: 'arial',
                                          color: Colors.black,
                                          fontSize: 200,
                                          fontWeight: (thiscatch.status == 'B') ?  FontWeight.bold : FontWeight.normal
                                      ),
                                    ),
                                  ),
                                ),

                                Container(
                                  width: 10,
                                ),


                              ],
                            ),
                          ),

                          Container(
                            height: 20,
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: EdgeInsets.only(left: 25, top: 4, bottom: 4),
                              child: Container(
                                alignment: Alignment.centerLeft,
                                width: 1,
                                decoration: BoxDecoration(
                                    color: Colors.grey
                                ),
                              ),
                            ),
                          ),

                          Container(
                            height: 30,
                            child: Row(
                              children: [
                                Container(
                                  width: 10,
                                ),

                                Container(
                                  width: 30,
                                  height: 30,
                                  decoration: BoxDecoration(
                                      image: DecorationImage(
                                          fit: BoxFit.cover,
                                          image: (thiscatch.status == 'C') ? AssetImage('assets/image/redcircle.png') : AssetImage('assets/image/greycircle.png')
                                      )
                                  ),
                                ),

                                Container(
                                  width: 10,
                                ),

                                Padding(
                                  padding: EdgeInsets.only(top: 7, bottom: 7),
                                  child: Container(
                                    height: 30,
                                    width: screenWidth - 40 - 30 - 30,
                                    child: AutoSizeText(
                                      'Hành trình bắt đầu ',
                                      style: TextStyle(
                                          fontFamily: 'arial',
                                          color: Colors.black,
                                          fontSize: 200,
                                          fontWeight: (thiscatch.status == 'C') ?  FontWeight.bold : FontWeight.normal
                                      ),
                                    ),
                                  ),
                                ),

                                Container(
                                  width: 10,
                                ),


                              ],
                            ),
                          ),

                          Container(
                            height: 20,
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: EdgeInsets.only(left: 25, top: 4, bottom: 4),
                              child: Container(
                                alignment: Alignment.centerLeft,
                                width: 1,
                                decoration: BoxDecoration(
                                    color: Colors.grey
                                ),
                              ),
                            ),
                          ),

                          Container(
                            height: 30,
                            child: Row(
                              children: [
                                Container(
                                  width: 10,
                                ),

                                Container(
                                  width: 30,
                                  height: 30,
                                  decoration: BoxDecoration(
                                      image: DecorationImage(
                                          fit: BoxFit.cover,
                                          image: (thiscatch.status == 'E' || thiscatch.status == 'F' || thiscatch.status == 'G' || thiscatch.status == 'D') ? AssetImage('assets/image/redcircle.png') : AssetImage('assets/image/greycircle.png')
                                      )
                                  ),
                                ),

                                Container(
                                  width: 10,
                                ),

                                Padding(
                                  padding: EdgeInsets.only(top: 7, bottom: 7),
                                  child: Container(
                                    height: 30,
                                    width: screenWidth - 40 - 30 - 30,
                                    child: AutoSizeText(
                                      'Hoàn thành ',
                                      style: TextStyle(
                                          fontFamily: 'arial',
                                          color: Colors.black,
                                          fontSize: 200,
                                          fontWeight: (thiscatch.status == 'E' || thiscatch.status == 'F' || thiscatch.status == 'G' || thiscatch.status == 'D') ?  FontWeight.bold : FontWeight.normal
                                      ),
                                    ),
                                  ),
                                ),

                                Container(
                                  width: 10,
                                ),


                              ],
                            ),
                          ),

                          Container(height: 20,),
                        ],
                      ),
                    ),
                  ),

                  Container(height: 20,),

                  Padding(
                    padding: EdgeInsets.only(left: 20, right: 20),
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20)
                      ),

                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(height: 10,),

                          Container(
                            height: 30,
                            child: Row(
                              children: [
                                Container(
                                  width: 10,
                                ),

                                Container(
                                  width: 30,
                                  height: 30,
                                  decoration: BoxDecoration(
                                      image: DecorationImage(
                                          fit: BoxFit.cover,
                                          image: AssetImage('assets/image/orangecircle.png')
                                      )
                                  ),
                                ),

                                Container(
                                  width: 10,
                                ),

                                Padding(
                                  padding: EdgeInsets.only(top: 7, bottom: 7),
                                  child: Container(
                                    height: 30,
                                    width: screenWidth - 40 - 30 - 30,
                                    child: AutoSizeText(
                                      'Điểm đón',
                                      style: TextStyle(
                                          fontFamily: 'arial',
                                          color: Colors.black,
                                          fontSize: 200,
                                          fontWeight: FontWeight.normal
                                      ),
                                    ),
                                  ),
                                ),

                                Container(
                                  width: 10,
                                ),


                              ],
                            ),
                          ),

                          Padding(
                            padding: EdgeInsets.only(left: 50, right: 10),
                            child: Container(
                              child: Text(
                                thiscatch.locationSet.firstText + ',' + thiscatch.locationSet.secondaryText,
                                style: TextStyle(
                                    fontFamily: 'arial',
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold
                                ),
                              ),
                            ),
                          ),

                          Container(height: 15,),

                          Container(
                            height: 30,
                            child: Row(
                              children: [
                                Container(
                                  width: 10,
                                ),

                                Container(
                                  width: 30,
                                  height: 30,
                                  decoration: BoxDecoration(
                                      image: DecorationImage(
                                          fit: BoxFit.cover,
                                          image: AssetImage('assets/image/redlocation.png')
                                      )
                                  ),
                                ),

                                Container(
                                  width: 10,
                                ),

                                Padding(
                                  padding: EdgeInsets.only(top: 7, bottom: 7),
                                  child: Container(
                                    height: 30,
                                    width: screenWidth - 40 - 30 - 30,
                                    child: AutoSizeText(
                                      'Điểm đến',
                                      style: TextStyle(
                                          fontFamily: 'arial',
                                          color: Colors.black,
                                          fontSize: 200,
                                          fontWeight: FontWeight.normal
                                      ),
                                    ),
                                  ),
                                ),

                                Container(
                                  width: 10,
                                ),
                              ],
                            ),
                          ),

                          Padding(
                            padding: EdgeInsets.only(left: 50, right: 10),
                            child: Container(
                              child: Text(
                                thiscatch.locationGet.firstText + ',' + thiscatch.locationGet.secondaryText,
                                style: TextStyle(
                                    fontFamily: 'arial',
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold
                                ),
                              ),
                            ),
                          ),

                          Container(height: 20,),
                        ],
                      ),
                    ),
                  ),

                  Container(height: 20,),

                  Padding(
                    padding: EdgeInsets.only(left: 20, right: 20),
                    child: ButtonType1(Height: (thiscatch.status == "A" || thiscatch.status == "B") ? screenHeight/15 : 0, Width: screenWidth, color: Color.fromARGB(255, 244, 164, 84), radiusBorder: 30, title: 'Hủy chuyến', fontText: 'arial', colorText: Colors.white,
                        onTap: () async {
                          if (thiscatch.status == "A") {
                            await updateData('E');
                          }

                          if (thiscatch.status == "B") {
                            await updateData('G');
                          }
                        }
                    ),
                  ),

                  Container(height: 20,),
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
