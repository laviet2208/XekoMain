import 'package:auto_size_text/auto_size_text.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:xekomain/GENERAL/Order/itemsendOrder.dart';
import 'package:xekomain/GENERAL/Tool/Tool.dart';
import 'package:xekomain/OTHER/Button/Buttontype1.dart';

import '../../../FINAL/finalClass.dart';
import '../../../GENERAL/NormalUser/accountLocation.dart';
import '../../../GENERAL/NormalUser/accountNormal.dart';
import '../../../GENERAL/Product/Voucher.dart';
import '../../../GENERAL/Tool/Time.dart';
import '../../../GENERAL/utils/utils.dart';
import '../../FILL_INFOR/SCREENfillitemsendinfo.dart';
import '../../FILL_INFOR/SCREENfillreceiverinfor.dart';
import '../../INUSER/SCREEN_MAIN/SCREENmain.dart';
import '../../VOUCHER/SCREENvoucherchosen.dart';
import 'SCREENitemsend.dart';

class SCREENlocationitemsendst2 extends StatefulWidget {
  final double Distance;
  final accountLocation diemdon;
  final accountLocation diemtra;
  const SCREENlocationitemsendst2({Key? key, required this.Distance, required this.diemdon, required this.diemtra}) : super(key: key);

  @override
  State<SCREENlocationitemsendst2> createState() => _SCREENlocationitemsendst2State();
}

class _SCREENlocationitemsendst2State extends State<SCREENlocationitemsendst2> {
  String setlocation = "";
  String getlocation = "";
  Color receiverMancolor = Color.fromARGB(255, 244, 164, 84);
  Color inforordercolor = Color.fromARGB(255, 244, 164, 84);
  String receiverManText = 'Chọn người nhận hàng';
  String infororderText = 'Thêm thông tin hàng hóa';
  final locationNotecontroller = TextEditingController();
  final Nametroller = TextEditingController();
  final Phonecontroller = TextEditingController();
  final Notecontroller = TextEditingController();
  final Weighttroller = TextEditingController();
  final Typecontroller = TextEditingController();
  final Feecontroller = TextEditingController();
  double cost = 0;
  bool isLoading = false;
  String voucherMoney = '0đ';
  final vouchercontroller = TextEditingController();

  bool bookingloading = false;
  bool voucherloading = false;

  int getCost(double distance) {
    int cost = 0;
    if (distance >= ItemCost.departKM) {
      cost += ItemCost.departKM.toInt() * ItemCost.departCost.toInt(); // Giá cước cho 2km đầu tiên (10.000 VND/km * 2km)
      distance -= ItemCost.departKM; // Trừ đi 2km đã tính giá cước
      cost = cost + ((distance - ItemCost.departKM) * ItemCost.perKMcost).toInt();
    } else {
      cost += (distance * ItemCost.departCost).toInt(); // Giá cước cho khoảng cách dưới 2km
    }
    return cost;
  }

