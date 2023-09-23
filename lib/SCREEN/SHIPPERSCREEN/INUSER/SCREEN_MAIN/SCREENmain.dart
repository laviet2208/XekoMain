import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:xekomain/SCREEN/SHIPPERSCREEN/INUSER/Th%C3%B4ng%20tin%20t%C3%A0i%20kho%E1%BA%A3n/PAGEaccountinfo.dart';
import '../PAGE_COMMINGSOON/PAGEcommingsoon.dart';
import '../PAGE_FOOD/PAGEfood.dart';
import '../PAGE_HISTORY/PAGEhistory.dart';
import '../PAGE_HOME/PAGEhome.dart';
import '../PAGE_itemsend/PAGEitemsend.dart';

class SCREENmainshipping extends StatefulWidget {
  const SCREENmainshipping({Key? key}) : super(key: key);

  @override
  State<SCREENmainshipping> createState() => _SCREENmainState();
}

class _SCREENmainState extends State<SCREENmainshipping> {
  int selectedIndex = 0;
  String title = 'Đơn xe ôm , taxi';

  Widget getBodyWidget() {
    // Dựa vào selectedIndex, trả về phần body tương ứng
    switch (selectedIndex) {
      case 0 :
        return PAGEhome();
      case 1 :
        return PAGEitemsend();
      case 2 :
        return PAGEfood();
      case 3 :
        return PAGEhistory();
      case 4 :
        return PAGEaccountinfo();
      default:
        return PAGEcommingsoon();
    }
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
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  title,
                  style: TextStyle(
                    fontFamily: "logo_font_1",
                    fontSize: screenWidth/19.65,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 0, 177, 79),
                  ),
                ),

                SizedBox(width: screenWidth/5,)
              ],
            ),
          ),


      body: getBodyWidget(),

      bottomNavigationBar: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20),
          child: GNav(
            backgroundColor: Colors.white,
            color: Colors.grey,
            activeColor: Color.fromARGB(255, 0, 177, 79),
            tabBackgroundColor: Color.fromARGB(100, 200, 225, 252),
            gap: 8,
            onTabChange: (index) {
              setState(() {
                selectedIndex = index;
                if (index == 0) {
                  title = 'ĐƠN XE ÔM , TAXI';
                }
                if (index == 1) {
                  title = 'ĐƠN GIAO HÀNG';
                }
                if (index == 2) {
                  title = 'ĐƠN ĐỒ ĂN';
                }
                if (index == 3) {
                  title = 'LỊCH SỬ ĐƠN';
                }
                if (index == 4) {
                  title = 'THÔNG TIN TÀI KHOẢN';
                }
              });
            },

            padding: EdgeInsets.all(12),
            tabs: const [
              GButton(
                icon: Icons.electric_bike,
                text: ("Xe ôm, taxi"),
              ),

              GButton(
                icon: Icons.local_shipping,
                text: ("Giao hàng"),
              ),

              GButton(
                icon: Icons.fastfood_rounded,
                text: ("Đồ ăn"),
              ),

              GButton(
                icon: Icons.history,
                text: ("Lịch sử"),
              ),

              GButton(
                icon: Icons.account_circle_sharp,
                text: ("Tài Khoản"),
              ),
            ],
          ),
        ),
      ),

    ),
      onWillPop: () async {
        return false;
      },
    );
  }
}
