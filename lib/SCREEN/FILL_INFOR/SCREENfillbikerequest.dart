import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';


import '../../FINAL/finalClass.dart';
import '../../GENERAL/Tool/Tool.dart';
import '../../GENERAL/request/bikerRequest.dart';
import '../../GENERAL/utils/utils.dart';
import '../../OTHER/Button/Buttontype1.dart';
import '../INUSER/SCREEN_MAIN/SCREENmain.dart';

class SCREENfillbikerequest extends StatefulWidget {
  const SCREENfillbikerequest({Key? key}) : super(key: key);

  @override
  State<SCREENfillbikerequest> createState() => _SCREENfillbikerequestState();
}

class _SCREENfillbikerequestState extends State<SCREENfillbikerequest> {
  final namecontroller = TextEditingController();
  final phonecontroller = TextEditingController();
  final cmndcontroller = TextEditingController();
  final addresscontroller = TextEditingController();
  final typecontroller = TextEditingController();
  bool loading = false;
  Future<void> pushCatchOrder(bikeRequest request) async {
    try {
      DatabaseReference databaseRef = FirebaseDatabase.instance.reference();
      await databaseRef.child('bikeRequest').child(request.id).set(request.toJson());
      Navigator.push(context, MaterialPageRoute(builder:(context) => SCREENmain()));
    } catch (error) {
      print('Đã xảy ra lỗi khi đẩy catchOrder: $error');
      throw error;
    }
  }
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            color: Colors.white
        ),

        child: ListView(
          children: [
            Container(height: 20,),

            Padding(
              padding: EdgeInsets.only(left: 10, right: screenWidth - 40),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder:(context) => SCREENmain()));
                },
                child: Container(
                  width: 30,
                  height: 30,
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
                    borderRadius: BorderRadius.circular(20),
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: AssetImage('assets/image/backicon1.png'),
                    ),
                  ),
                ),
              ),
            ),

            Container(height: 10,),

            Padding(
              padding: EdgeInsets.only(left: 10),
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'Trở thành tài xế của ',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 24,
                        fontFamily: 'arial',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextSpan(
                      text: 'XEKO',
                      style: TextStyle(
                        color: Color.fromARGB(255, 244, 164, 84), // Màu đỏ cho từ "XEKO"
                        fontSize: 24,
                        fontFamily: 'arial',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),


            Container(height: 20,),

            Padding(
              padding: EdgeInsets.only(left: 10),
              child: Text(
                'Họ và tên tài xế (bắt buộc)',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontFamily: 'arial',
                    fontWeight: FontWeight.normal
                ),
              ),
            ),

            Container(height: 10,),

            Padding(
                padding: EdgeInsets.only(left: 10, right: 10),
                child: Container(
                  height: 50,
                  alignment: Alignment.centerLeft,
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
                      border: Border.all(
                        width: 2,
                        color: Colors.grey,
                      )
                  ),

                  child: Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: Form(
                      child: TextFormField(
                        controller: namecontroller,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontFamily: 'arial',
                        ),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Nhập họ và tên của bạn',
                          hintStyle: TextStyle(
                            color: Colors.grey,
                            fontSize: 16,
                            fontFamily: 'arial',
                          ),
                        ),
                      ),
                    ),
                  ),
                )
            ),

            Container(height: 20,),

            Padding(
              padding: EdgeInsets.only(left: 10),
              child: Text(
                'Số điện thoại tài xế (bắt buộc)',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontFamily: 'arial',
                    fontWeight: FontWeight.normal
                ),
              ),
            ),

            Container(height: 10,),

            Padding(
                padding: EdgeInsets.only(left: 10, right: 10),
                child: Container(
                  height: 50,
                  alignment: Alignment.centerLeft,
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
                      border: Border.all(
                        width: 2,
                        color: Colors.grey,
                      )
                  ),

                  child: Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: Form(
                      child: TextFormField(
                        controller: phonecontroller,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontFamily: 'arial',
                        ),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Nhập số điện thoại của bạn',
                          hintStyle: TextStyle(
                            color: Colors.grey,
                            fontSize: 16,
                            fontFamily: 'arial',
                          ),
                        ),
                      ),
                    ),
                  ),
                )
            ),

            Container(height: 20,),

            Padding(
              padding: EdgeInsets.only(left: 10),
              child: Text(
                'Số chứng minh, căn cước công dân( bắt buộc )',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontFamily: 'arial',
                    fontWeight: FontWeight.normal
                ),
              ),
            ),

            Container(height: 10,),

            Padding(
                padding: EdgeInsets.only(left: 10, right: 10),
                child: Container(
                  height: 50,
                  alignment: Alignment.centerLeft,
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
                      border: Border.all(
                        width: 2,
                        color: Colors.grey,
                      )
                  ),

                  child: Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: Form(
                      child: TextFormField(
                        controller: cmndcontroller,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontFamily: 'arial',
                        ),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Nhập số định danh cá nhân của bạn',
                          hintStyle: TextStyle(
                            color: Colors.grey,
                            fontSize: 16,
                            fontFamily: 'arial',
                          ),
                        ),
                      ),
                    ),
                  ),
                )
            ),

            Container(height: 20,),

            Padding(
              padding: EdgeInsets.only(left: 10),
              child: Text(
                'Địa chỉ của tài xế( bắt buộc )',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontFamily: 'arial',
                    fontWeight: FontWeight.normal
                ),
              ),
            ),

            Container(height: 10,),

            Padding(
                padding: EdgeInsets.only(left: 10, right: 10),
                child: Container(
                  height: 50,
                  alignment: Alignment.centerLeft,
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
                      border: Border.all(
                        width: 2,
                        color: Colors.grey,
                      )
                  ),

                  child: Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: Form(
                      child: TextFormField(
                        controller: addresscontroller,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontFamily: 'arial',
                        ),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Nhập địa chỉ của bạn',
                          hintStyle: TextStyle(
                            color: Colors.grey,
                            fontSize: 16,
                            fontFamily: 'arial',
                          ),
                        ),
                      ),
                    ),
                  ),
                )
            ),

            Container(height: 20,),

            Padding(
              padding: EdgeInsets.only(left: 10),
              child: Text(
                'Bạn muốn làm tài xế ô tô hay xe máy ( bắt buộc )',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontFamily: 'arial',
                    fontWeight: FontWeight.normal
                ),
              ),
            ),

            Container(height: 10,),

            Padding(
                padding: EdgeInsets.only(left: 10, right: 10),
                child: Container(
                  height: 50,
                  alignment: Alignment.centerLeft,
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
                      border: Border.all(
                        width: 2,
                        color: Colors.grey,
                      )
                  ),

                  child: Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: Form(
                      child: TextFormField(
                        controller: typecontroller,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontFamily: 'arial',
                        ),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'nhập 1 : xe máy hoặc 2 : ô tô',
                          hintStyle: TextStyle(
                            color: Colors.grey,
                            fontSize: 16,
                            fontFamily: 'arial',
                          ),
                        ),
                      ),
                    ),
                  ),
                )
            ),

            Container(height: 30,),

            Padding(
              padding: EdgeInsets.only(left: 10, right: 10),
              child: ButtonType1(Height: 60, Width: screenWidth-20, color: Color.fromARGB(255, 244, 164, 84), radiusBorder: 30, title: 'Gửi yêu cầu', fontText: 'arial', colorText: Colors.white,
                  onTap: () async{
                     setState(() {
                       loading = true;
                     });

                     if(namecontroller.text.isNotEmpty && phonecontroller.text.isNotEmpty && cmndcontroller.text.isNotEmpty && addresscontroller.text.isNotEmpty && typecontroller.text.isNotEmpty) {
                       if (typecontroller.text.toString() == '1' || typecontroller.text.toString() == '2') {
                         bikeRequest rq = bikeRequest(
                             id: generateID(12),
                             phoneNumber: phonecontroller.text.toString(),
                             cmnd: cmndcontroller.text.toString(),
                             name: namecontroller.text.toString(),
                             address: addresscontroller.text.toString(),
                             type: int.parse(typecontroller.text.toString()),
                             owner: currentAccount);

                         await pushCatchOrder(rq);
                         setState(() {
                           loading = false;
                         });
                       } else {
                         setState(() {
                           loading = false;
                         });
                         toastMessage('bạn phải nhập đúng định dạng 1 hoặc 2');
                       }
                     } else {
                       setState(() {
                         loading = false;
                       });
                       toastMessage('bạn phải nhập đủ thông tin');
                     }
                  }),
            )
          ],
        ),
      ),
    );
  }
}