  Future<void> pushitemSendOrder(itemsendOrder itemsend) async {
    try {
      DatabaseReference databaseRef = FirebaseDatabase.instance.reference();
      await databaseRef.child('Order/itemsendOrder').child(itemsend.id).set(itemsend.toJson());
      print('Đẩy Order thành công');
      setState(() {
        bookingloading = false;
      });
      if (mounted) {
        toastMessage('Đặt đơn thành công , vui lòng kiểm tra lịch sử');
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SCREENmain()));
      }
    } catch (error) {
      print('Đã xảy ra lỗi khi đẩy catchOrder: $error');
      throw error;
    }
  }

  void VoucherChange() {
    if (chosenvoucher.id != '') {
      voucherMoney = (chosenvoucher.type == 0) ? (getStringNumber(chosenvoucher.totalmoney) + 'đ') : (getStringNumber(chosenvoucher.totalmoney) + '%');
    } else {
      voucherMoney = (chosenvoucher.type == 0) ? '0đ' : '0%';
    }
  }

  Future<void> getData1(String id) async {
    final reference = FirebaseDatabase.instance.reference();
    await reference.child("VoucherStorage/" + id).onValue.listen((event) {
      final dynamic orders = event.snapshot.value;
      if (orders != null) {
        Voucher a = Voucher.fromJson(orders);
        if (a.useCount < a.maxCount) {
          if (compareTimes(Time(second: DateTime.now().second, minute: DateTime.now().minute, hour: DateTime.now().hour, day: DateTime.now().day, month: DateTime.now().month, year: DateTime.now().year), a.endTime) && compareTimes(a.startTime, Time(second: DateTime.now().second, minute: DateTime.now().minute, hour: DateTime.now().hour, day: DateTime.now().day, month: DateTime.now().month, year: DateTime.now().year))) {
            if (a.mincost <= cost) {
              if (a.totalmoney < cost) {
                if (a.LocationId == currentAccount.Area) {
                  if (a.Otype == '1') {
                    chosenvoucher.totalmoney = a.totalmoney;
                    chosenvoucher.id = a.id;
                    chosenvoucher.startTime = a.startTime;
                    chosenvoucher.endTime = a.endTime;
                    chosenvoucher.LocationId = a.LocationId;
                    chosenvoucher.tenchuongtrinh = a.tenchuongtrinh;
                    chosenvoucher.useCount = a.useCount;
                    VoucherChange();
                    Navigator.of(context).pop();
                    setState(() {

                    });
                  } else {
                    toastMessage('Voucher không áp dụng');
                  }
                } else {
                  toastMessage('Voucher không áp dụng cho khu vực này');
                }
              } else {
                toastMessage('Giá trị đơn phái lớn hơn số tiền giảm');
              }
            } else {
              toastMessage('Đơn của bạn chưa đủ điều kiện áp dụng');
            }
          } else {
            toastMessage('Voucher không trong thời hạn dùng');
          }
        } else {
          toastMessage('Voucher này đã hết lượt dùng');
        }

      }

      setState(() {

      });
    });
  }

  Future<void> pushVoucherData(int count, String id) async {
    try {
      DatabaseReference databaseRef = FirebaseDatabase.instance.reference();
      await databaseRef.child("VoucherStorage/" + id).child('useCount').set(count);
      if (mounted) {
        toastMessage('Đặt đơn thành công , vui lòng kiểm tra lịch sử');
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SCREENmain()));
      }
    } catch (error) {
      print('Đã xảy ra lỗi khi đẩy catchOrder: $error');
      throw error;
    }
  }

  bool isNumericString(String input) {
    final numericRegex = RegExp(r'^[0-9]+$');
    return numericRegex.hasMatch(input);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.diemdon.firstText == "NA") {
      setlocation = widget.diemdon.Longitude.toString() + " , " + widget.diemdon.Latitude.toString();
    } else {
      setlocation = widget.diemdon.firstText;
    }

  }
  @override
  Widget build(BuildContext context) {
    cost = getCost(widget.Distance).toDouble();
    currentReceiver.location = widget.diemtra;
    if (currentReceiver.name != "NA") {
      receiverManText = currentReceiver.name + '-' + currentReceiver.phoneNum;
    }

    if (widget.diemtra.firstText == "NA") {
      getlocation = widget.diemtra.Longitude.toString() + " , " + widget.diemtra.Latitude.toString();
    } else {
      getlocation = widget.diemtra.firstText;
    }

    if (currentitemdetail.weight != -1) {
      infororderText = currentitemdetail.weight.toString() + " kg. " + currentitemdetail.type + " .Thu hộ : " + getStringNumber(currentitemdetail.codFee) + 'đ';
      if (currentitemdetail.codFee > 0) {
        cost = cost + 5000;
      }
    }

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return WillPopScope(
        child: Scaffold(
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
                    width: screenWidth,
                    height: screenHeight/5,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color.fromARGB(255, 255, 217, 169), Color.fromARGB(255, 255, 123, 64)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        stops: [0.0, 1.0],
                      ),
                    ),

                    child: Stack(
                      children: <Widget>[
                        Positioned(
                          top: 40,
                          left: 10,
                          child: GestureDetector(
                            onTap: () {
                              currentReceiver.changeToDefault();
                              currentitemdetail.changeToDefault();
                              Navigator.push(context, MaterialPageRoute(builder:(context) => SCREENitemsend()));
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
                      ],
                    ),
                  ),
                ),

                Positioned(
                  top: screenHeight/7,
                  left: 18,
                  child: Container(
                    width: screenWidth - 36,
                    height: screenHeight / 2.2,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey,
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),

                    child: Stack(
                      children: <Widget>[
                        ///điểm lấy hàng
                        Positioned(
                          top: 15,
                          left: 15,
                          child: Container(
                            height: screenWidth / 17,
                            width: screenWidth / 17,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                image: AssetImage('assets/image/bluecircle.png'),
                              ),
                            ),
                          ),
                        ),

                        Positioned(
                          top: 18,
                          left: 20 + screenWidth / 17,
                          child: Text(
                            compactString(35, setlocation),
                            style: TextStyle(
                                fontSize: 14,
                                fontFamily: 'arial',
                                color: Colors.black,
                                fontWeight: FontWeight.bold
                            ),
                          ),
                        ),

                        Positioned(
                          top: 18 + screenWidth / 17,
                          left: 20 + screenWidth / 17,
                          child: Text(
                            currentAccount.name + "-" + currentAccount.phoneNum,
                            style: TextStyle(
                                fontSize: 14,
                                fontFamily: 'arial',
                                color: Colors.black45,
                                fontWeight: FontWeight.bold
                            ),
                          ),
                        ),

                        ///điểm nhận hàng
                        Positioned(
                          top: 75,
                          left: 15,
                          child: Container(
                            height: screenWidth / 17,
                            width: screenWidth / 17,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                image: AssetImage('assets/image/iconlocation.png'),
                              ),
                            ),
                          ),
                        ),

                        Positioned(
                          top: 78,
                          left: 20 + screenWidth / 17,
                          child: Text(
                            compactString(35, getlocation),
                            style: TextStyle(
                                fontSize: 14,
                                fontFamily: 'arial',
                                color: Colors.black,
                                fontWeight: FontWeight.bold
                            ),
                          ),
                        ),

                        Positioned(
                          top: 78 + screenWidth / 17,
                          left: 20 + screenWidth / 17,
                          child: GestureDetector(
                            onTap: () {
                              currentReceiver.phoneNum = 'NA';
                              currentReceiver.name = 'NA';
                              currentReceiver.note = 'NA';
                              currentReceiver.locationNote = 'NA';
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      content: Container(
                                        height: screenHeight * 0.75,
                                        width: screenWidth,
                                        child: ListView(
                                          children: [
                                            Container(height: 20,),

                                            Padding(
                                              padding: EdgeInsets.only(left: 10),
                                              child: Text(
                                                'Người nhận',
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 24,
                                                    fontFamily: 'arial',
                                                    fontWeight: FontWeight.bold
                                                ),
                                              ),
                                            ),

                                            Container(height: 20,),

                                            Padding(
                                              padding: EdgeInsets.only(left: 10),
                                              child: Text(
                                                'Địa chỉ',
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

                                                  child: Text(
                                                    "   " + compactString(45, getlocation),
                                                    style: TextStyle(
                                                        fontSize: 14,
                                                        fontFamily: 'arial',
                                                        color: Colors.black
                                                    ),
                                                  ),
                                                )
                                            ),

                                            Container(height: 20,),

                                            Padding(
                                              padding: EdgeInsets.only(left: 10),
                                              child: Text(
                                                'Số tầng , số nhà (không bắt buộc)',
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
                                                        controller: locationNotecontroller,
                                                        style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 16,
                                                          fontFamily: 'arial',
                                                        ),
                                                        decoration: InputDecoration(
                                                          border: InputBorder.none,
                                                          hintText: 'Ghi chú địa chỉ',
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
                                                'Tên người liên lạc (bắt buộc)',
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
                                                        controller: Nametroller,
                                                        style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 16,
                                                          fontFamily: 'arial',
                                                        ),
                                                        decoration: InputDecoration(
                                                          border: InputBorder.none,
                                                          hintText: 'Tên liên lạc',
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
                                                'Số điện thoại (bắt buộc)',
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
                                                        controller: Phonecontroller,
                                                        style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 16,
                                                          fontFamily: 'arial',
                                                        ),
                                                        decoration: InputDecoration(
                                                          border: InputBorder.none,
                                                          hintText: 'số điện thoại',
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
                                                'Ghi chú cho tài xế (không bắt buộc)',
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
                                                        controller: Notecontroller,
                                                        style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 16,
                                                          fontFamily: 'arial',
                                                        ),
                                                        decoration: InputDecoration(
                                                          border: InputBorder.none,
                                                          hintText: 'số điện thoại',
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
                                              child: ButtonType1(Height: 60, Width: screenWidth-20, color: Color.fromARGB(255, 244, 164, 84), radiusBorder: 30, title: 'Xác nhận', fontText: 'arial', colorText: Colors.white,
                                                  onTap: () {
                                                    if (Nametroller.text.isEmpty || Phonecontroller.text.isEmpty) {
                                                      toastMessage('vui lòng điền đủ mục bắt buộc');
                                                    } else {
                                                      currentReceiver.name = Nametroller.text.toString();
                                                      currentReceiver.phoneNum = Phonecontroller.text.toString();
                                                      if (locationNotecontroller.text.isNotEmpty) {
                                                        currentReceiver.locationNote = locationNotecontroller.text.toString();
                                                      }
                                                      if (Notecontroller.text.isNotEmpty) {
                                                        currentReceiver.note = Notecontroller.text.toString();
                                                      }
                                                      setState(() {

                                                      });
                                                      Navigator.of(context).pop();
                                                    }
                                                  }),
                                            )
                                          ],
                                        ),
                                      ),
                                    );
                                  }
                              );
                            },
                            child: Container(
                              child: Text(
                                receiverManText,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: 'arial',
                                  color: receiverMancolor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),

                        ///làm màu
                        Positioned(
                          top: 110 + screenWidth / 17,
                          left: 20,
                          child: Container(
                            height: 1,
                            width: screenWidth - 36 - 40,
                            decoration: BoxDecoration(
                                color: Colors.grey
                            ),
                          ),
                        ),

                        Positioned(
                          top: 145,
                          left: 10,
                          child: Container(
                            height: screenWidth / 12,
                            width: screenWidth / 12,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                image: AssetImage('assets/image/linhtinh3.png'),
                              ),
                            ),
                          ),
                        ),

                        Positioned(
                          top: 148,
                          left: 20 + screenWidth / 17,
                          child: Text(
                            'Lấy hàng ngay(Trong 15 phút)',
                            style: TextStyle(
                                fontSize: 14,
                                fontFamily: 'arial',
                                color: Colors.black,
                                fontWeight: FontWeight.bold
                            ),
                          ),
                        ),

                        Positioned(
                          top: 145 + screenWidth / 17,
                          left: 20 + screenWidth / 17,
                          child: GestureDetector(
                            onTap: () {

                            },
                            child: Container(
                              child: Text(
                                'Nhanh chóng và tiện lợi',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontFamily: 'arial',
                                  color: receiverMancolor,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ),
                          ),
                        ),

                        Positioned(
                          top: 195,
                          left: 10,
                          child: Container(
                            height: screenWidth / 12,
                            width: screenWidth / 12,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                image: AssetImage('assets/image/linhtinh4.png'),
                              ),
                            ),
                          ),
                        ),

                        Positioned(
                          top: 198,
                          left: 20 + screenWidth / 17,
                          child: Text(
                            'Xe máy',
                            style: TextStyle(
                                fontSize: 14,
                                fontFamily: 'arial',
                                color: Colors.black,
                                fontWeight: FontWeight.bold
                            ),
                          ),
                        ),

                        Positioned(
                          top: 195 + screenWidth / 17,
                          left: 20 + screenWidth / 17,
                          child: GestureDetector(
                            onTap: () {

                            },
                            child: Container(
                              child: Text(
                                'Tối đa 50kg (50x50x50cm)',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontFamily: 'arial',
                                  color: Colors.green,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ),
                          ),
                        ),

                        Positioned(
                          top: 235 + screenWidth / 17,
                          left: 20,
                          child: Container(
                            height: 1,
                            width: screenWidth - 36 - 40,
                            decoration: BoxDecoration(
                                color: Colors.grey
                            ),
                          ),
                        ),

                        ///thông tin hàng hóa
                        Positioned(
                          top: 265,
                          left: 15,
                          child: Container(
                            height: screenWidth / 12,
                            width: screenWidth / 12,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                image: AssetImage('assets/image/linhtinh5.png'),
                              ),
                            ),
                          ),
                        ),

                        Positioned(
                          top: 268,
                          left: 25 + screenWidth / 17,
                          child: Text(
                            'Thông tin hàng hóa',
                            style: TextStyle(
                                fontSize: 14,
                                fontFamily: 'arial',
                                color: Colors.black,
                                fontWeight: FontWeight.bold
                            ),
                          ),
                        ),

                        Positioned(
                          top: 268 + screenWidth / 17,
                          left: 25 + screenWidth / 17,
                          child: GestureDetector(
                            onTap: () {
                              currentitemdetail.weight = -1;
                              currentitemdetail.type = 'NA';
                              currentitemdetail.codFee = -1;
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      content: Container(
                                        width: screenWidth,
                                        height: screenHeight * 0.5,
                                        child: ListView(
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.only(left: 10, right: screenWidth - 40),
                                              child: GestureDetector(
                                                onTap: () {
                                                  //Navigator.push(context, MaterialPageRoute(builder:(context) => SCREENlocationitemsendst2(Distance: widget.Distance,)));
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
                                              child: Text(
                                                'Chi tiết hàng hóa',
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 24,
                                                    fontFamily: 'arial',
                                                    fontWeight: FontWeight.bold
                                                ),
                                              ),
                                            ),

                                            Container(height: 20,),

                                            Padding(
                                              padding: EdgeInsets.only(left: 10),
                                              child: Text(
                                                'Cân nặng (bắt buộc)',
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
                                                        controller: Weighttroller,
                                                        style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 16,
                                                          fontFamily: 'arial',
                                                        ),
                                                        decoration: InputDecoration(
                                                          border: InputBorder.none,
                                                          hintText: 'Cân nặng(kg)',
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
                                                'Loại hàng (bắt buộc)',
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
                                                        controller: Typecontroller,
                                                        style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 16,
                                                          fontFamily: 'arial',
                                                        ),
                                                        decoration: InputDecoration(
                                                          border: InputBorder.none,
                                                          hintText: 'ví dụ : thực phẩm , đồ gia dụng , ...',
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
                                                'Phí thu hộ (bắt buộc)',
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
                                                        controller: Feecontroller,
                                                        style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 16,
                                                          fontFamily: 'arial',
                                                        ),
                                                        decoration: InputDecoration(
                                                          border: InputBorder.none,
                                                          hintText: 'Phí thu hộ tối thiểu là 1.000 VND hoặc 0 VND',
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
                                              child: ButtonType1(Height: 60, Width: screenWidth-20, color: Color.fromARGB(255, 244, 164, 84), radiusBorder: 30, title: 'Xác nhận', fontText: 'arial', colorText: Colors.white,
                                                  onTap: () {
                                                    if (Typecontroller.text.isEmpty || Weighttroller.text.isEmpty || Feecontroller.text.isEmpty) {
                                                      toastMessage('phải điền đầy đủ các mục bắt buộc');
                                                    } else {
                                                      if (isNumericString(Weighttroller.text.toString()) && isNumericString(Feecontroller.text.toString())) {
                                                        if (int.parse(Feecontroller.text.toString()) >= 1000 || int.parse(Feecontroller.text.toString()) == 0) {
                                                          if (int.parse(Weighttroller.text.toString()) > 0) {
                                                            currentitemdetail.codFee = double.parse(Feecontroller.text.toString());
                                                            currentitemdetail.type = Typecontroller.text.toString();
                                                            currentitemdetail.weight = double.parse(Weighttroller.text.toString());
                                                            setState(() {

                                                            });
                                                            Navigator.of(context).pop();
                                                          } else {
                                                            toastMessage('cân nặng phải > 0');
                                                          }
                                                        } else {
                                                          toastMessage('phí thu hộ chưa hợp lệ');
                                                        }
                                                      } else {
                                                        toastMessage('phải điền đúng định dạng số');
                                                      }
                                                    }
                                                  }),
                                            )
                                          ],
                                        ),
                                      ),
                                    );
                                  }
                              );
                            },
                            child: Container(
                              child: Text(
                                infororderText,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: 'arial',
                                  color: inforordercolor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),

                      ],
                    ),
                  ),
                ),

                Positioned(
                  bottom: screenHeight/5 + 40,
                  left: 20,
                  child: Container(
                    height: 1,
                    width: screenWidth - 40,
                    decoration: BoxDecoration(
                        color: Colors.grey
                    ),
                  ),
                ),

                Positioned(
                  bottom: screenHeight/5,
                  left: 18,
                  child: Text(
                    "Tổng tiền ",
                    style: TextStyle(
                      fontFamily: 'arial',
                      fontWeight: FontWeight.bold,
                      fontSize: 20
                    ),
                  ),
                ),

                Positioned(
                  bottom: screenHeight/5,
                  right: 18,
                  child: Text(
                    getStringNumber(cost.toDouble()) + "đ",
                    style: TextStyle(
                        fontFamily: 'arial',
                        fontWeight: FontWeight.bold,
                        fontSize: 20
                    ),
                  ),
                ),

                Positioned(
                  bottom: screenHeight/6,
                  right: 18,
                  child: Text(
                    "- " + voucherMoney,
                    style: TextStyle(
                        fontFamily: 'arial',
                        color: Color.fromARGB(255, 244, 164, 84),
                        fontWeight: FontWeight.bold,
                        fontSize: 14
                    ),
                  ),
                ),

                Positioned(
                  bottom: 60,
                  left: 18,
                  child: Container(
                    width: screenWidth/2 - 28,
                    height: 60,
                    child: ButtonType1(Height: 60, Width: screenWidth/2 - 28, color: Color.fromARGB(255, 244, 164, 84), radiusBorder: 30, title: 'Đặt đơn', fontText: 'arial', colorText: Colors.white,
                        onTap: () async {
                           if (currentReceiver.name != 'NA') {
                             if (currentitemdetail.type != 'NA') {
                               setState(() {
                                 bookingloading = true;
                               });

                               itemsendOrder itemorder = itemsendOrder(
                                   id: generateID(20),
                                   cost: cost.toDouble() - chosenvoucher.totalmoney,
                                   owner: currentAccount,
                                   shipper: accountNormal(id: "NA", avatarID: "NA", createTime: Time(second: 0, minute: 0, hour: 0, day: 0, month: 0, year: 0), status: 1, name: "NA", phoneNum: "NA", type: 0, locationHis: accountLocation(phoneNum: '', LocationID: '', Latitude: 0, Longitude: 0, firstText: '', secondaryText: ''), voucherList: [], totalMoney: 0, Area: ''),
                                   status: 'A',
                                   endTime: Time(second: 0, minute: 0, hour: 0, day: 0, month: 0, year: 0),
                                   startTime: getCurrentTime(),
                                   cancelTime: Time(second: 0, minute: 0, hour: 0, day: 0, month: 0, year: 0),
                                   receiveTime: Time(second: 0, minute: 0, hour: 0, day: 0, month: 0, year: 0),
                                   locationset: widget.diemdon,
                                   receiver: currentReceiver,
                                   itemdetails: currentitemdetail,
                                   voucher: chosenvoucher,
                                   costFee: ItemCost
                               );
                               if (chosenvoucher.id != '') {
                                 await pushVoucherData(chosenvoucher.useCount + 1, chosenvoucher.id);
                               }
                               await pushitemSendOrder(itemorder);
                             } else {
                               toastMessage('Bạn vui lòng hoàn thiện thông tin hàng hóa');
                             }
                           } else {
                             toastMessage('Bạn vui lòng hoàn thiện thông tin người nhận');
                           }
                        }, loading: bookingloading),
                  ),
                ),

                //Nút ưu đãi
                Positioned(
                  bottom: 60,
                  right: 18,
                  child: Container(
                    width: screenWidth/2 - 28,
                    height: 60,
                    child: ButtonType1(Height: 60, Width: screenWidth/2 - 28, color: Color.fromARGB(255, 255, 247, 237), radiusBorder: 30, title: 'Ưu đãi', fontText: 'arial', colorText: Color.fromARGB(255, 255, 123, 64),
                        onTap: () {
                          vouchercontroller.clear();
                          chosenvoucher.changeToDefault();
                          VoucherChange();
                          setState(() {

                          });
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  content: Container(
                                      width: screenWidth,
                                      height: 90,
                                      child: Stack(
                                        children: <Widget>[
                                          Positioned(
                                            top: 0,
                                            left: 0,
                                            child: Container(
                                              height: 15,
                                              child: AutoSizeText(
                                                'Nhập mã voucher',
                                                style: TextStyle(
                                                    fontSize: 100,
                                                    color: Color.fromARGB(255, 244, 164, 84),
                                                    fontWeight: FontWeight.bold
                                                ),
                                              ),
                                            ),
                                          ),

                                          Positioned(
                                            top: 50,
                                            left: 0,
                                            child: Container(
                                              height: 40,
                                              width: screenWidth/1.5,
                                              decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(10),
                                                  border: Border.all(
                                                      color: Colors.orange,
                                                      width: 1
                                                  )
                                              ),
                                              child: Padding(
                                                padding: EdgeInsets.only(left: 10),
                                                child: Form(
                                                  child: TextFormField(
                                                    controller: vouchercontroller,
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontFamily: 'arial',
                                                    ),

                                                    decoration: InputDecoration(
                                                      border: InputBorder.none,
                                                      hintText: 'Nhập mã voucher',
                                                      hintStyle: TextStyle(
                                                        color: Colors.grey,
                                                        fontFamily: 'arial',
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          )
                                        ],
                                      )
                                  ),

                                  actions: <Widget>[
                                    TextButton(
                                      child: isLoading ? CircularProgressIndicator() : Text('Xác nhận'),
                                      onPressed: isLoading ? null : () async {
                                        setState(() {
                                          isLoading = true;
                                        });
                                        if (vouchercontroller.text.isNotEmpty) {
                                          await getData1(vouchercontroller.text.toString());
                                        } else {
                                          toastMessage('Vui lòng nhập mã');
                                        }
                                        setState(() {
                                          isLoading = false; // Dừng hiển thị loading
                                        });
                                      },
                                    ),

                                    TextButton(
                                      child: Text('Hủy'),
                                      onPressed: () {
                                        chosenvoucher.changeToDefault();
                                        vouchercontroller.clear();
                                        VoucherChange();
                                        Navigator.of(context).pop();
                                        setState(() {

                                        });
                                      },
                                    ),
                                  ],
                                );
                              });
                        },
                        loading: voucherloading),
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
