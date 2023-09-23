import 'package:auto_size_text/auto_size_text.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:xekomain/FINAL/finalClass.dart';
import 'package:xekomain/SCREEN/INUSER/PAGE_HOME/T%C3%ADnh%20kho%E1%BA%A3ng%20c%C3%A1ch.dart';

import '../../GENERAL/Product/Product.dart';
import '../../GENERAL/ShopUser/accountShop.dart';
import '../../GENERAL/Tool/Time.dart';
import 'Quản lý danh mục/Item danh mục sản phẩm.dart';
import 'SCREENstoremain.dart';


class SCREENstoreview extends StatefulWidget {
  final String currentShop;
  const SCREENstoreview({Key? key, required this.currentShop}) : super(key: key);

  @override
  State<SCREENstoreview> createState() => _SCREENshopmainState();
}

class _SCREENshopmainState extends State<SCREENstoreview> {
  List<Product> productList = [];
  accountShop selectShop = accountShop(openTime: Time(second: 0, minute: 0, hour: 0, day: 0, month: 0, year: 0), closeTime: Time(second: 0, minute: 0, hour: 0, day: 0, month: 0, year: 0), phoneNum: '', location: '', name: '', id: '', status: 1, avatarID: '', createTime: Time(second: 0, minute: 0, hour: 0, day: 0, month: 0, year: 0), password: '', isTop: 0, Type: 0, ListDirectory: [], Area: '');
  void getData() {
    final reference = FirebaseDatabase.instance.reference();
    reference.child("Store/" + widget.currentShop).onValue.listen((event) {
      final dynamic restaurant = event.snapshot.value;
      accountShop pro = accountShop.fromJson(restaurant);
      selectShop.avatarID = pro.avatarID;
      selectShop.id = pro.id;
      selectShop.name = pro.name;
      selectShop.ListDirectory = pro.ListDirectory;
      selectShop.Type = pro.Type;
      selectShop.createTime = pro.createTime;
      selectShop.closeTime = pro.closeTime;
      selectShop.location = pro.location;
      selectShop.phoneNum = pro.phoneNum;
      setState(() {

      });
    });
  }

  List<int> parseDateString(String dateString) {
    List<String> parts = dateString.split('/');
    if (parts.length != 3) {

    }

    int day = int.parse(parts[0]) ?? 0;
    int month = int.parse(parts[1]) ?? 0;
    int year = int.parse(parts[2]) ?? 0;

    return [day, month, year];
  }

  String formatTime(int hour, int minute, int second) {
    String formattedHour = hour.toString().padLeft(2, '0');
    String formattedMinute = minute.toString().padLeft(2, '0');
    return '$formattedHour giờ $formattedMinute phút';
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return WillPopScope(
      child: Scaffold(
          body: Container(
              decoration: BoxDecoration(
                color: Colors.white,
              ),
              child: Stack(
                children: <Widget>[
                  Positioned(
                    top: 0,
                    left: 0,
                    child: Container(
                      width: screenWidth,
                      height: screenWidth,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              image: NetworkImage(selectShop.avatarID)
                          )
                      ),
                      child: Stack(
                        children: <Widget>[
                          Positioned(
                            top: 40,
                            left: 10,
                            child: GestureDetector(
                              child: Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                        fit: BoxFit.cover,
                                        image: AssetImage('assets/image/backicon1.png')
                                    ),
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(100)
                                ),
                              ),
                              onTap: () {
                                Navigator.push(context, MaterialPageRoute(builder:(context) => SCREENstoremain()));
                              },
                            ),
                          )
                        ],
                      ),
                    ),
                  ),

                  Positioned(
                    top: screenWidth/5*4,
                    left: 0,
                    child: Container(
                      width: screenWidth,
                      height: screenHeight - (screenWidth/5*4),
                      decoration: BoxDecoration(
                          color: Colors.white
                      ),
                      child: ListView(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: 10,right: 10),
                            child: Container(
                              height: 28,
                              decoration: BoxDecoration(

                              ),
                              child: AutoSizeText(
                                selectShop.name,
                                style: TextStyle(
                                    fontFamily: 'DMSans_regu',
                                    fontSize: 100,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black
                                ),
                                maxLines: 2,
                              ),
                            ),
                          ),

                          Container(height: 10,),

                          Padding(
                            padding: EdgeInsets.only(left: 10,right: 10),
                            child: Container(
                              height: 20,
                              decoration: BoxDecoration(

                              ),
                              child: AutoSizeText(
                                selectShop.location,
                                style: TextStyle(
                                    fontFamily: 'DMSans_regu',
                                    fontSize: 100,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey
                                ),
                                maxLines: 1,
                              ),
                            ),
                          ),

                          Container(height: 10,),

                          Padding(
                            padding: EdgeInsets.only(left: 10,right: 10),
                            child: Container(
                              height: 18,
                              decoration: BoxDecoration(

                              ),
                              child: AutoSizeText(
                                'Cách bạn ' + CaculateDistance.calculateDistance(CaculateDistance.parseDoubleString(selectShop.location)[0], CaculateDistance.parseDoubleString(selectShop.location)[1], currentAccount.locationHis.Latitude, currentAccount.locationHis.Longitude).toStringAsFixed(2).toString() + ' Km',
                                style: TextStyle(
                                    fontFamily: 'DMSans_regu',
                                    fontSize: 100,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.black
                                ),
                                maxLines: 1,
                              ),
                            ),
                          ),

                          Container(height: 20,),

                          Container(
                            height: 340 * selectShop.ListDirectory.length.toDouble(),
                            child: ListView.builder(
                              itemCount: selectShop.ListDirectory.length,
                              physics: NeverScrollableScrollPhysics(),
                              itemBuilder: (BuildContext context, int index) {
                                return Padding(
                                  padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
                                  child: InkWell(
                                    onTap: () {

                                    },
                                    child: ITEMdanhsachsanpham(width: screenWidth, height: 340, id: selectShop.ListDirectory[index]),
                                  ),
                                );
                              },
                            ),
                          )
                        ],
                      ),
                    ),
                  )
                ],
              )
          )
      ),
      onWillPop: () async {
        return false;
      },
    );
  }
}
