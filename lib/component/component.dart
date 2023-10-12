import 'package:conditional_builder_rec/conditional_builder_rec.dart';
import 'package:elevator/cubit/appCubit.dart';
import 'package:elevator/cubit/appStates.dart';
import 'package:elevator/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../modules/building_screen.dart';

Widget buildItem(List list,state) {
  return ConditionalBuilderRec(
    condition: state is! Loding,
    builder: (context) => ConditionalBuilderRec(
      condition: list.isNotEmpty,
      fallback: (context) => Container(
        width: double.infinity,
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            Icon(Icons.menu,color: Colors.grey,),
            Text("القائمة فارغة",style: TextStyle(fontSize: 20,color: Colors.grey),),
          ],
        ),
      ),
      builder: (context) => ListView.separated(
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
                      radius: 15,
                      child: Padding(
                        padding: const EdgeInsets.all(1.5),
                        child: FittedBox(child: Text("${model['id']}")),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("${model['titel']}",
                                style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    overflow: TextOverflow.ellipsis)),
                            Text("${model['description']}",
                                style: const TextStyle(
                                    color: Colors.grey,
                                    overflow: TextOverflow.ellipsis),
                                maxLines: 2),
                          ]),
                    ),
                    const SizedBox(width: 10),
                    IconButton(
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (context) => Directionality(
                                textDirection: TextDirection.rtl,
                                child: AlertDialog(
                                  title: const Text('تأكيد الدفع'),
                                  // content: Text(
                                  //     'تأكيد عملية الدفع'),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      style: TextButton.styleFrom(
                                          backgroundColor: Colors.grey[300]),
                                      child: const Text('تراجع',
                                          style: TextStyle(color: Colors.red)),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        model['month${AppCubit.get(context).dropdownMonthValue.substring(AppCubit.get(context).dropdownMonthValue.length - 1)}'] ==
                                            1
                                            ? AppCubit.get(context).updateDb(
                                            state: 0, id: model['id'])
                                            : AppCubit.get(context).updateDb(
                                            state: 1, id: model['id']);
                                        Navigator.of(context).pop();
                                      },
                                      style: TextButton.styleFrom(
                                          backgroundColor: Colors.grey[300]),
                                      child: const Text('تم الدفع',
                                          style:
                                          TextStyle(color: Colors.green)),
                                    ),
                                  ],
                                ),
                              ));
                        },
                        icon:
                        model['month${AppCubit.get(context).dropdownMonthValue.substring(AppCubit.get(context).dropdownMonthValue.length - 1)}'] ==
                            1
                            ? const Icon(
                          Icons.check_box,
                          color: Colors.green,
                        )
                            : const Icon(
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
          itemCount: list.length)
    ),
    fallback: (context) => const Center(child: CircularProgressIndicator()),
  );
}

