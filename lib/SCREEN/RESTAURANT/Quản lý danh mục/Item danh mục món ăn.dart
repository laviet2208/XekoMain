import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:xekomain/GENERAL/Product/Danh%20m%E1%BB%A5c%20%C4%91%E1%BB%93%20%C4%83n.dart';

import '../../../GENERAL/Tool/Tool.dart';
import 'Item món ăn trong danh mục.dart';

class ITEMdanhsachmonan extends StatefulWidget {
  final double width;
  final double height;
  final String id;
  final VoidCallback ontap;
  const ITEMdanhsachmonan({Key? key, required this.width, required this.height, required this.id, required this.ontap}) : super(key: key);

  @override
  State<ITEMdanhsachmonan> createState() => _ITEMdanhsachmonanState();
}

class _ITEMdanhsachmonanState extends State<ITEMdanhsachmonan> {
  FoodDirectory foodDirectory = FoodDirectory(id: '', mainName: '', foodList: [], ownerID: '');

  void getData() {
    final reference = FirebaseDatabase.instance.reference();
    reference.child("FoodDirectory/" + widget.id).onValue.listen((event) {
      final dynamic restaurant = event.snapshot.value;
      FoodDirectory acc = FoodDirectory.fromJson(restaurant);
      foodDirectory.id = acc.id;
      foodDirectory.mainName = acc.mainName;
      foodDirectory.foodList = acc.foodList;
      foodDirectory.ownerID = acc.ownerID;
      setState(() {});
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
    return Container(
      width: widget.width - 20,
      height: widget.height,
      child: Stack(
        children: <Widget>[
          Positioned(
              top: 0,
              left: 0,
              child: Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        fit: BoxFit.cover,
                        image: AssetImage('assets/image/icontrang1/fire.png')
                    )
                ),
              )
          ),

          Positioned(
            top: 5,
            left: 30,
            child: Text(
              compactString(20, foodDirectory.mainName),
              style: TextStyle(
                  fontFamily: 'DMSans_regu',
                  color: Colors.black,
                  fontSize: widget.width/18,
                  fontWeight: FontWeight.bold
              ),
            ),
          ),

          Positioned(
            top: 50,
            left: 0,
            child: Container(
              width: widget.width - 20,
              height: 248,
              decoration: BoxDecoration(
                  color: Colors.white
              ),

              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: foodDirectory.foodList.length,
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
                    child: InkWell(
                      onTap: () {

                      },
                      child: ITEMfoodIndirect(id: foodDirectory.foodList[index], ontap: () { widget.ontap(); },),),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
