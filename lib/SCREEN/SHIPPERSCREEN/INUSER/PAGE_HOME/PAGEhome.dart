import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:xekomain/FINAL/finalClass.dart';
import '../../../../GENERAL/Order/catchOrder.dart';
import '../../ITEM/ITEMcatch.dart';


class PAGEhome extends StatefulWidget {
  const PAGEhome({Key? key}) : super(key: key);

  @override
  State<PAGEhome> createState() => _PAGEhomeState();
}

class _PAGEhomeState extends State<PAGEhome> {
  List<catchOrder> orderList = [];
  
    void getData() {
    final reference = FirebaseDatabase.instance.reference();
    reference.child("Order/catchOrder").onValue.listen((event) {
      orderList.clear();
      final dynamic orders = event.snapshot.value;
      orders.forEach((key, value) {
        catchOrder catchorder = catchOrder.fromJson(value);

        if (catchorder.status == "A" && catchorder.owner.Area == currentAccount.Area && currentAccount.type == catchorder.type) {
          orderList.add(catchorder);
        }
      });
        setState(() {

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
    return Scaffold(
      body: Container(
          child: ListView.builder(
            itemCount: orderList.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.only(left: 10, right: 10, top: 20 , bottom: 20),
                child: InkWell(
                  onTap: () {

                  },
                  child: ITEMcatch(order: orderList[index], width: screenWidth, height: 320),
                ),
              );
            },
          )
      ),
    );
  }
}
