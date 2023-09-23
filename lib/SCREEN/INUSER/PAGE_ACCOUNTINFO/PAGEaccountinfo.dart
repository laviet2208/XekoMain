import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:xekomain/GENERAL/NormalUser/accountNormal.dart';


import '../../../FINAL/finalClass.dart';
import '../../../GENERAL/utils/utils.dart';
import '../../BEFORE/SCREEN_firstloading.dart';
import '../../FILL_INFOR/SCREENfillbikerequest.dart';
import '../../HISTORY/SCREENhistorycatch.dart';
import '../../HISTORY/SCREENhistoryfood.dart';
import '../../HISTORY/SCREENhistorysend.dart';

class PAGEaccountinfo extends StatefulWidget {
  const PAGEaccountinfo({Key? key}) : super(key: key);

  @override
  State<PAGEaccountinfo> createState() => _PAGEaccountinfoState();
}

class _PAGEaccountinfoState extends State<PAGEaccountinfo> {
  String avaID = 'https://firebasestorage.googleapis.com/v0/b/rabbitshipping-fa875.appspot.com/o/image%2Favatar_no_image.png?alt=media&token=f36e0d5d-6eab-48d1-9e20-e6778e01037e';
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> signOutWithPhoneNumberOTP() async {
    try {
      // Kiểm tra nếu người dùng đã đăng nhập bằng số điện thoại OTP
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null && user.providerData.any((info) => info.providerId == 'phone')) {
        // Nếu đăng nhập bằng số điện thoại OTP, thực hiện đăng xuất
        await FirebaseAuth.instance.signOut();
        print('Đăng xuất thành công!');
      } else {
        print('Không tìm thấy tài khoản đăng nhập bằng số điện thoại OTP.');
      }
    } catch (e) {
      print('Đăng xuất thất bại: $e');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (currentAccount.avatarID == 'NA') {
      avaID = 'https://firebasestorage.googleapis.com/v0/b/rabbitshipping-fa875.appspot.com/o/image%2Favatar_no_image.png?alt=media&token=f36e0d5d-6eab-48d1-9e20-e6778e01037e';
    } else {
      avaID = currentAccount.avatarID;
    }
  }

