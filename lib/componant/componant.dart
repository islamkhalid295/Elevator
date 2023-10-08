import 'package:elevator/cubit/appCubit.dart';
import 'package:flutter/material.dart';

import '../modules/building_screen.dart';

Widget buildItem(List list){
  return ListView.separated(
      itemBuilder: (context, index) {
        var model = list[index];
        return InkWell(
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => BuildingScreen(model),)),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(children: [
              CircleAvatar(child: Text("${model['id']}"),radius: 20.0,),
              SizedBox(width: 10),
              Expanded(
                child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("${model['titel']}",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,overflow: TextOverflow.ellipsis)),
                      Text("${model['description']}",style: TextStyle(color: Colors.grey,overflow: TextOverflow.ellipsis),maxLines: 2),
                    ]),
              ),
              SizedBox(width: 10),
              IconButton(onPressed: (){
                model['month${AppCubit.get(context).dropdownMonthValue.substring(AppCubit.get(context).dropdownMonthValue.length-1)}'] == 1 ? AppCubit.get(context).updateDb(state: 0, id: model['id']) :AppCubit.get(context).updateDb(state: 1, id: model['id']);
              },
                  icon: model['month${AppCubit.get(context).dropdownMonthValue.substring(AppCubit.get(context).dropdownMonthValue.length-1)}'] == 1 ? Icon(Icons.check_box, color: Colors.green,) :Icon(Icons.check_box_outline_blank, color: Colors.red,)
              ),
              IconButton(onPressed: (){
                //appCubit.get(context).updateDb(state: 'archive', id: model['id']);
              },
                  icon: Icon(Icons.archive_outlined,color: Colors.grey,)
              ),
            ],
            ),
          ),
        );
      },
      separatorBuilder: (context, index) => Container(width: double.infinity, height: 1.0, color: Colors.grey,),
      itemCount:list.length
  );
}

Widget buildPartItem(List list){
  return ListView.separated(
      itemBuilder: (context, index) {
        var model = list[index];
        return InkWell(
          //onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => BuildingScreen(model),)),
          child: Dismissible(
            key: UniqueKey(),
            onDismissed: (direction) {
              AppCubit.get(context).deleteFormDb(model['id']);
            },
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(children: [
                CircleAvatar(child: Text("${model['id']}"),radius: 20.0,),
                SizedBox(width: 10),
                Expanded(
                  child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("${model['titel']}",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,overflow: TextOverflow.ellipsis)),
                        Text("${model['description']}",style: TextStyle(color: Colors.grey,overflow: TextOverflow.ellipsis),maxLines: 2),
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
      separatorBuilder: (context, index) => Container(width: double.infinity, height: 1.0, color: Colors.grey,),
      itemCount:list.length
  );
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