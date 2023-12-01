import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:xekomain/GENERAL/NormalUser/accountNormal.dart';
import 'package:xekomain/SCREEN/RESTAURANT/Chi%20ti%E1%BA%BFt%20l%E1%BB%8Bch%20s%E1%BB%AD.dart';


import '../../FINAL/finalClass.dart';
import '../../GENERAL/Order/foodOrder.dart';
import '../../GENERAL/utils/utils.dart';
import '../INUSER/SCREEN_MAIN/SCREENmain.dart';
import 'ITEM/ITEMhistoryfood.dart';
import 'ITEM/ITEMhistorysend.dart';

class SCREENhistoryfood extends StatefulWidget {
  const SCREENhistoryfood({Key? key}) : super(key: key);

  @override
  State<SCREENhistoryfood> createState() => _SCREENhistorysendState();
}

class _SCREENhistorysendState extends State<SCREENhistoryfood> {
  Future<void> changeStatus(foodOrder order, String status) async {
    final reference = FirebaseDatabase.instance.reference();
    await reference.child("Order/foodOrder/" + order.id + "/status").set(status);
  }

  List<foodOrder> dataList = [];
  void getData() {
    final reference = FirebaseDatabase.instance.reference();
    reference.child('Order/foodOrder').onValue.listen((event) {
      dataList.clear();
      final dynamic account = event.snapshot.value;
      account.forEach((key, value) {
        if (accountNormal.fromJson(value['owner']).id == currentAccount.id) {
          foodOrder thisO = foodOrder.fromJson(value);
          dataList.add(thisO);
        }
      }
      );
      setState(() {

      });
    });

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
    return Scaffold(
      body: Container(
        child: Stack(
          children: <Widget>[
            Positioned(
              top: 0,
              left: 0,
              child: Container(
                width: screenWidth,
                height: 100,
                decoration: BoxDecoration(

                ),
                child: Stack(
                  children: <Widget>[
                    Positioned(
                      bottom: 15,
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
                        bottom: 22,
                        left: 60,
                        child: Text(
                          'Lịch sử đặt đồ ăn',
                          style: TextStyle(
                              fontWeight: FontWeight.normal,
                              fontSize: 24,
                              fontFamily: 'arial',
                              color: Colors.black
                          ),
                        )
                    ),
                  ],
                ),
              ),
            ),

            Positioned(
              top: 100,
              left: 0,
              child: Container(
                width: screenWidth,
                height: screenHeight - 100,
                child: ListView.builder(
                  itemCount: dataList.length,
                  padding: EdgeInsets.zero,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 0.0),
                      child: InkWell(
                        child: ITEMhistoryfood(order: dataList[index], width: screenWidth, height: 140,
                          onTap: () async{
                            if (dataList[index].status == 'A') {
                              await changeStatus(dataList[index], 'E');
                              toastMessage('đã hủy đơn');
                            }

                            if (dataList[index].status == 'B') {
                              await changeStatus(dataList[index], 'G');
                              toastMessage('đã hủy đơn');
                            }

                            if (dataList[index].status == 'C') {
                              await changeStatus(dataList[index], 'H');
                              toastMessage('đã hủy đơn');
                            }
                          },
                        ),
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder:(context) => SCREENfoodHisDetail(id: dataList[index].id, diemdon: dataList[index].locationSet,diemtra: dataList[index].locationGet,)));
                        },
                      ),
                    );
                  },
                ),
              ),
            ),


          ],
        ),
      ),
    );
  }
}
