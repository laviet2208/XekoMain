import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../FINAL/finalClass.dart';
import '../../../GENERAL/NormalUser/accountNormal.dart';
import '../../../GENERAL/Order/itemsendOrder.dart';
import '../../../GENERAL/Tool/Tool.dart';
import '../../../GENERAL/utils/utils.dart';
import '../../../OTHER/Button/Buttontype1.dart';


class ITEMsend extends StatelessWidget {
  final itemsendOrder order;
  final double width;
  final double height;
  const ITEMsend({Key? key, required this.order, required this.width, required this.height}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool accecpt = false;
    Future<void> changeStatus(String sta) async {
      try {
        DatabaseReference databaseRef = FirebaseDatabase.instance.reference();
        await databaseRef.child('itemsendOrder/' + order.id + '/status').set(sta);
      } catch (error) {
        print('Đã xảy ra lỗi khi đẩy catchOrder: $error');
        throw error;
      }
    }

    Future<void> changeMoney(double money) async {
      try {
        DatabaseReference databaseRef = FirebaseDatabase.instance.reference();
        await databaseRef.child('normalUser/' + currentAccount.id + '/totalMoney').set(money);
      } catch (error) {
        print('Đã xảy ra lỗi khi đẩy catchOrder: $error');
        throw error;
      }
    }

    Future<void> changeShipper(accountNormal ship) async {
      try {
        DatabaseReference databaseRef = FirebaseDatabase.instance.reference();
        await databaseRef.child('itemsendOrder/' + order.id + '/shipper').set(ship.toJson());
      } catch (error) {
        print('Đã xảy ra lỗi khi đẩy catchOrder: $error');
        throw error;
      }
    }

    void copyToClipboard(String text) {
      Clipboard.setData(ClipboardData(text: text));
    }


    String destination = '';
    if (order.receiver.location.firstText == 'NA') {
      destination = order.receiver.location.Latitude.toString() + ' , ' + order.receiver.location.Longitude.toString();
    } else {
      destination = order.receiver.location.firstText;
    }

    String locationSet = '';
    Color statusColor = Color.fromARGB(255, 0, 177, 79);
    if (order.locationset.firstText == 'NA') {
      locationSet = order.locationset.Latitude.toString() + ' , ' + order.locationset.Longitude.toString();
    } else {
      locationSet = order.locationset.firstText;
    }

    ///Phần button
    //nút hủy đơn
    Color cancelbtnColor = Colors.white;
    Color acceptbtnColor = Color.fromARGB(255, 0, 177, 79);
    String acceptText = 'Nhận đơn';

    ///phần trạng thái
    String status = '';
    if (order.status == "A") {
      status = "Đang đợi tài xế nhận đơn";
      statusColor = Colors.orange;
      cancelbtnColor = Colors.white;
      acceptText = 'Nhận đơn';
    }

    if (order.status == "B") {
      status = "Tài xế " + order.shipper.phoneNum + " đang đến";
      statusColor = Color.fromARGB(255, 0, 177, 79);
      cancelbtnColor = Colors.redAccent;
      acceptText = 'Đã đón khách';
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
                compactString(40, 'Giao tới : ' + destination),
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
            top: 34,
            left: 70,
            child: Container(
              width: width/3*2,
              height: 20,
              decoration: BoxDecoration(

              ),
              child: RichText(
                text: TextSpan(
                  style: DefaultTextStyle.of(context).style,
                  children: <TextSpan>[
                    TextSpan(
                      text: 'Thời gian đặt : ',
                      style: TextStyle(
                        fontSize: 15,
                        fontFamily: 'arial',
                        fontWeight: FontWeight.bold, // Để in đậm
                      ),
                    ),
                    TextSpan(
                      text: getAllTimeString(order.startTime), // Phần còn lại viết bình thường
                      style: TextStyle(
                        fontSize: 15,
                        fontFamily: 'arial',
                        color: Colors.black,
                        fontWeight: FontWeight.normal, // Để viết bình thường
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          Positioned(
            top: 58,
            left: 70,
            child: Container(
              width: width - 80,
              height: 20,
              decoration: BoxDecoration(

              ),
              child: RichText(
                text: TextSpan(
                  style: DefaultTextStyle.of(context).style,
                  children: <TextSpan>[
                    TextSpan(
                      text: '+ SĐT người gửi: ',
                      style: TextStyle(
                        fontSize: 15,
                        fontFamily: 'arial',
                        fontWeight: FontWeight.bold, // Để in đậm
                      ),
                    ),
                    TextSpan(
                      text: (order.owner.phoneNum[0] == '0') ? order.owner.phoneNum : ('0' + order.owner.phoneNum), // Phần còn lại viết bình thường
                      style: TextStyle(
                        fontSize: 15,
                        fontFamily: 'arial',
                        color: Colors.blueAccent,
                        fontWeight: FontWeight.normal, // Để viết bình thường
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          Positioned(
            top: 82,
            left: 70,
            child: Container(
              width: width - 100,
              height: 60,
              decoration: BoxDecoration(

              ),
              child: RichText(
                text: TextSpan(
                  style: DefaultTextStyle.of(context).style,
                  children: <TextSpan>[
                    TextSpan(
                      text: '+ SĐT người nhận: ',
                      style: TextStyle(
                        fontSize: 15,
                        fontFamily: 'arial',
                        fontWeight: FontWeight.bold, // Để in đậm
                      ),
                    ),
                    TextSpan(
                      text: order.receiver.phoneNum, // Phần còn lại viết bình thường
                      style: TextStyle(
                        fontSize: 15,
                        fontFamily: 'arial',
                        color: Colors.blueAccent,
                        fontWeight: FontWeight.normal, // Để viết bình thường
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          Positioned(
            top: 106,
            left: 70,
            child: Container(
              width: width - 100,
              height: 60,
              decoration: BoxDecoration(

              ),
              child: RichText(
                text: TextSpan(
                  style: DefaultTextStyle.of(context).style,
                  children: <TextSpan>[
                    TextSpan(
                      text: '+ Cân nặng: ',
                      style: TextStyle(
                        fontSize: 15,
                        fontFamily: 'arial',
                        fontWeight: FontWeight.bold, // Để in đậm
                      ),
                    ),
                    TextSpan(
                      text: order.itemdetails.weight.toInt().toString(), // Phần còn lại viết bình thường
                      style: TextStyle(
                        fontSize: 15,
                        fontFamily: 'arial',
                        color: Colors.blueAccent,
                        fontWeight: FontWeight.normal, // Để viết bình thường
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          Positioned(
            top: 130,
            left: 70,
            child: Container(
              width: width - 100,
              height: 60,
              decoration: BoxDecoration(

              ),
              child: RichText(
                text: TextSpan(
                  style: DefaultTextStyle.of(context).style,
                  children: <TextSpan>[
                    TextSpan(
                      text: '+ Thu hộ: ',
                      style: TextStyle(
                        fontSize: 15,
                        fontFamily: 'arial',
                        fontWeight: FontWeight.bold, // Để in đậm
                      ),
                    ),
                    TextSpan(
                      text: getStringNumber(order.itemdetails.codFee) + '.đ', // Phần còn lại viết bình thường
                      style: TextStyle(
                        fontSize: 15,
                        fontFamily: 'arial',
                        color: Colors.deepPurple,
                        fontWeight: FontWeight.bold, // Để viết bình thường
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          Positioned(
            top: 154,
            left: 70,
            child: Container(
              width: width - 100,
              height: 60,
              decoration: BoxDecoration(

              ),
              child: RichText(
                text: TextSpan(
                  style: DefaultTextStyle.of(context).style,
                  children: <TextSpan>[
                    TextSpan(
                      text: '+ Phí ship: ',
                      style: TextStyle(
                        fontSize: 15,
                        fontFamily: 'arial',
                        fontWeight: FontWeight.bold, // Để in đậm
                      ),
                    ),
                    TextSpan(
                      text: getStringNumber(order.cost) + '.đ', // Phần còn lại viết bình thường
                      style: TextStyle(
                        fontSize: 15,
                        fontFamily: 'arial',
                        color: Colors.deepPurple,
                        fontWeight: FontWeight.bold, // Để viết bình thường
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          Positioned(
            top: 178,
            left: 70,
            child: Container(
              width: width - 100,
              height: 60,
              decoration: BoxDecoration(

              ),
              child: RichText(
                text: TextSpan(
                  style: DefaultTextStyle.of(context).style,
                  children: <TextSpan>[
                    TextSpan(
                      text: '+ Chiết khấu: ',
                      style: TextStyle(
                        fontSize: 15,
                        fontFamily: 'arial',
                        fontWeight: FontWeight.bold, // Để in đậm
                      ),
                    ),
                    TextSpan(
                      text: getStringNumber(order.cost * (order.costFee.discount/100)) + '.đ (' + order.costFee.discount.toInt().toString() + '%)', // Phần còn lại viết bình thường
                      style: TextStyle(
                        fontSize: 15,
                        fontFamily: 'arial',
                        color: Colors.deepPurple,
                        fontWeight: FontWeight.bold, // Để viết bình thường
                      ),
                    ),
                  ],
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
              child: ButtonType1(Height: 40, Width: width - 95, color: Color.fromARGB(255, 0, 177, 79), radiusBorder: 20, title: acceptText, fontText: 'arial', colorText: Colors.white,
                  onTap: () async {
                    if ((order.cost * (order.costFee.discount/100)) <= currentAccount.totalMoney) {
                      if (order.status == 'A') {
                        toastMessage('đang nhận đơn');
                        await changeShipper(currentAccount);
                        await changeMoney(currentAccount.totalMoney - (order.cost * (order.costFee.discount/100)));
                        await changeStatus('B');
                        toastMessage('đã nhận đơn');
                      }
                    } else {
                      toastMessage('ví bạn không đủ tiền để nhận đơn này');
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
