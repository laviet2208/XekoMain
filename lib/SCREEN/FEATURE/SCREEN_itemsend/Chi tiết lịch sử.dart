import 'package:auto_size_text/auto_size_text.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:xekomain/GENERAL/Order/Cost.dart';
import 'package:xekomain/GENERAL/Order/Receiver.dart';
import 'package:xekomain/GENERAL/Order/catchOrder.dart';
import 'package:xekomain/GENERAL/Order/foodOrder.dart';
import 'package:xekomain/GENERAL/Order/item_details.dart';
import 'package:xekomain/GENERAL/Order/itemsendOrder.dart';
import 'package:xekomain/GENERAL/Product/Voucher.dart';
import 'package:xekomain/GENERAL/utils/utils.dart';
import 'package:xekomain/OTHER/Button/Buttontype1.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:xekomain/SCREEN/HISTORY/SCREENhistorysend.dart';
import '../../../FINAL/finalClass.dart';
import '../../../GENERAL/NormalUser/accountLocation.dart';
import '../../../GENERAL/NormalUser/accountNormal.dart';
import '../../../GENERAL/Tool/Time.dart';
import '../../../GENERAL/Tool/Tool.dart';

class SCREENitemHisDetail extends StatefulWidget {
  final String id;
  final accountLocation diemdon;
  final accountLocation diemtra;
  const SCREENitemHisDetail({Key? key, required this.id, required this.diemdon, required this.diemtra}) : super(key: key);

  @override
  State<SCREENitemHisDetail> createState() => _SCREENwaitbikerState();
}

class _SCREENwaitbikerState extends State<SCREENitemHisDetail> {
  late GoogleMapController mapController;
  double _originLatitude = 0, _originLongitude = 0;
  double _destLatitude = 0, _destLongitude = 0;
  Map<MarkerId, Marker> markers = {};
  Map<PolylineId, Polyline> polylines = {};
  List<LatLng> polylineCoordinates = [];
  PolylinePoints polylinePoints = PolylinePoints();
  String googleAPiKey = "AIzaSyBsVQaVVMXw-y3QgvCWwJe02FWkhqP_wRA";

  itemsendOrder thiscatch = itemsendOrder(
    id: '',
    cost: -1,
    owner: accountNormal(id: "NA", avatarID: "NA", createTime: Time(second: 0, minute: 0, hour: 0, day: 0, month: 0, year: 0), status: 1, name: "NA", phoneNum: "NA", type: 0, locationHis: accountLocation(phoneNum: '', LocationID: '', Latitude: 0, Longitude: 0, firstText: '', secondaryText: ''), voucherList: [], totalMoney: 0, Area: '', license: '', WorkStatus: 0),
    shipper: accountNormal(id: "NA", avatarID: "NA", createTime: Time(second: 0, minute: 0, hour: 0, day: 0, month: 0, year: 0), status: 1, name: "NA", phoneNum: "NA", type: 0, locationHis: accountLocation(phoneNum: '', LocationID: '', Latitude: 0, Longitude: 0, firstText: '', secondaryText: ''), voucherList: [], totalMoney: 0, Area: '', license: '', WorkStatus: 0), status: '',
    locationset: accountLocation(phoneNum: "NA", LocationID: "NA", Latitude: -1, Longitude: -1, firstText: "NA", secondaryText: "NA"), receiver: Receiver(location: accountLocation(phoneNum: "NA", LocationID: "NA", Latitude: -1, Longitude: -1, firstText: "NA", secondaryText: "NA"), locationNote: '', name: '', phoneNum: '', note: ''),
    itemdetails: item_details(weight: 0, type: '', codFee: 0),
    voucher: Voucher(id: 'NA', totalmoney: 0, mincost: 0, startTime: Time(second: 0, minute: 0, hour: 0, day: 0, month: 0, year: 0), endTime: Time(second: 0, minute: 0, hour: 0, day: 0, month: 0, year: 0), useCount: 0, maxCount: 0, tenchuongtrinh: '', LocationId: '', type: 1, Otype: '', perCustom: 0, CustomList: [], maxSale: 0),
    costFee: Cost(departKM: 0, departCost: 0, perKMcost: 0, discount: 0),S1time: getCurrentTime(), S2time: getCurrentTime(),S3time: getCurrentTime(), S4time: getCurrentTime(),);

  String startTime = "";
  String locationset = "";
  String locationget = "";
  String Tmoney = "";
  String finalStatus = 'Hoàn thành';

