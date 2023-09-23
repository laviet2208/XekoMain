import 'package:flutter/material.dart';

import '../../GENERAL/Product/Voucher.dart';

class ITENvoucherview extends StatelessWidget {
  final Voucher voucher;
  final double width;
  final double height;
  const ITENvoucherview({Key? key, required this.voucher, required this.width, required this.height}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 5,
            blurRadius: 7,
            offset: Offset(0, 3),
          ),
        ],
      ),

      child: Stack(
        children: <Widget>[
          Positioned(
            top: 10,
            left: 10,
            child: Text(
              "RabitVoucher",
              style: TextStyle(
                fontWeight: FontWeight.normal,
                fontSize: 14,
                fontFamily: 'arial',
                color: Colors.grey
              ),
            ),
          ),

          Positioned(
            top: 30,
            left: 10,
            child: Text(
              "Giảm giá " + (voucher.totalmoney/1000).toString() + "K," + "đơn từ " +  (voucher.mincost/1000).toString() + "K",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  fontFamily: 'arial',
                  color: Colors.black
              ),
            ),
          ),

          Positioned(
            top: 55,
            left: 10,
            child: Text(
              "Giảm giá trực tiếp vào đơn hàng",
              style: TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: 15,
                  fontFamily: 'arial',
                  color: Colors.black
              ),
            ),
          ),

          Positioned(
            top: 100,
            left: 0,
            child: Container(
              width: width,
              height: 1,
              decoration: BoxDecoration(
                color: Colors.grey
              ),
            )
          ),

          Positioned(
            top: 15,
            right: 10,
            child: Container(
              width: height/3,
              height: height/3,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: AssetImage('assets/image/mainLogo.png')
                )
              ),
            )
          )
        ],
      ),
    );
  }
}

