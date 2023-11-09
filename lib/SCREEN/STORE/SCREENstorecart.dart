import 'package:flutter/material.dart';
import 'package:xekomain/GENERAL/NormalUser/accountLocation.dart';
import 'package:xekomain/SCREEN/STORE/ITEMproductincart.dart';
import 'package:xekomain/SCREEN/STORE/SCREENstoremain.dart';
import '../../FINAL/finalClass.dart';
import '../../GENERAL/Tool/Tool.dart';
import '../../GENERAL/utils/utils.dart';
import '../../ITEM/ITEMfoodincart.dart';
import '../../OTHER/Button/Buttontype1.dart';
import '../INUSER/PAGE_HOME/Tính khoảng cách.dart';
import 'Đặt đơn cửa hàng/SCREEN_LOCATION_PRODUCT.dart';

class SCREENstorecart extends StatefulWidget {
  const SCREENstorecart({Key? key}) : super(key: key);

  @override
  State<SCREENstorecart> createState() => _SCREENfoodcartState();
}

class _SCREENfoodcartState extends State<SCREENstorecart> {
  double total = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    total = 0;
    for (int i = 0 ; i < storeList.length ; i++) {
      total = total + storeList[i].cost;
    }
  }

  double getF(String input) {
    List<String> parts = input.split(',');
    if (parts.length > 0) {
      String firstPart = parts[0];
      return double.tryParse(firstPart) ?? 0.0;
    }
    return 0.0;
  }

  double getS(String input) {
    List<String> parts = input.split(',');
    if (parts.length > 1) {
      String secondPart = parts[1];
      return double.tryParse(secondPart) ?? 0.0;
    }
    return 0.0;
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return WillPopScope(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Row(
            children: [
              Padding(
                padding: EdgeInsets.only(left: 10),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder:(context) => SCREENstoremain()));
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

              SizedBox(width: 10),

              Text(
                'Giỏ hàng của tôi',
                style: TextStyle(
                  fontFamily: "arial",
                  fontSize: screenWidth/19.65,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),

              SizedBox(width: 5),

            ],
          ),
        ),

        body: Container(
          decoration: BoxDecoration(
              color: Colors.white
          ),

          child: Stack(
            children: <Widget>[
              Positioned(
                top: 0,
                left: 0,
                child: Container(
                    height: screenHeight - 10 - screenHeight/8 + 60,
                    width: screenWidth,
                    decoration: BoxDecoration(

                    ),
                    child: GridView.builder(
                      itemCount: storeList.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 1, // số phần tử trên mỗi hàng
                        mainAxisSpacing: 0, // khoảng cách giữa các hàng
                        crossAxisSpacing: 0, // khoảng cách giữa các cột
                        childAspectRatio: 4, // tỷ lệ chiều rộng và chiều cao
                      ),
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: EdgeInsets.only(left: 5, right: 5, top: 10),
                          child: InkWell(
                            onTap: () {

                            },
                            child: ITEMproductincart(food: storeList[index], width: screenWidth,
                              onTap: () {
                                storeList.remove(storeList[index]);
                                toastMessage('đã xóa khỏi giỏ hàng');
                                total = 0;
                                for (int i = 0 ; i < storeList.length ; i++) {
                                  total = total + storeList[i].cost;
                                }
                                setState(() {

                                });
                                if (storeList.length == 0) {
                                  toastMessage('giỏ hàng trống');
                                  Navigator.push(context, MaterialPageRoute(builder:(context) => SCREENstoremain()));
                                }
                              },),
                          ),
                        );
                      },
                    )
                ),
              ),

              Positioned(
                bottom: 0,
                left: 0,
                child: Container(
                  height: screenHeight/5,
                  width: screenWidth,
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
                ),
              ),

              Positioned(
                bottom: 60,
                left: 10,
                child: Container(
                    width: screenWidth-10,
                    height: 70,
                    child: Text(
                      'Tổng tiền : ' + getStringNumber(total) + "đ" ,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          fontFamily: 'arial',
                          color: Colors.black
                      ),
                    )
                ),
              ),

              Positioned(
                bottom: 10,
                left: 10,
                child: Container(
                  width: screenWidth-20,
                  height: 60,
                  child: ButtonType1(Height: 70, Width: screenWidth-20, color: Color.fromARGB(255, 244, 164, 84), radiusBorder: 35, title: 'Bước tiếp theo', fontText: 'arial', colorText: Colors.white,
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder:(context) => SCREENlocationstore(location: accountLocation(phoneNum: '', LocationID: '', Latitude: CaculateDistance.parseDoubleString(storeList[0].owner.location)[0], Longitude: CaculateDistance.parseDoubleString(storeList[0].owner.location)[1], firstText: '', secondaryText: ''),)));
                      }),
                ),
              )
            ],
          ),
        ),
      ),
      onWillPop: () async {
        return false;
      },
    );
  }
}
