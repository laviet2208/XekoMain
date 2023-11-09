import 'package:flutter/material.dart';
import 'package:xekomain/GENERAL/Order/catchOrder.dart';
import 'package:xekomain/GENERAL/Tool/Tool.dart';

class ITEMhistorycatch extends StatelessWidget {
  final catchOrder order;
  final double width;
  final double height;
  const ITEMhistorycatch({Key? key, required this.order, required this.width, required this.height,}) : super(key: key);



  @override
  Widget build(BuildContext context) {
    String imageType = '';
    if (order.type == 1) {
      imageType = 'assets/image/iconbike.png';
    } else {
      imageType = 'assets/image/icontransport.png';
    }

    String destination = '';
    if (order.locationGet.firstText == 'NA') {
      destination = 'Chuyến đi tới điểm ' + order.locationGet.Latitude.toString() + ' , ' + order.locationGet.Longitude.toString();
    } else {
      destination = 'Chuyến đi tới ' + order.locationGet.firstText;
    }

    Color statusColor = Color.fromARGB(255, 0, 177, 79);
    String status = '';
    if (order.status == "A") {
      status = "Đang đợi tài xế nhận đơn";
      statusColor = Colors.orange;
    }

    if (order.status == "B") {
      status = "Tài xế " + order.shipper.phoneNum + " đang đến";
      statusColor = Color.fromARGB(255, 0, 177, 79);
    }

    if (order.status == "C") {
      status = "Hành trình bắt đầu";
      statusColor = Color.fromARGB(255, 0, 177, 79);
    }

    if (order.status == "D") {
      status = "Hoàn thành";
      statusColor = Color.fromARGB(255, 0, 177, 79);
    }

    if (order.status == "G") {
      status = 'Bị hủy bởi tài xế';
      statusColor = Colors.redAccent;
    }

    if (order.status == "E" ||order.status == "F") {
      status = 'Bị hủy bởi bạn';
      statusColor = Colors.redAccent;
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
                  image: AssetImage(imageType)
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
            bottom: 0,
            left: 40,
            child: Container(
              width: width - 80,
              height: 1,
              decoration: BoxDecoration(
                  color: Colors.grey
              ),
            ),
          )
        ],
      ),
    );
  }
}