Widget buildPartItem(List list, int buildingId) {
  return ListView.separated(
    padding: const EdgeInsets.only(bottom:20),
      itemBuilder: (context, index) {
        var model = list[index];
        return Dismissible(
          background: Container(
            color: Colors.red,
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 30),
              child: Row(
                children: [
                  Icon(
                    Icons.delete,
                    color: Colors.white,
                    size: 30,
                  ),
                  Spacer(),
                  Icon(
                    Icons.delete,
                    color: Colors.white,
                    size: 30,
                  ),
                ],
              ),
            ),
          ),
          key: UniqueKey(),
          confirmDismiss: (direction) async {
            return await showDialog(
                context: context,
                builder: (context) => Directionality(
                      textDirection: TextDirection.rtl,
                      child: AlertDialog(
                        title: const Text('تأكيد الحذف'),
                        content:
                            const Text('هل انت متأكد من انك تريد ازالة هذة العنصر'),
                        actions: <Widget>[
                          TextButton(
                            child: const Text('تراجع'),
                            onPressed: () {
                              Navigator.of(context).pop(false);
                            },
                          ),
                          TextButton(
                            child: const Text('حذف',
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
            AppCubit.get(context).deletepartFormDb(model['id'], buildingId);// Close the dialog
            // Close the dialog
          },
          child: ExpansionTile(
            title: Row(
              children: [
                CircleAvatar(
                  radius: 15,
                  child: Padding(
                    padding: const EdgeInsets.all(1.5),
                    child: FittedBox(child: Text("${model['id']}")),
                  ),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text("${model['titel']}",
                      style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          overflow: TextOverflow.ellipsis)),
                ),
              ],
            ),
            children: [
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            RichText(text: TextSpan(text: "${model['titel']}",style:const TextStyle(fontSize: 20,color: Colors.black,
                              fontWeight: FontWeight.bold,)),
                            ),
                            RichText(text: TextSpan(text:"${model['description']}",style: const TextStyle(
                              color: Colors.grey,
                            ), ),


                            ),
                            Container(
                              decoration: BoxDecoration(borderRadius: const BorderRadius.only(topLeft: Radius.circular(5),topRight: Radius.circular(5)),color: defaultColor[100],),

                              child: Row(
                                children: [
                                  Expanded(
                                    child: FittedBox(
                                      fit: BoxFit.scaleDown,
                                      child: Text('السعر : ${model['price']}',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,

                                          ),
                                      textAlign: TextAlign.center
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Text('التاريخ : ${model['date']}',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                    textAlign: TextAlign.center),
                                  ),
                                ],
                              ),
                            )
                          ]),
                    ),
                  ),
                  // Row(
                  //   children: [
                  //     Row(
                  //       children: [
                  //         Text('السعر'),
                  //         Text('${model['price']}'),
                  //       ],
                  //     ),
                  //     SizedBox(width: 20),
                  //     Row(
                  //       children: [
                  //         Text('التاريخ'),
                  //         Text('${model['time']}'),
                  //         Text('${model['date']}'),
                  //       ],
                  //     ),
                  //   ],
                  // )
                ],
              ),
            ],
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

// Widget createDocElement(element) {
//   return Padding(
//     padding: const EdgeInsets.symmetric(vertical: 5.0),
//     child: ExpansionTile(
//       title: Text(
//         element.title,
//         style: TextStyle(fontWeight: FontWeight.bold),
//       ),
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(8),
//       ),
//       collapsedShape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(8),
//       ),
//       childrenPadding: const EdgeInsets.symmetric(horizontal: 10),
//       children: [
//         Divider(
//           color: ,
//           thickness: 1,
//           indent: 20,
//           endIndent: 20,
//         ),
//         Container(
//           alignment: AlignmentDirectional.centerStart,
//           child: Text(
//             'Description:',
//             //textAlign: TextAlign.start,
//             style: TextStyle(
//               // fontSize: SizeConfig.heightBlock! * 2.5,
//               // fontWeight: FontWeight.bold,
//               // color: ThemeColors.blueColor,
//             ),
//           ),
//         ),
//         const SizedBox(
//           height: 5,
//         ),
//         Container(
//           alignment: AlignmentDirectional.centerStart,
//           child: Text(
//             element.description,
//             style: TextStyle(
//               // fontSize: SizeConfig.heightBlock! * 2,
//               // color: theme == 'light'
//               //     ? ThemeColors.lightBlackText
//               //     : ThemeColors.darkWhiteText,
//             ),
//           ),
//         ),
//         const SizedBox(
//           height: 5,
//         ),
//         if (element.title != 'LSH Operator' &&
//             element.title != 'RSH Operator')
//           const SizedBox(
//             height: 5,
//           ),
//         if (element.title != 'LSH Operator' &&
//             element.title != 'RSH Operator')
//           Container(
//             width: 290,
//             alignment: Alignment.center,
//             child: element.showTT(theme!),
//           ),
//         Container(
//           alignment: AlignmentDirectional.centerStart,
//           child: Text('Examples:',
//               style: TextStyle(
//                 // fontSize: SizeConfig.heightBlock! * 2.5,
//                 // fontWeight: FontWeight.bold,
//                 // color: ThemeColors.blueColor,
//               )),
//         ),
//         const SizedBox(
//           height: 5,
//         ),
//         ...element.example.map(
//               (e) => Container(
//             alignment: AlignmentDirectional.centerStart,
//             child: Text.rich(
//               TextSpan(
//                   text: e.num1,
//                   children: [
//                     TextSpan(
//                       text: ' ${e.operation} ',
//                       style: const TextStyle(
//                         color: ThemeColors.redColor,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     TextSpan(text: e.num2),
//                     const TextSpan(text: " = "),
//                     TextSpan(
//                       text: e.result,
//                       style: const TextStyle(
//                         color: ThemeColors.redColor,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     )
//                   ],
//                   style: TextStyle(
//                     fontSize: SizeConfig.heightBlock! * 2,
//                     color: theme == 'light'
//                         ? ThemeColors.lightBlackText
//                         : ThemeColors.darkWhiteText,
//                   )),
//             ),
//           ),
//         ),
//         const SizedBox(
//           height: 5,
//         ),
//       ],
//     ),
//   );
// }
