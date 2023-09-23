import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../FINAL/finalClass.dart';
import '../../../GENERAL/NormalUser/accountNormal.dart';
import '../../../GENERAL/Order/foodOrder.dart';
import '../../../GENERAL/Tool/Tool.dart';
import '../../../GENERAL/utils/utils.dart';
import '../../../OTHER/Button/Buttontype1.dart';


class ITEMfood extends StatelessWidget {
  final foodOrder order;
  final double width;
  final double height;
  const ITEMfood({Key? key, required this.order, required this.width, required this.height}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool accecpt = false;
    Future<void> changeStatus(String sta) async {
      try {
        DatabaseReference databaseRef = FirebaseDatabase.instance.reference();
        await databaseRef.child('foodOrder/' + order.id + '/status').set(sta);
      } catch (error) {
        print('Đã xảy ra lỗi khi đẩy catchOrder: $error');
        throw error;
      }
    }

    Future<void> changeShipper(accountNormal ship) async {
      try {
        DatabaseReference databaseRef = FirebaseDatabase.instance.reference();
        await databaseRef.child('foodOrder/' + order.id + '/shipper').set(ship.toJson());
      } catch (error) {
        print('Đã xảy ra lỗi khi đẩy catchOrder: $error');
        throw error;
      }
    }

    void copyToClipboard(String text) {
      Clipboard.setData(ClipboardData(text: text));
    }


    String destination = '';
    if (order.locationGet.firstText == 'NA') {
      destination = order.locationGet.Latitude.toString() + ' , ' + order.locationGet.Longitude.toString();
    } else {
      destination = order.locationGet.firstText;
    }

    String locationSet = '';
    Color statusColor = Color.fromARGB(255, 0, 177, 79);
    if (order.locationSet.firstText == 'NA') {
      locationSet = order.locationSet.Latitude.toString() + ' , ' + order.locationSet.Longitude.toString();
    } else {
      locationSet = order.locationSet.firstText;
    }

    ///Phần button
    //nút hủy đơn
    Color cancelbtnColor = Colors.white;
    Color acceptbtnColor = Color.fromARGB(255, 0, 177, 79);
    String acceptText = 'Nhận đơn';

    ///phần trạng thái
    String status = '';
    if (order.status == "B") {
      status = "Đang đợi tài xế nhận đơn";
      statusColor = Colors.orange;
      cancelbtnColor = Colors.white;
      acceptText = 'Nhận đơn';
    }

    if (order.status == "C") {
      status = "Hành trình bắt đầu";
      statusColor = Color.fromARGB(255, 0, 177, 79);
      acceptText = 'Hoàn thành';
    }

    if (order.status == "D") {
      status = "Hoàn thành";
      statusColor = Color.fromARGB(255, 0, 177, 79);
    }

    if (order.status == "E" ||order.status == "F") {
      status = 'Bị hủy bởi shipper';
      statusColor = Colors.redAccent;
    }

    if (order.status == "G" ||order.status == "H") {
      status = 'Bị hủy bởi bạn';
      statusColor = Colors.redAccent;
    }


    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2), // màu của shadow
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
            left: 15,
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      fit: BoxFit.cover,
                      image: AssetImage('assets/image/linhtinh5.png')
                  )
              ),
            ),
          ),

          Positioned(
            top: 10,
            left: 70,
            child: Container(
              width: width - 100,
              height: 55,
              decoration: BoxDecoration(

              ),
              child: Text(
                'Giao tới : ' + destination,
                style: TextStyle(
                    fontFamily: 'arial',
                    fontSize: 15,
                    fontWeight: FontWeight.normal,
                    color: Colors.black87
                ),
              ),
            ),
          ),

          Positioned(
            top: 66,
            left: 70,
            child: Container(
              width: width/3*2,
              height: 20,
              decoration: BoxDecoration(

              ),
              child: Text(
                'Thời gian đặt: ' + getAllTimeString(order.startTime),
                style: TextStyle(
                    fontFamily: 'arial',
                    fontSize: 15,
                    fontWeight: FontWeight.normal,
                    color: Colors.grey
                ),
              ),
            ),
          ),

          Positioned(
            top: 90,
            left: 70,
            child: Container(
              width: width - 80,
              height: 20,
              decoration: BoxDecoration(

              ),
              child: Text(
                '+Số điện thoại liên lạc : ' + order.owner.phoneNum ,
                style: TextStyle(
                    fontFamily: 'arial',
                    fontSize: 15,
                    fontWeight: FontWeight.normal,
                    color: Colors.grey
                ),
              ),
            ),
          ),

          Positioned(
            top: 115,
            left: 70,
            child: Container(
              width: width - 100,
              height: 60,
              decoration: BoxDecoration(

              ),
              child: Text(
                '+ Đ/c nhà hàng : ' + locationSet ,
                style: TextStyle(
                    fontFamily: 'arial',
                    fontSize: 15,
                    fontWeight: FontWeight.normal,
                    color: Colors.grey
                ),
              ),
            ),
          ),

          Positioned(
            top: 140,
            left: 70,
            child: Container(
              width: width - 100,
              height: 60,
              decoration: BoxDecoration(

              ),
              child: Text(
                '+ Tên nhà hàng : ' + compactString(17, order.productList[0].owner.name),
                style: TextStyle(
                    fontFamily: 'arial',
                    fontSize: 15,
                    fontWeight: FontWeight.normal,
                    color: Colors.grey
                ),
              ),
            ),
          ),

          Positioned(
            top: 165,
            left: 70,
            child: Container(
              width: width - 100,
              height: 60,
              decoration: BoxDecoration(

              ),
              child: Text(
                '+ Giá trị đơn : ' + getStringNumber(order.cost) + 'đ',
                style: TextStyle(
                    fontFamily: 'arial',
                    fontSize: 15,
                    fontWeight: FontWeight.normal,
                    color: Colors.grey
                ),
              ),
            ),
          ),

          Positioned(
            top: 190,
            left: 70,
            child: Container(
              width: width - 100,
              height: 60,
              decoration: BoxDecoration(

              ),
              child: Text(
                '+ Phí ship : ' + getStringNumber(order.shipcost) + 'đ',
                style: TextStyle(
                    fontFamily: 'arial',
                    fontSize: 15,
                    fontWeight: FontWeight.normal,
                    color: Colors.grey
                ),
              ),
            ),
          ),

          Positioned(
            top: 215,
            left: 70,
            child: Container(
              width: width - 100,
              height: 60,
              decoration: BoxDecoration(

              ),
              child: Text(
                '+ Mã đơn : ' + order.id,
                style: TextStyle(
                    fontFamily: 'arial',
                    fontSize: 15,
                    fontWeight: FontWeight.normal,
                    color: Colors.redAccent
                ),
              ),
            ),
          ),

          Positioned(
            top: 245,
            left: 70,
            child: Container(
              width: width - 95,
              height: 40,
              child: ButtonType1(Height: 40, Width: width/4, color: Color.fromARGB(255, 0, 177, 79), radiusBorder: 20, title: acceptText, fontText: 'arial', colorText: Colors.white,
                  onTap: () async {
                    if (order.status == 'B') {
                      toastMessage('đang nhận đơn');
                      await changeShipper(currentAccount);
                      await changeStatus('C');
                      toastMessage('đã nhận đơn');
                    }
                  }),
            ),
          ),

          Positioned(
            top: 295,
            left: 70,
            child: Container(
              width: width/4,
              height: 40,
              child: ButtonType1(Height: 40, Width: width/4, color: Colors.blueAccent, radiusBorder: 20, title: 'Số điện thoại', fontText: 'arial', colorText: Colors.white,
                  onTap: () {
                    copyToClipboard(order.owner.phoneNum);
                    toastMessage('đã copy số điện thoại');
                  }),
            ),
          ),

          Positioned(
            top: 295,
            left: 70 + width/4 + 2,
            child: Container(
              width: width/4,
              height: 40,
              child: ButtonType1(Height: 40, Width: width/4, color: Colors.blueAccent, radiusBorder: 20, title: 'Điểm đi', fontText: 'arial', colorText: Colors.white,
                  onTap: () {
                    copyToClipboard(locationSet);
                    toastMessage('đã copy điểm đón');
                  }),
            ),
          ),

          Positioned(
            top: 295,
            left: 70 + width/2 + 4,
            child: Container(
              width: width/4,
              height: 40,
              child: ButtonType1(Height: 40, Width: width/4, color: Colors.blueAccent, radiusBorder: 20, title: 'Điểm đến', fontText: 'arial', colorText: Colors.white,
                  onTap: () {
                    copyToClipboard(destination);
                    toastMessage('đã copy điểm đến');
                  }),
            ),
          ),
        ],
      ),
    );
  }
}