  void getData(String id) {
    final reference = FirebaseDatabase.instance.reference();
    reference.child('Order/itemsendOrder/' + widget.id).onValue.listen((event) {
      final dynamic catchorder = event.snapshot.value;
      itemsendOrder thisO = itemsendOrder.fromJson(catchorder);
      thiscatch.setDataFromJson(catchorder);
      setState(() {
        _originLatitude = thisO.locationset.Latitude;
        _originLongitude = thisO.locationset.Longitude;
        _destLatitude = thisO.receiver.location.Latitude;
        _destLongitude = thisO.receiver.location.Longitude;
        _addMarker(LatLng(_originLatitude, _originLongitude), "origin", BitmapDescriptor.defaultMarker);

        _addMarker(LatLng(_destLatitude, _destLongitude), "destination", BitmapDescriptor.defaultMarkerWithHue(90));
        _getPolyline();
        startTime = getAllTimeString(thisO.S1time);
        if (thisO.locationset.firstText == "NA") {
          locationset = thisO.locationset.Longitude.toString() + " , " + thisO.locationset.Latitude.toString();
        } else {
          locationset = compactString(30, thisO.locationset.firstText);
        }
        if (thisO.receiver.location.firstText == "NA") {
          locationget = thisO.receiver.location.Longitude.toString() + " , " + thisO.receiver.location.Latitude.toString();
        } else {
          locationget = compactString(30, thisO.receiver.location.firstText);
        }
        Tmoney = getStringNumber(thisO.cost) + "đ";
      });

      setState(() {
        if (thiscatch.status == "D") {
          finalStatus = "Hoàn thành";
        }

        if (thiscatch.status == "G") {
          finalStatus = 'Bị hủy bởi shipper';
        }

        if (thiscatch.status == "E" ||thiscatch.status == "F") {
          finalStatus = 'Bị hủy bởi bạn';
        }

        if (thiscatch.status == "H") {
          finalStatus = 'Người nhận không lấy hàng';
        }
      });
    });
  }

  double getVoucherSale(Voucher voucher) {
    double money = 0;

    if(voucher.totalmoney < 100) {
      double mn = (thiscatch.cost + thiscatch.cost)/(1-(voucher.totalmoney/100))*(voucher.totalmoney/100);
      if (mn <= voucher.maxSale) {
        money = mn;
      } else {
        money = voucher.maxSale;
      }
    } else {
      money = voucher.totalmoney;
    }

    return money;
  }

