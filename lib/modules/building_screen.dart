import 'package:elevator/cubit/appCubit.dart';
import 'package:elevator/modules/parts_screen.dart';
import 'package:elevator/shared/shared.dart';
import 'package:flutter/material.dart';

class BuildingScreen extends StatefulWidget {
  final model;

  BuildingScreen(this.model, {super.key});

  @override
  State<BuildingScreen> createState() => _BuildingScreenState();
}

class _BuildingScreenState extends State<BuildingScreen> {
  var titelController = TextEditingController();
  var descriptionController = TextEditingController();
  var priceController = TextEditingController();
  late List<dynamic> colors = List.generate(
      12,
      (index) => widget.model['month${(index + 1)}'] == 1
          ? Colors.orange[300]
          : Colors.grey);
  List<Widget> iconButtons = List.generate(12, (index) {
    return IconButton(
      icon: const Icon(Icons.star), // Replace with your desired icon
      onPressed: () {
        // Add your onPressed functionality here
      },
    );
  });

  @override
  void initState() {
    super.initState();
    titelController = TextEditingController(text: widget.model['titel']);
    descriptionController =
        TextEditingController(text: widget.model['description']);
    priceController =
        TextEditingController(text: widget.model['price'].toString());
  }

  @override
  Widget build(BuildContext context) {
    AppCubit cubit = AppCubit.get(context);
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("متابع المصاعد"),
          elevation: 0,
          backgroundColor: defaultColor[100],
          actions: [
            IconButton(
                icon: const Icon(
                  Icons.delete_outline,
                  color: Colors.red,
                ),
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (context) => Directionality(
                            textDirection: TextDirection.rtl,
                            child: AlertDialog(
                              title: const Text('تأكيد الحذف'),
                              content: const Text(
                                  'هل انت متأكد من انك تريد ازالة هذة العمارة'),
                              actions: <Widget>[
                                TextButton(
                                  child: const Text('تراجع'),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                                TextButton(
                                  child: const Text('حذف',
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
                    text: 'عمارة : ${titelController.text}',
                    style: const TextStyle(
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
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold,color: Colors.black),
                        textAlign: TextAlign.center,
                        controller: priceController,
                        keyboardType: TextInputType.number,
                        enabled: cubit.isEnabled,
                        decoration: InputDecoration(
                            enabledBorder: const OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.orangeAccent)),
                            disabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.black)),
                            label: const Text(
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
                            const Text('سعر الصيانة',style: TextStyle(
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
                                    child: Text(priceController.text,style: const TextStyle(
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
                    const SizedBox(width: 30),
                    MaterialButton(
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
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.add),
                          Text('قطع الغيار'),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                TextFormField(
                  style: const TextStyle(color: Colors.black),
                  decoration: const InputDecoration(
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
                  controller: titelController,
                  enabled: cubit.isEnabled,
                ),
                const SizedBox(
                  height: 15,
                ),
                TextFormField(
                  style: const TextStyle(color: Colors.black),
                  controller: descriptionController,
                  enabled: cubit.isEnabled,
                  decoration: const InputDecoration(
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
                const SizedBox(
                  height: 15,
                ),
                OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: defaultColor),
                    ),
                    onPressed: cubit.isEnabled
                        ? () {
                            cubit.isEnabled = false;
                            cubit.updateBuildingNameDb(
                                titel: titelController.text,
                                description: descriptionController.text,
                                price: double.parse(priceController.text),
                                id: widget.model['id']);
                          }
                        : () {
                            cubit.change(true);
                          },
                    child: Text(cubit.isEnabled ? 'حفظ' : 'اضغط هنا للتعديل',
                        style: TextStyle(
                            fontSize: 20,
                            color:
                                cubit.isEnabled ? defaultColor : Colors.grey))),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Container(
                    child: GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
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
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            style: TextButton.styleFrom(
                                                backgroundColor:
                                                    Colors.grey[300]),
                                            child: const Text('تراجع',
                                                style: TextStyle(
                                                    color: Colors.red)),
                                          ),
                                          TextButton(
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
                                            child: const Text('تم الدفع',
                                                style: TextStyle(
                                                    color: Colors.green)),
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
                                style: const TextStyle(
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
