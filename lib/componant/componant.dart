import 'package:elevator/cubit/appCubit.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../modules/building_screen.dart';

Widget buildItem(List list) {
  return ListView.separated(
      itemBuilder: (context, index) {
        var model = list[index];
        return InkWell(
          onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BuildingScreen(model),
              )),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              children: [
                CircleAvatar(
                  child: Text("${model['id']}"),
                  radius: 20.0,
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("${model['titel']}",
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                overflow: TextOverflow.ellipsis)),
                        Text("${model['description']}",
                            style: TextStyle(
                                color: Colors.grey,
                                overflow: TextOverflow.ellipsis),
                            maxLines: 2),
                      ]),
                ),
                SizedBox(width: 10),
                IconButton(
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (context) => Directionality(
                            textDirection: TextDirection.rtl,
                            child: AlertDialog(
                              title: Text('تأكيد الدفع'),
                              // content: Text(
                              //     'تأكيد عملية الدفع'),
                              actions: <Widget>[
                                TextButton(
                                  child: Text('تراجع', style: TextStyle(color: Colors.red)),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  style: TextButton.styleFrom(backgroundColor: Colors.grey[300]),
                                ),
                                TextButton(
                                  child: Text('تم الدفع',
                                      style: TextStyle(color: Colors.green)),
                                  onPressed: () {
                                    model['month${AppCubit.get(context).dropdownMonthValue.substring(AppCubit.get(context).dropdownMonthValue.length - 1)}'] ==
                                        1
                                        ? AppCubit.get(context)
                                        .updateDb(state: 0, id: model['id'])
                                        : AppCubit.get(context)
                                        .updateDb(state: 1, id: model['id']);
                                    Navigator.of(context).pop();
                                  },
                                  style: TextButton.styleFrom(backgroundColor: Colors.grey[300]),
                                ),
                              ],
                            ),
                          ));
                    },
                    icon:
                        model['month${AppCubit.get(context).dropdownMonthValue.substring(AppCubit.get(context).dropdownMonthValue.length - 1)}'] ==
                                1
                            ? Icon(
                                Icons.check_box,
                                color: Colors.green,
                              )
                            : Icon(
                                Icons.check_box_outline_blank,
                                color: Colors.red,
                              )),
              ],
            ),
          ),
        );
      },
      separatorBuilder: (context, index) => Container(
            width: double.infinity,
            height: 1.0,
            color: Colors.grey,
          ),
      itemCount: list.length);
}

Widget buildPartItem(List list, int buildingId) {
  return ListView.separated(
      itemBuilder: (context, index) {
        var model = list[index];
        return InkWell(
          //onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => BuildingScreen(model),)),
          child: Dismissible(
            background: Container(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Row(
                  children: [
                    Icon(Icons.delete,color: Colors.white,size: 30,),
                    Spacer(),
                    Icon(Icons.delete,color: Colors.white,size: 30,),
                  ],
                ),
              ),
              color: Colors.red,
            ),
            key: UniqueKey(),
            confirmDismiss: (direction) async {
              return await showDialog(
                  context: context,
                  builder: (context) => Directionality(
                    textDirection: TextDirection.rtl,
                    child: AlertDialog(
                          title: Text('تأكيد الحذف'),
                          content:
                              Text('هل انت متأكد من انك تريد ازالة هذة العنصر'),
                          actions: <Widget>[
                            TextButton(
                              child: Text('تراجع'),
                              onPressed: () {
                                Navigator.of(context).pop(false);
                              },
                            ),
                            TextButton(
                              child: Text('حذف',
                                  style: TextStyle(color: Colors.red)),
                              onPressed: () {
                                Navigator.of(context)
                                    .pop(true); // Close the dialog
                              },
                            ),
                          ],
                        ),
                  ));
            },
            onDismissed: (direction) {
              AppCubit.get(context).deletepartFormDb(model['id'], buildingId);
              Navigator.of(context).pop(); // Close the dialog
              // Close the dialog
            },
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                children: [
                  CircleAvatar(
                    child: Text("${model['id']}"),
                    radius: 20.0,
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("${model['titel']}",
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  overflow: TextOverflow.ellipsis)),
                          Text("${model['description']}",
                              style: TextStyle(
                                  color: Colors.grey,
                                  overflow: TextOverflow.ellipsis),
                              maxLines: 2),
                        ]),
                  ),
                  SizedBox(width: 10),
                  Row(
                    children: [
                      Column(
                        children: [
                          Text('السعر'),
                          Text('${model['price']}'),
                        ],
                      ),
                      SizedBox(width: 20),
                      Column(
                        children: [
                          Text('التاريخ'),
                          Text('${model['time']}'),
                          Text('${model['date']}'),
                        ],
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        );
      },
      separatorBuilder: (context, index) => Container(
            width: double.infinity,
            height: 1.0,
            color: Colors.grey,
          ),
      itemCount: list.length);
}

void toast(String messange, Color color) {
  Fluttertoast.showToast(
      msg: messange,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: color,
      textColor: Colors.white,
      fontSize: 16.0);
}