  Future<void> changeStatus(itemsendOrder order, String status) async {
    DatabaseReference reference = FirebaseDatabase.instance.reference();
    await reference.child("Order/itemsendOrder/" + order.id + "/status").set(status);
    reference = FirebaseDatabase.instance.reference();
    await reference.child('Order/itemsendOrder/' + thiscatch.id + "/S4time").set(getCurrentTime().toJson());
    toastMessage('đã hủy đơn');
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData(currentAccount.id);
    _originLatitude = widget.diemdon.Latitude;
    _originLongitude = widget.diemdon.Longitude;
    _destLatitude = widget.diemtra.Latitude;
    _destLongitude = widget.diemtra.Longitude;
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
                              Navigator.push(context, MaterialPageRoute(builder:(context) => SCREENhistorysend()));
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
                                      'Đặt lúc ' + getAllTimeString(thiscatch.S1time),
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

                                Icon(
                                  Icons.delivery_dining,
                                  size: 30,
                                  color: Color.fromARGB(255, 255, 123, 64),
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
                                      'Giao hàng',
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
                                      getStringNumber(thiscatch.cost + getVoucherSale(thiscatch.voucher)) + '.đ',
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
                                      'Khuyễn mãi',
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
                                            text:'-' + getStringNumber(getVoucherSale(thiscatch.voucher)) + "đ",
                                            style: TextStyle(
                                              fontFamily: 'arial',
                                              color: Colors.redAccent,
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
                                      'Chi phí sau cùng',
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
                                              color: Colors.blueAccent,
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
                                      'Đang đợi tài xế nhận đơn',
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
                                    width: screenWidth - 40 - 30 - 30,
                                    child: Stack(
                                      children: <Widget>[
                                        Positioned(
                                          top: 0,
                                          left: 0,
                                          child: Container(
                                            height: 16,
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

                                        Positioned(
                                          top: 0,
                                          right: 0,
                                          child: Container(
                                            height: 16,
                                            width: screenWidth - 40 - 30 - 30,
                                            alignment: Alignment.centerRight,
                                            child: AutoSizeText(
                                              ((thiscatch. S2time.hour < 10) ? '0' + thiscatch. S2time.hour.toString() : thiscatch. S2time.hour.toString()) + ':' + ((thiscatch. S2time.minute < 10) ? '0' + thiscatch. S2time.minute.toString() : thiscatch. S2time.minute.toString()) + ',ngày ' + ((thiscatch.S2time.day < 10) ? '0' + thiscatch. S2time.day.toString() : thiscatch. S2time.day.toString()) + '/' + ((thiscatch.S2time.month < 10) ? '0' + thiscatch. S2time.month.toString() : thiscatch. S2time.month.toString()),
                                              textAlign: TextAlign.end,
                                              style: TextStyle(
                                                  fontFamily: 'arial',
                                                  color: Colors.black,
                                                  fontSize: 200,
                                                  fontWeight: (thiscatch.status == 'B') ?  FontWeight.bold : FontWeight.normal
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
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
                                    width: screenWidth - 40 - 30 - 30,
                                    child: Stack(
                                      children: <Widget>[
                                        Positioned(
                                          top: 0,
                                          left: 0,
                                          child: Container(
                                            height: 16,
                                            width: screenWidth - 40 - 30 - 30,
                                            child: AutoSizeText(
                                              'Tài xế đã nhận hàng',
                                              style: TextStyle(
                                                  fontFamily: 'arial',
                                                  color: Colors.black,
                                                  fontSize: 200,
                                                  fontWeight: (thiscatch.status == 'C') ?  FontWeight.bold : FontWeight.normal
                                              ),
                                            ),
                                          ),
                                        ),

                                        Positioned(
                                          top: 0,
                                          right: 0,
                                          child: Container(
                                            height: 16,
                                            width: screenWidth - 40 - 30 - 30,
                                            alignment: Alignment.centerRight,
                                            child: AutoSizeText(
                                              ((thiscatch.S3time.hour < 10) ? '0' + thiscatch. S3time.hour.toString() : thiscatch. S3time.hour.toString()) + ':' + ((thiscatch. S3time.minute < 10) ? '0' + thiscatch. S3time.minute.toString() : thiscatch. S3time.minute.toString()) + ',ngày ' + ((thiscatch.S3time.day < 10) ? '0' + thiscatch. S3time.day.toString() : thiscatch. S3time.day.toString()) + '/' + ((thiscatch.S3time.month < 10) ? '0' + thiscatch. S3time.month.toString() : thiscatch. S3time.month.toString()),
                                              textAlign: TextAlign.end,
                                              style: TextStyle(
                                                  fontFamily: 'arial',
                                                  color: Colors.black,
                                                  fontSize: 200,
                                                  fontWeight: (thiscatch.status == 'C') ?  FontWeight.bold : FontWeight.normal
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
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
                                          image: (thiscatch.status == 'E' || thiscatch.status == 'F' || thiscatch.status == 'G' || thiscatch.status == 'H' || thiscatch.status == 'D') ? AssetImage('assets/image/redcircle.png') : AssetImage('assets/image/greycircle.png')
                                      )
                                  ),
                                ),

                                Container(
                                  width: 10,
                                ),

                                Padding(
                                  padding: EdgeInsets.only(top: 7, bottom: 7),
                                  child: Container(
                                    width: screenWidth - 40 - 30 - 30,
                                    child: Stack(
                                      children: <Widget>[
                                        Positioned(
                                          top: 0,
                                          left: 0,
                                          child: Container(
                                            height: 16,
                                            width: screenWidth - 40 - 30 - 30,
                                            child: AutoSizeText(
                                              finalStatus,
                                              style: TextStyle(
                                                  fontFamily: 'arial',
                                                  color: Colors.black,
                                                  fontSize: 200,
                                                  fontWeight: (thiscatch.status == 'E' || thiscatch.status == 'F' || thiscatch.status == 'G' || thiscatch.status == 'H' || thiscatch.status == 'I' || thiscatch.status == 'J' || thiscatch.status == 'D1') ?  FontWeight.bold : FontWeight.normal
                                              ),
                                            ),
                                          ),
                                        ),

                                        Positioned(
                                          top: 0,
                                          right: 0,
                                          child: Container(
                                            height: 16,
                                            width: screenWidth - 40 - 30 - 30,
                                            alignment: Alignment.centerRight,
                                            child: AutoSizeText(
                                              ((thiscatch.S4time.hour < 10) ? '0' + thiscatch. S4time.hour.toString() : thiscatch. S4time.hour.toString()) + ':' + ((thiscatch. S4time.minute < 10) ? '0' + thiscatch. S4time.minute.toString() : thiscatch. S4time.minute.toString()) + ',ngày ' + ((thiscatch.S4time.day < 10) ? '0' + thiscatch. S4time.day.toString() : thiscatch. S4time.day.toString()) + '/' + ((thiscatch.S4time.month < 10) ? '0' + thiscatch. S4time.month.toString() : thiscatch. S4time.month.toString()),
                                              textAlign: TextAlign.end,
                                              style: TextStyle(
                                                  fontFamily: 'arial',
                                                  color: Colors.black,
                                                  fontSize: 200,
                                                  fontWeight: (thiscatch.status == 'E' || thiscatch.status == 'F' || thiscatch.status == 'G' || thiscatch.status == 'H' || thiscatch.status == 'I' || thiscatch.status == 'J' || thiscatch.status == 'D1') ?  FontWeight.bold : FontWeight.normal
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
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
                                      'Địa chỉ nhận hàng',
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
                                thiscatch.locationset.firstText + ',' + thiscatch.locationset.secondaryText,
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
                                      'Địa chỉ giao hàng',
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
                              alignment: Alignment.centerLeft,
                              child: Text(
                                thiscatch.receiver.location.firstText + ',' + thiscatch.receiver.location.secondaryText,
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
                            if (thiscatch.status == 'A') {
                              await changeStatus(thiscatch, 'E');
                              toastMessage('đã hủy đơn');
                            }

                            if (thiscatch.status == 'B') {
                              await changeStatus(thiscatch, 'F');
                              toastMessage('đã hủy đơn');
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
