import 'package:flutter/material.dart';
import 'package:xekomain/GENERAL/Order/itemsendOrder.dart';

import '../../../GENERAL/Tool/Tool.dart';

class ITEMhistorysend extends StatelessWidget {
  final itemsendOrder order;
  final double width;
  final double height;
  final VoidCallback onTap;
  const ITEMhistorysend({Key? key, required this.order, required this.width, required this.height, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String destination = '';
    if (order.receiver.location.firstText == 'NA') {
      destination = 'Giao tới điểm ' + order.receiver.location.Latitude.toString() + ' , ' + order.receiver.location.Longitude.toString();
    } else {
      destination = 'Giao tới ' + order.receiver.location.firstText;
    }

    String receiver = '';
    receiver = "Người nhận : " + order.receiver.name;

    Color buttonColor = Colors.redAccent;

    Color statusColor = Color.fromARGB(255, 0, 177, 79);
    String status = '';
    if (order.status == "A") {
      status = "Đang đợi tài xế nhận đơn";
      statusColor = Colors.orange;
      buttonColor = Colors.redAccent;
    }

    if (order.status == "B") {
      status = "Tài xế " + order.shipper.phoneNum + " đang đến";
      statusColor = Color.fromARGB(255, 0, 177, 79);
      buttonColor = Colors.redAccent;
    }

    if (order.status == "C") {
      status = "Tài xế đã nhận hàng từ bạn";
      statusColor = Color.fromARGB(255, 0, 177, 79);
      buttonColor = Colors.white;
    }

    if (order.status == "D") {
      status = "Hoàn thành";
      statusColor = Color.fromARGB(255, 0, 177, 79);
      buttonColor = Colors.white;
    }

    if (order.status == "G") {
      status = 'Bị hủy bởi shipper';
      statusColor = Colors.redAccent;
      buttonColor = Colors.white;
    }

    if (order.status == "E" ||order.status == "F") {
      status = 'Bị hủy bởi bạn';
      statusColor = Colors.redAccent;
      buttonColor = Colors.white;
    }

    if (order.status == "H") {
      status = 'Người nhận không lấy hàng';
      statusColor = Colors.redAccent;
      buttonColor = Colors.white;
    }

    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(

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
              width: width/2,
              height: 50,
              decoration: BoxDecoration(

              ),
              child: Text(
                compactString(33, destination),
                style: TextStyle(
                    fontFamily: 'arial',
                    fontSize: 20,
                    fontWeight: FontWeight.normal,
                    color: Colors.black87
                ),
              ),
            ),
          ),

          Positioned(
            top: 10,
            right: 10,
            child: Container(
              width: width/2 - 10 - 70,
              height: 60,
              alignment: Alignment.topRight,
              decoration: BoxDecoration(

              ),
              child: Text(
                getStringNumber(order.cost) + 'đ',
                style: TextStyle(
                    fontFamily: 'arial',
                    fontSize: 22,
                    fontWeight: FontWeight.normal,
                    color: Colors.black87
                ),
              ),
            ),
          ),

          Positioned(
            top: 63,
            left: 70,
            child: Container(
              width: width/3*2,
              height: 20,
              decoration: BoxDecoration(

              ),
              child: Text(
                getAllTimeString(order.startTime),
                style: TextStyle(
                    fontFamily: 'arial',
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                    color: Colors.grey
                ),
              ),
            ),
          ),

          Positioned(
            top: 85,
            left: 70,
            child: Container(
              width: width - 80,
              height: 20,
              decoration: BoxDecoration(

              ),
              child: Text(
                compactString(25, receiver),
                style: TextStyle(
                    fontFamily: 'arial',
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black
                ),
              ),
            ),
          ),

          Positioned(
            top: 110,
            left: 70,
            child: Container(
              width: width - 80,
              height: 20,
              decoration: BoxDecoration(

              ),
              child: Text(
                status,
                style: TextStyle(
                    fontFamily: 'arial',
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: statusColor
                ),
              ),
            ),
          ),

          Positioned(
            top: 110,
            left: width -80,
            child: GestureDetector(
              onTap: onTap,
              child: Container(
                height: 20,
                decoration: BoxDecoration(

                ),
                child: Text(
                  'Hủy đơn',
                  style: TextStyle(
                      fontFamily: 'arial',
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: buttonColor
                  ),
                ),
              ),
            )
          ),
        ],
      ),
    );
  }
}
