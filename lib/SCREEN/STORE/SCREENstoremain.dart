import 'package:auto_size_text/auto_size_text.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:xekomain/FINAL/finalClass.dart';
import 'package:xekomain/SCREEN/STORE/Qu%E1%BA%A3n%20l%C3%BD%20data.dart';
import '../../GENERAL/utils/utils.dart';
import '../INUSER/SCREEN_MAIN/SCREENmain.dart';
import '../RESTAURANT/Quản lý danh mục/Danh mục.dart';
import 'Quản lý danh mục/Item danh mục.dart';
import 'Xem thể loại/SCREENviewTypestore.dart';


class SCREENstoremain extends StatefulWidget {
  const SCREENstoremain({Key? key}) : super(key: key);

  @override
  State<SCREENstoremain> createState() => _SCREENshopmainState();
}

class _SCREENshopmainState extends State<SCREENstoremain> {
  List<RestaurantDirectory> directoryList = [];

  void getData() {
    final reference = FirebaseDatabase.instance.reference();
    reference.child("StoreDirectory").onValue.listen((event) {
      directoryList.clear();
      final dynamic restaurant = event.snapshot.value;
      restaurant.forEach((key, value) {
        RestaurantDirectory acc = RestaurantDirectory.fromJson(value);
        if (acc.Area == currentAccount.Area) {
          directoryList.add(acc);
        }
        setState(() {});
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
                      height: screenHeight,
                      child: ListView(
                        children: [
                          Container(
                            width: screenWidth,
                            height: 200,
                            child: Stack(
                              children: <Widget>[
                                Positioned(
                                  top: 0,
                                  left: 0,
                                  child: Container(
                                    width: screenWidth,
                                    height: 175,
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [Colors.orangeAccent, Color.fromARGB(255, 255, 123, 64)],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                        stops: [0.0, 1.0],
                                      ),
                                    ),
                                  ),
                                ),

                                Positioned(
                                  bottom: 0,
                                  child: Padding(
                                    padding: EdgeInsets.only(left: 10, right: 10),
                                    child: Container(
                                      height: 55,
                                      width: screenWidth - 20,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: Color.fromRGBO(255, 255, 255, 1),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.3), // màu của shadow
                                            spreadRadius: 5, // bán kính của shadow
                                            blurRadius: 7, // độ mờ của shadow
                                            offset: Offset(0, 3), // vị trí của shadow
                                          ),
                                        ],
                                      ),
                                      child: Form(
                                        child: TextFormField(
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontFamily: 'Dmsan_regular',
                                          ),

                                          decoration: InputDecoration(
                                            border: InputBorder.none,
                                            prefixIcon: Icon(Icons.search),
                                            hintText: 'Bạn muốn mua gì?',
                                            hintStyle: TextStyle(
                                              color: Colors.grey,
                                              fontFamily: 'Dmsan_regular',
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),

                                Positioned(
                                  top: 10,
                                  left: 10,
                                  child: GestureDetector(
                                    child: Container(
                                      width: 35,
                                      height: 35,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(100),
                                          color: Colors.white,
                                          image: DecorationImage(
                                              fit: BoxFit.cover,
                                              image: AssetImage('assets/image/backicon1.png')
                                          )
                                      ),
                                    ),
                                    onTap: () {
                                      Navigator.push(context, MaterialPageRoute(builder:(context) => SCREENmain()));
                                    },
                                  ),
                                )
                              ],
                            ),
                          ),

                          Container(height: 10,),

                          Container(
                            height: ((screenWidth - 40)/4) * 3 + 15,
                            child: GridView.builder(
                              itemCount: 9,
                              physics: NeverScrollableScrollPhysics(),
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 4, // số phần tử trên mỗi hàng
                                mainAxisSpacing: 0, // khoảng cách giữa các hàng
                                crossAxisSpacing: 0, // khoảng cách giữa các cột
                                childAspectRatio: 1, // tỷ lệ chiều rộng và chiều cao
                              ),
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
                                    child: GestureDetector(
                                      child: Container(
                                        child: Stack(
                                          children: <Widget>[
                                            Positioned(
                                              top: 0,
                                              left: 0,
                                              child: Container(
                                                width: ((screenWidth - 40)/4) - 10,
                                                height: (((screenWidth - 40)/4) - 10)/276*200,
                                                decoration: BoxDecoration(
                                                    image: DecorationImage(
                                                        fit: BoxFit.cover,
                                                        image: AssetImage(dataManager.dataList[index])
                                                    )
                                                ),
                                              ),
                                            ),

                                            Positioned(
                                              top: (((screenWidth - 40)/4) - 10)/276*200 + 3,
                                              left: 0,
                                              child: Container(
                                                height: 13,
                                                width: ((screenWidth - 40)/4 - 10),
                                                alignment: Alignment.center,
                                                child: AutoSizeText(
                                                  dataManager.dataName[index],
                                                  style: TextStyle(
                                                      fontSize: 100,
                                                      fontFamily: 'arial',
                                                      fontWeight: FontWeight.bold,
                                                      color: Colors.grey
                                                  ),
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  onTap: () {
                                    Navigator.push(context, MaterialPageRoute(builder:(context) => SCREENviewTypestore(Type: index, Title: dataManager.dataName[index],)));
                                  },
                                );
                              },
                            ),
                          ),

                          Container(height: 30,),

                          Padding(
                            padding: EdgeInsets.only(left: 10),
                            child: Container(
                              height: 340 * (directoryList.length.toDouble()),
                              decoration: BoxDecoration(

                              ),
                              child: ListView.builder(
                                itemCount: directoryList.length,
                                physics: NeverScrollableScrollPhysics(),
                                itemBuilder: (BuildContext context, int index) {
                                  return Padding(
                                    padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
                                    child: InkWell(
                                      onTap: () {

                                      },
                                      child: Itemdanhmuccuahang(width: screenWidth, height: 340, restaurantDirectory: directoryList[index]),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),

                        ],
                      )
                  ),
                ),

                Positioned(
                    right: 10,
                    bottom: 10,
                    child: GestureDetector(
                      onTap: () {
                        if (storeList.length == 0) {
                          toastMessage('Giỏ hàng chưa có sản phẩm nào');
                        } else {

                        }
                      },
                      child: Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.3),
                                spreadRadius: 5,
                                blurRadius: 7,
                                offset: Offset(0, 3),
                              ),
                            ],
                            borderRadius: BorderRadius.circular(10),
                            image: DecorationImage(
                                fit: BoxFit.cover,
                                image: AssetImage('assets/image/carticon.png')
                            )
                        ),

                        child: Stack(
                          children: <Widget>[
                            Positioned(
                              top: 5,
                              right: 5,
                              child: Container(
                                alignment: Alignment.center,
                                width: 18,
                                height: 18,
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(9),
                                ),
                                child: Text(
                                  cartList.length.toString(),
                                  style: TextStyle(
                                    fontFamily: 'arial',
                                    color: Colors.white,
                                    fontSize: 7,
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    )
                )
              ],
            ),
          )
      ),
      onWillPop: () async {
        return false;
      },
    );
  }
}
