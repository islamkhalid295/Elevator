import 'package:elevator/cubit/appCubit.dart';
import 'package:elevator/modules/parts_screen.dart';
import 'package:elevator/shared/shared.dart';
import 'package:flutter/material.dart';

class BuildingScreen extends StatefulWidget {
  final model;

  BuildingScreen(this.model);

  @override
  State<BuildingScreen> createState() => _BuildingScreenState();
}

class _BuildingScreenState extends State<BuildingScreen> {
  var titelcontroller = TextEditingController();
  var descriptioncontroller = TextEditingController();
  var pricecontroller = TextEditingController();
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
    pricecontroller =
        TextEditingController(text: widget.model['price'].toString());
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
                      builder: (context) => Directionality(
                            textDirection: TextDirection.rtl,
                            child: AlertDialog(
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
                            ),
                          ));
                })
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                RichText(
                  text: TextSpan(
                    text: 'عمارة : ${titelcontroller.text}',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Container(
                    //   decoration: BoxDecoration(border: Border.all(),borderRadius: BorderRadius.circular(10)),
                    //   child: Padding(
                    //     padding: const EdgeInsets.all(8.0),
                    //     child: Column(
                    //       children: [
                    //         Text('سعر الصيانة',style: TextStyle(fontSize: 20,fontWeight: FontWeight.w300),),
                    //         FittedBox(child: Text('${widget.model['price']}',style: TextStyle(fontSize: 20,fontWeight: FontWeight.w500),))
                    //       ],
                    //     ),
                    //   ),
                    // ),
                    if(cubit.isEnabled)
                    Expanded(
                      child: TextFormField(
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold,color: Colors.black),
                        textAlign: TextAlign.center,
                        controller: pricecontroller,
                        keyboardType: TextInputType.number,
                        enabled: cubit.isEnabled,
                        decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.orangeAccent)),
                            disabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.black)),
                            label: Text(
                              'سعر الصيانة',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            // hintText: '${model['titel']}',
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(0),gapPadding: 5),
                        ),
                      ),
                    ),
                    if(!cubit.isEnabled)
                      Expanded(
                        child: Column(
                          children: [
                            Text('سعر الصيانة',style: TextStyle(
                              fontSize: 15,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              overflow: TextOverflow.ellipsis,
                            ),),
                            Row(
                              children: [
                                Expanded(
                                  child: ConstrainedBox(
                                    constraints: BoxConstraints(maxWidth: MediaQuery.sizeOf(context).width*0.6),
                                    child: Text(pricecontroller.text,style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    SizedBox(width: 30),
                    MaterialButton(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.add),
                          Text('قطع الغيار'),
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
                    ),
                  ],
                ),
                SizedBox(height: 20),
                TextFormField(
                  style: TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                          borderSide:
                          BorderSide(color: Colors.orangeAccent)),
                      disabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black)),
                      label: Text(
                          'اسم العمارة',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      // hintText: '${model['titel']}',
                      border: OutlineInputBorder()),
                  controller: titelcontroller,
                  enabled: cubit.isEnabled,
                ),
                SizedBox(
                  height: 15,
                ),
                TextFormField(
                  style: TextStyle(color: Colors.black),
                  controller: descriptioncontroller,
                  enabled: cubit.isEnabled,
                  decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                          borderSide:
                          BorderSide(color: Colors.orangeAccent)),
                      disabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black)),
                      label: Text(
                          'الوصف',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      // hintText: '${model['titel']}',
                      border: OutlineInputBorder()),
                ),
                SizedBox(
                  height: 15,
                ),
                OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: defaultColor),
                    ),
                    child: Text(cubit.isEnabled ? 'حفظ' : 'اضغط هنا للتعديل',
                        style: TextStyle(
                            fontSize: 20,
                            color:
                                cubit.isEnabled ? defaultColor : Colors.grey)),
                    onPressed: cubit.isEnabled
                        ? () {
                            cubit.isEnabled = false;
                            cubit.updateBuildingNameDb(
                                titel: titelcontroller.text,
                                description: descriptioncontroller.text,
                                price: double.parse(pricecontroller.text),
                                id: widget.model['id']);
                          }
                        : () {
                            cubit.change(true);
                          }),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Container(
                    child: GridView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4,
                        mainAxisSpacing: 20.0,
                        crossAxisSpacing: 20.0,
                      ),
                      itemCount: 12,
                      itemBuilder: (BuildContext context, int index) {
                        return InkWell(
                          onTap: () {
                            showDialog(
                                context: context,
                                builder: (context) => Directionality(
                                      textDirection: TextDirection.rtl,
                                      child: AlertDialog(
                                        title: Text(
                                            ' تأكيد الدفع شهر ${index + 1}'),
                                        // content: Text(
                                        //     'تأكيد عملية الدفع'),
                                        actions: <Widget>[
                                          TextButton(
                                            child: Text('تراجع',
                                                style: TextStyle(
                                                    color: Colors.red)),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            style: TextButton.styleFrom(
                                                backgroundColor:
                                                    Colors.grey[300]),
                                          ),
                                          TextButton(
                                            child: Text('تم الدفع',
                                                style: TextStyle(
                                                    color: Colors.green)),
                                            onPressed: () {
                                              int state;
                                              state = widget.model[
                                                          'month${index + 1}'] ==
                                                      1
                                                  ? 0
                                                  : 1;
                                              cubit
                                                  .updateBuildingmonthDb(
                                                      month: index + 1,
                                                      id: widget.model['id'],
                                                      state: state)
                                                  .then((value) {
                                                setState(() {
                                                  colors[index] = state == 1
                                                      ? Colors.orange[300]
                                                      : Colors.grey;
                                                });
                                              });
                                              Navigator.of(context).pop();
                                            },
                                            style: TextButton.styleFrom(
                                                backgroundColor:
                                                    Colors.grey[300]),
                                          ),
                                        ],
                                      ),
                                    ));
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
