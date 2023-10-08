import 'package:elevator/cubit/appCubit.dart';
import 'package:elevator/cubit/appStates.dart';
import 'package:elevator/modules/parts_screen.dart';
import 'package:elevator/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../shared/shared.dart';
import '../shared/shared.dart';

class BuildingScreen extends StatefulWidget {
  var model;

  BuildingScreen(this.model);

  @override
  State<BuildingScreen> createState() => _BuildingScreenState();
}

class _BuildingScreenState extends State<BuildingScreen> {
  var titelcontroller = TextEditingController();
  var descriptioncontroller = TextEditingController();
  late List<dynamic> colors = List.generate(
      12,
      (index) => widget.model['month${(index + 1)}'] == 1
          ? Colors.orange[300]
          : Colors.grey);
  List<Widget> iconButtons = List.generate(12, (index) {
    return IconButton(
      icon: Icon(Icons.star), // Replace with your desired icon
      onPressed: () {
        // Add your onPressed functionality here
      },
    );
  });

  @override
  void initState() {
    super.initState();
    titelcontroller = TextEditingController(text: widget.model['titel']);
    descriptioncontroller =
        TextEditingController(text: widget.model['description']);
  }

  @override
  Widget build(BuildContext context) {
    AppCubit cubit = AppCubit.get(context);
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Text("متابع المصاعد"),
          elevation: 0,
          backgroundColor: defaultColor[100],
          actions: [
            IconButton(
                icon: Icon(
                  Icons.delete_outline,
                  color: Colors.red,
                ),
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                            title: Text('تأكيد الحذف'),
                            content: Text(
                                'هل انت متأكد من انك تريد ازالة هذة العمارة'),
                            actions: <Widget>[
                              TextButton(
                                child: Text('تراجع'),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                              TextButton(
                                child: Text('حذف',
                                    style: TextStyle(color: Colors.red)),
                                onPressed: () {
                                  AppCubit.get(context)
                                      .deleteFormDb(widget.model['id']);
                                  Navigator.of(context)
                                      .pop(); // Close the dialog
                                  Navigator.of(context)
                                      .pop(); // Close the dialog
                                },
                              ),
                            ],
                          ));
                })
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  children: [
                    Text(
                      'عمارة : ${widget.model['titel']}',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Spacer(),
                    MaterialButton(
                      child: Row(
                        children: [
                          Icon(Icons.add),
                          Text('إضافة قطعة غيار'),
                        ],
                      ),
                      color: defaultColor[300],
                      onPressed: () {
                        cubit.getPartsFromDb(widget.model['id']);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Directionality(
                                  textDirection: TextDirection.rtl,
                                  child: PartsScreen(widget.model)),
                            ));
                      },
                    )
                  ],
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: titelcontroller,
                  enabled: cubit.isEnabled,
                  
                  onTap: () {
                    setState(() {
                      cubit.change(cubit.isEnabled);
                      print("taaaaaaaaaaaaaaaaaaaaaaaaaap");
                    });
                  },
                  decoration: InputDecoration(
                      label: Text(
                        'تعديل اسم العمارة',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      // hintText: '${model['titel']}',
                      border: OutlineInputBorder()),
                ),
                SizedBox(
                  height: 15,
                ),
                TextFormField(
                  controller: descriptioncontroller,
                  enabled: cubit.isEnabled,
                  onTap: () {
                    cubit.isEnabled = true;
                  },
                  decoration: InputDecoration(
                      label: Text(
                        'تعديل الوصف',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      border: OutlineInputBorder()),
                ),
                SizedBox(
                  height: 15,
                ),
                OutlinedButton(

                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: defaultColor),
                    ),
                    child: Text( cubit.isEnabled ?'حفظ' : 'اضغط هنا للتعديل',
                        style: TextStyle(fontSize: 20, color: cubit.isEnabled ? defaultColor : Colors.grey)),
                    onPressed: cubit.isEnabled ? () {
                      cubit.isEnabled = false;
                      cubit.updateBuildingNameDb(
                          titel: titelcontroller.text,
                          description: descriptioncontroller.text,
                          id: widget.model['id']);
                    } : (){
                      cubit.change(true);
                    }),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Container(
                    height: 300,
                    child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4,
                        mainAxisSpacing: 20.0,
                        crossAxisSpacing: 20.0,
                      ),
                      itemCount: 12,
                      itemBuilder: (BuildContext context, int index) {
                        return InkWell(
                          onTap: () {
                            int state;
                            state = widget.model['month${index + 1}'] == 1 ? 0 : 1;
                              cubit.updateBuildingmonthDb(
                                  month: index + 1,
                                  id: widget.model['id'],
                                  state: state).then((value) {
                                    setState(() {
                                      colors[index] = state == 1
                                          ? Colors.orange[300]
                                          : Colors.grey;
                                    });
                                  });


                          },
                          child: Container(
                            width: 1,
                            height: 1,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: colors[index],
                              border: Border.all(color: Colors.black),
                            ),
                            child: Center(
                              child: Text(
                                (index + 1).toString(),
                                style: TextStyle(
                                  fontSize: 20,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