  Future<bool> getData(String id) async {
    final reference = FirebaseDatabase.instance.reference();
    DatabaseEvent snapshot = await reference.child('bikeRequest').once();
    bool ch = false;
    final dynamic catchOrderData = snapshot.snapshot.value;
    if (catchOrderData != null) {
      catchOrderData.forEach((key, value) {
        if (accountNormal.fromJson(value['owner']).id == id) {
          ch = true;
        }
      }
      );
    }
    return ch;
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
        child: ListView(
          children: [
            Container(
              height: 140,
              decoration: BoxDecoration(
              ),

              child: Stack(
                children: <Widget>[
                  Positioned(
                    top: 15,
                    left: 20,
                    child: Container(
                      width: 110,
                      height: 110,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(60),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.2), // màu của shadow
                              spreadRadius: 5, // bán kính của shadow
                              blurRadius: 7, // độ mờ của shadow
                              offset: Offset(0, 3), // vị trí của shadow
                            ),
                          ],
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: NetworkImage(avaID)
                        )
                      ),
                    ),
                  ),

                  Positioned(
                    top: 30,
                    left: 145,
                    child: Text(
                      currentAccount.name,
                      style: TextStyle(
                        fontFamily: 'arial',
                        fontSize: 22,
                        color: Colors.black,
                        fontWeight: FontWeight.bold
                      ),
                    )
                  ),

                  Positioned(
                      top: 60,
                      left: 145,
                      child: Text(
                        'Normal user',
                        style: TextStyle(
                            fontFamily: 'arial',
                            fontSize: 14,
                            color: Colors.black,
                            fontWeight: FontWeight.normal
                        ),
                      )
                  ),
                ],
              ),
            ),

            Container(height: 10,),

            //Phần Lịch sử
            Padding(
                padding: EdgeInsets.only(left: 20),
                child: Text(
                  'Lịch sử Rabit',
                  style: TextStyle(
                      fontFamily: 'arial',
                      fontSize: 20,
                      color: Colors.black,
                      fontWeight: FontWeight.bold
                  ),
                )
            ),

            Container(height: 20,),

            ///Lịch sử bắt xe
            Padding(
              padding: EdgeInsets.only(left: 20, right: 10),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder:(context) => SCREENhistorycatch()));
                },
                child: Container(
                  height: 60,
                  decoration: BoxDecoration(

                  ),
                  child: Stack(
                    children: <Widget>[
                      Positioned(
                        top: 0,
                        left: 0,
                        child: Container(
                            width: (screenWidth-30)/3*2,
                            height: 60,
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Lịch sử bắt xe',
                              style: TextStyle(
                                  fontFamily: 'arial',
                                  fontSize: 16,
                                  color: Color.fromARGB(255, 32, 32, 32),
                                  fontWeight: FontWeight.normal
                              ),
                            )
                        ),
                      ),

                      Positioned(
                        top: 20,
                        right: 0,
                        child: Container(
                          height: 20,
                          width: 20,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: AssetImage('assets/image/righticon.png')
                              )
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),

            Padding(
              padding: EdgeInsets.only(left: 20, right: 10),
              child: Container(
                height: 1,
                decoration: BoxDecoration(
                    color: Colors.blueGrey
                ),
              ),
            ),

            ///Lịch sử giao hàng
            Padding(
              padding: EdgeInsets.only(left: 20, right: 10),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder:(context) => SCREENhistorysend()));
                },
                child: Container(
                  height: 60,
                  decoration: BoxDecoration(

                  ),
                  child: Stack(
                    children: <Widget>[
                      Positioned(
                        top: 0,
                        left: 0,
                        child: Container(
                            width: (screenWidth-30)/3*2,
                            height: 60,
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Lịch sử giao hàng',
                              style: TextStyle(
                                  fontFamily: 'arial',
                                  fontSize: 16,
                                  color: Color.fromARGB(255, 32, 32, 32),
                                  fontWeight: FontWeight.normal
                              ),
                            )
                        ),
                      ),

                      Positioned(
                        top: 20,
                        right: 0,
                        child: Container(
                          height: 20,
                          width: 20,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: AssetImage('assets/image/righticon.png')
                              )
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),

            Padding(
              padding: EdgeInsets.only(left: 20, right: 10),
              child: Container(
                height: 1,
                decoration: BoxDecoration(
                    color: Colors.blueGrey
                ),
              ),
            ),

            ///Lịch sử đặt đồ ăn
            Padding(
              padding: EdgeInsets.only(left: 20, right: 10),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder:(context) => SCREENhistoryfood()));
                },
                child: Container(
                  height: 60,
                  decoration: BoxDecoration(

                  ),
                  child: Stack(
                    children: <Widget>[
                      Positioned(
                        top: 0,
                        left: 0,
                        child: Container(
                            width: (screenWidth-30)/3*2,
                            height: 60,
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Lịch sử đặt đồ ăn',
                              style: TextStyle(
                                  fontFamily: 'arial',
                                  fontSize: 16,
                                  color: Color.fromARGB(255, 32, 32, 32),
                                  fontWeight: FontWeight.normal
                              ),
                            )
                        ),
                      ),

                      Positioned(
                        top: 20,
                        right: 0,
                        child: Container(
                          height: 20,
                          width: 20,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: AssetImage('assets/image/righticon.png')
                              )
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),

            Padding(
              padding: EdgeInsets.only(left: 20, right: 10),
              child: Container(
                height: 1,
                decoration: BoxDecoration(
                    color: Colors.blueGrey
                ),
              ),
            ),

            Container(height: 50,),

            //Phần tính năng
            Padding(
                padding: EdgeInsets.only(left: 20),
                child: Text(
                  'Tính năng',
                  style: TextStyle(
                      fontFamily: 'arial',
                      fontSize: 20,
                      color: Colors.black,
                      fontWeight: FontWeight.bold
                  ),
                )
            ),

            Container(height: 20,),

            ///xin làm tài xế
            Padding(
              padding: EdgeInsets.only(left: 20, right: 10),
              child: GestureDetector(
                onTap: () async {
                  if (await getData(currentAccount.id)) {
                    toastMessage('bạn đã gửi yêu cầu rồi vui lòng chờ xác minh');
                  } else {
                    Navigator.push(context, MaterialPageRoute(builder:(context) => SCREENfillbikerequest()));
                  }

                },
                child: Container(
                  height: 60,
                  decoration: BoxDecoration(

                  ),
                  child: Stack(
                    children: <Widget>[
                      Positioned(
                        top: 0,
                        left: 0,
                        child: Container(
                            width: (screenWidth-30)/3*2,
                            height: 60,
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Nộp đơn làm tài xế Rabit',
                              style: TextStyle(
                                  fontFamily: 'arial',
                                  fontSize: 16,
                                  color: Color.fromARGB(255, 32, 32, 32),
                                  fontWeight: FontWeight.normal
                              ),
                            )
                        ),
                      ),

                      Positioned(
                        top: 20,
                        right: 0,
                        child: Container(
                          height: 20,
                          width: 20,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: AssetImage('assets/image/righticon.png')
                              )
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),

            Padding(
              padding: EdgeInsets.only(left: 20, right: 10),
              child: Container(
                height: 1,
                decoration: BoxDecoration(
                    color: Colors.blueGrey
                ),
              ),
            ),

            ///chăm sóc khách hàng
            Padding(
              padding: EdgeInsets.only(left: 20, right: 10),
              child: GestureDetector(
                onTap: () {

                },
                child: Container(
                  height: 60,
                  decoration: BoxDecoration(

                  ),
                  child: Stack(
                    children: <Widget>[
                      Positioned(
                        top: 0,
                        left: 0,
                        child: Container(
                            width: (screenWidth-30)/3*2,
                            height: 60,
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Liên hệ CSKH',
                              style: TextStyle(
                                  fontFamily: 'arial',
                                  fontSize: 16,
                                  color: Color.fromARGB(255, 32, 32, 32),
                                  fontWeight: FontWeight.normal
                              ),
                            )
                        ),
                      ),

                      Positioned(
                        top: 20,
                        right: 0,
                        child: Container(
                          height: 20,
                          width: 20,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: AssetImage('assets/image/righticon.png')
                              )
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),

            Padding(
              padding: EdgeInsets.only(left: 20, right: 10),
              child: Container(
                height: 1,
                decoration: BoxDecoration(
                    color: Colors.blueGrey
                ),
              ),
            ),

            Container(height: 50,),

            //Phần tài khoản của tôi
            Padding(
              padding: EdgeInsets.only(left: 20),
                child: Text(
                  'Tài khoản của tôi',
                  style: TextStyle(
                      fontFamily: 'arial',
                      fontSize: 20,
                      color: Colors.black,
                      fontWeight: FontWeight.bold
                  ),
                )
            ),

            Container(height: 20,),

            Padding(
              padding: EdgeInsets.only(left: 20, right: 10),
              child: Container(
                height: 1,
                decoration: BoxDecoration(
                    color: Colors.blueGrey
                ),
              ),
            ),

            Padding(
              padding: EdgeInsets.only(left: 20, right: 10),
              child: GestureDetector(
                onTap: () async {
                  await _auth.signOut();
                  toastMessage("you delete account request will be sent, you can wait 6-7 days");
                  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => SCREENfirstloading()), (route) => false,);
                },
                child: Container(
                  height: 60,
                  decoration: BoxDecoration(

                  ),
                  child: Stack(
                    children: <Widget>[
                      Positioned(
                        top: 0,
                        left: 0,
                        child: Container(
                            width: (screenWidth-30)/3*2,
                            height: 60,
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Yêu cầu xóa tài khoản',
                              style: TextStyle(
                                  fontFamily: 'arial',
                                  fontSize: 16,
                                  color: Colors.redAccent,
                                  fontWeight: FontWeight.bold
                              ),
                            )
                        ),
                      ),

                      Positioned(
                        top: 20,
                        right: 0,
                        child: Container(
                          height: 20,
                          width: 20,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: AssetImage('assets/image/righticon.png')
                              )
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),

            Padding(
              padding: EdgeInsets.only(left: 20, right: 10),
              child: Container(
                height: 1,
                decoration: BoxDecoration(
                    color: Colors.blueGrey
                ),
              ),
            ),

            Padding(
              padding: EdgeInsets.only(left: 20, right: 10),
              child: GestureDetector(
                onTap: () async {
                  await _auth.signOut();
                  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => SCREENfirstloading()), (route) => false,);
                },
                child: Container(
                  height: 60,
                  decoration: BoxDecoration(

                  ),
                  child: Stack(
                    children: <Widget>[
                      Positioned(
                        top: 0,
                        left: 0,
                        child: Container(
                            width: (screenWidth-30)/3*2,
                            height: 60,
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Đăng xuất',
                              style: TextStyle(
                                  fontFamily: 'arial',
                                  fontSize: 16,
                                  color: Colors.redAccent,
                                  fontWeight: FontWeight.bold
                              ),
                            )
                        ),
                      ),

                      Positioned(
                        top: 20,
                        right: 0,
                        child: Container(
                          height: 20,
                          width: 20,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: AssetImage('assets/image/righticon.png')
                              )
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),

            Padding(
              padding: EdgeInsets.only(left: 20, right: 10),
              child: Container(
                height: 1,
                decoration: BoxDecoration(
                    color: Colors.blueGrey
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
