import 'package:conditional_builder_rec/conditional_builder_rec.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../component/component.dart';
import '../cubit/appCubit.dart';
import '../cubit/appStates.dart';
import '../shared/shared.dart';

class PartsScreen extends StatefulWidget {
  PartsScreen(this.model, {super.key});
  var model;
  @override
  State<PartsScreen> createState() => _PartsScreenState();
}

class _PartsScreenState extends State<PartsScreen> {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  var titelController = TextEditingController();
  var timeController = TextEditingController();
  var priceController = TextEditingController();
  var descriptionController = TextEditingController();
  var dateController = TextEditingController();
  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {
        // if (state is insertDbState) Navigator.pop(context);
      },
      builder: (context, state) {
        AppCubit cubit = AppCubit.get(context);
        return Scaffold(
          key: scaffoldKey,
          appBar: AppBar(
            title: const Text("قطع الغيار"),
            elevation: 0,
            backgroundColor: defaultColor[100],
          ),
          body: ConditionalBuilderRec(
            condition: state is! Loding,
            fallback: (context) => const Center(child: CircularProgressIndicator()),
            builder: (context) {
              return ConditionalBuilderRec(
                condition: cubit.parts.isNotEmpty,
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
                builder: (context) {
                  var list = cubit.parts;
                  return buildPartItem(list,widget.model['id']);
                },
              );
            },
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              if (cubit.sheetIsOpen) {
                if (formKey.currentState!.validate()) {
                  cubit.insertPartIntoDb(titelController.text, descriptionController.text,widget.model['id'],double.parse(priceController.text),dateController.text);
                  cubit.changeBottomSheetState(false, Icons.edit);
                }
              } else {
                scaffoldKey.currentState
                    ?.showBottomSheet((context) => Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Container(
                    width: double.infinity,
                    child: Form(
                      key: formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextFormField(
                              controller: titelController,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'يجب ادخال اسم قطعة الغيار';
                                }
                                return null;
                              },
                              decoration: const InputDecoration(
                                  label: Text("اسم قطعة الغيار"),
                                  icon: Icon(Icons.title_outlined),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10))))),
                          const SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                            keyboardType: TextInputType.number,
                              controller: priceController,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'يجب ادخال السعر';
                                }
                                return null;
                              },
                              decoration: const InputDecoration(
                                  label: Text("السعر"),
                                  icon: Icon(Icons.attach_money),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10))))),
                          const SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                              controller: descriptionController,

                              decoration: const InputDecoration(
                                  label: Text("الوصف"),
                                  icon: Icon(Icons.text_snippet_outlined),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10))))),
                          const SizedBox(
                            height: 10,
                          ),
                           // TextFormField(
                           //     controller: timeController,
                           //     onTap: () {
                           //       showTimePicker(
                           //               context: context,
                           //               initialTime: TimeOfDay.now())
                           //           .then((value) {
                           //         timeController.text =
                           //             value!.format(context);
                           //       });
                           //     },
                           //     validator: (value) {
                           //       if (value!.isEmpty)
                           //         timeController.text = '${TimeOfDay.now().format(context)}';
                           //     },
                           //     decoration: InputDecoration(
                           //         label: Text("الوقت"),
                           //         icon: Icon(
                           //             Icons.watch_later_outlined),
                           //         border: OutlineInputBorder(
                           //             borderRadius: BorderRadius.all(
                           //                 Radius.circular(10))))),
                           const SizedBox(
                             height: 10,
                           ),
                          TextFormField(
                              controller: dateController,
                              onTap: () {
                                showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime(2023), lastDate: DateTime.now().isAfter(DateTime(2050)) ? DateTime.now() :DateTime(2050) ).then((value) {
                                  dateController.text = DateFormat('dd-MM-yyyy').format(value!);
                                });
                              },
                              validator: (value) {
                                if (value!.isEmpty) {
                                  dateController.text = '${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}';
                                }
                                return null;

                                },
                              decoration: const InputDecoration(
                                  label: Text("التاريخ"),
                                  icon: Icon(
                                      Icons.calendar_month),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10))))),
                        ],
                      ),
                    ),
                  ),
                ))
                    .closed
                    .then((value) {
                  cubit.changeBottomSheetState(false, Icons.edit);
                });
                cubit.changeBottomSheetState(true, Icons.add);
              }
            },
            tooltip: 'Increment',
            child: Icon(cubit.fapIcon),
          ),
        );
      },
    );
  }
}
