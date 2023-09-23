import 'package:flutter/material.dart';

import '../../../GENERAL/Order/foodOrder.dart';
import '../../../GENERAL/Tool/Tool.dart';

class ITEMhistoryfood extends StatelessWidget {
  final foodOrder order;
  final double width;
  final double height;
  final VoidCallback onTap;
  const ITEMhistoryfood({Key? key, required this.order, required this.width, required this.height, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String destination = '';
    if (order.locationGet.firstText == 'NA') {
      destination = 'Chuyến đi tới điểm ' + order.locationGet.Latitude.toString() + ' , ' + order.locationGet.Longitude.toString();
    } else {
      destination = 'Chuyến đi tới ' + order.locationGet.firstText;
    }

    Color buttonColor = Colors.redAccent;
    Color statusColor = Color.fromARGB(255, 0, 177, 79);
    String status = '';
    if (order.status == "A") {
      status = "Đang đợi nhà hàng xác nhận";
      statusColor = Colors.orange;
      buttonColor = Colors.redAccent;
    }

    if (order.status == "B") {
      status = "Đã xác nhận , đợi tài xế lấy";
      statusColor = Color.fromARGB(255, 0, 177, 79);
      buttonColor = Colors.redAccent;
    }

    if (order.status == "C") {
      status = "Tài xế đã nhận đơn và tới quán";
      statusColor = Color.fromARGB(255, 0, 177, 79);
      buttonColor = Colors.white;
    }

    if (order.status == "D") {
      status = "Tài xế đã lấy đươc món ăn và đang tới";
      statusColor = Color.fromARGB(255, 0, 177, 79);
      buttonColor = Colors.redAccent;
    }

    if (order.status == "D1") {
      status = "Đơn hàng hoàn tất";
      statusColor = Color.fromARGB(255, 0, 177, 79);
      buttonColor = Colors.white;
    }

    if (order.status == "I") {
      status = 'Bị hủy bởi shipper';
      statusColor = Colors.redAccent;
      buttonColor = Colors.white;
    }

    if (order.status == "F") {
      status = 'Quán không xác nhận';
      statusColor = Colors.redAccent;
      buttonColor = Colors.white;
    }

    if (order.status == "E" || order.status == "G" || order.status == "H") {
      status = 'Bị hủy bởi bạn';
      statusColor = Colors.redAccent;
      buttonColor = Colors.white;
    }

    if (order.status == "J") {
      status = 'Bị bom bởi bạn';
      statusColor = Colors.redAccent;
      buttonColor = Colors.white;
    }

    return Container(
      width: width,
      height: height,
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
                      image: AssetImage('assets/image/iconfood.png')
                  )
              ),
            ),
          ),

          Positioned(
            top: 10,
            left: 70,
            child: Container(
              width: width/2,
              height: 60,
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
                compactString(25, order.productList[0].owner.name),
                style: TextStyle(
                    fontFamily: 'arial',
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 0, 177, 79)
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
