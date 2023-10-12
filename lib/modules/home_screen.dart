import 'package:conditional_builder_rec/conditional_builder_rec.dart';
import 'package:elevator/modules/search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/appCubit.dart';
import '../cubit/appStates.dart';
import '../shared/shared.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  var titelController = TextEditingController();
  var descriptionController = TextEditingController();
  var priceController = TextEditingController();
  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {
        if (state is InsertDbState) Navigator.pop(context);
      },
      builder: (context, state) {
        AppCubit cubit = AppCubit.get(context);
        return Scaffold(
          key: scaffoldKey,
          appBar: AppBar(
            title: const FittedBox(child: Text("متابع المصاعد")),
            elevation: 0,
            backgroundColor: defaultColor[100],
            actions: [
              IconButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const Search(),
                        ));
                  },
                  icon: const Icon(Icons.search)),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: DropdownMenu<String>(
                  width: 130,
                  menuStyle: MenuStyle(shadowColor: MaterialStateColor.resolveWith((states) => Colors.orange
                  )),
                  label: const Text("الشهر"),
                  initialSelection: AppCubit.monthList.first,
                  onSelected: (String? value) {
                    cubit.dropdownButtonChange(value);
                  },
                  dropdownMenuEntries: AppCubit.monthList
                      .map<DropdownMenuEntry<String>>(
                          (String value) {
                        return DropdownMenuEntry<String>(
                            value: value, label: value,style: ButtonStyle(overlayColor: MaterialStateColor.resolveWith((states) => defaultColor.shade100),
                        ));
                      }).toList(),
                ),
              ),              // IconButton(
              //     onPressed: () {
              //       cubit.changeThemeMode();
              //     },
              //     icon: Icon(Icons.brightness_4)),
            ],
          ),
          body: ConditionalBuilderRec(
            builder: (context) => cubit.screens[cubit.currentIndex],
            condition: state is! Loding,
            fallback: (context) => const Center(child: CircularProgressIndicator()),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              if (cubit.sheetIsOpen) {
                if (formKey.currentState!.validate()) {
                  cubit.insertBuildingDb(titelController.text,
                      descriptionController.text,double.parse(priceController.text));
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
                                          return 'يجب ادخال اسم العمارة';
                                        }
                                        return null;
                                      },
                                      decoration: const InputDecoration(
                                          label: Text("اسم العمارة"),
                                          icon: Icon(Icons.title_outlined),
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
                                  //         return 'time must not be empty';
                                  //     },
                                  //     decoration: InputDecoration(
                                  //         label: Text("Time"),
                                  //         icon: Icon(
                                  //             Icons.watch_later_outlined),
                                  //         border: OutlineInputBorder(
                                  //             borderRadius: BorderRadius.all(
                                  //                 Radius.circular(10))))),
                                  // SizedBox(
                                  //   height: 10,
                                  // ),
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
                                  TextFormField(
                                      controller: priceController,
                                      keyboardType: TextInputType.number,
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return 'يجب ادخال سعر الصيانة';
                                        }
                                        return null;
                                      },
                                      decoration: const InputDecoration(
                                          label: Text("سعر الصيانة"),
                                          icon: Icon(Icons.attach_money),
                                          border: OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10))))),
                                  // DropdownMenu<String>(
                                  //   initialSelection: AppCubit.paidList.first,
                                  //   onSelected: (String? value) {
                                  //     cubit.dropdownButtonChange(value);
                                  //   },
                                  //   dropdownMenuEntries: AppCubit.paidList
                                  //       .map<DropdownMenuEntry<String>>(
                                  //           (String value) {
                                  //     return DropdownMenuEntry<String>(
                                  //         value: value, label: value);
                                  //   }).toList(),
                                  // ),
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
          bottomNavigationBar: BottomNavigationBar(
              items: const [
                BottomNavigationBarItem(
                    icon: Icon(Icons.business), label: "كل العمارات"),
                BottomNavigationBarItem(
                    icon: Icon(Icons.check_circle_outline), label: "تم تحصيل"),
                BottomNavigationBarItem(
                    icon: Icon(Icons.watch_later_outlined),
                    label: "لم يتم التحصيل بعد"),
              ],
              onTap: (value) {
                cubit.changeNavBarState(value);
              },
              currentIndex: cubit.currentIndex),
        );
      },
    );
  }
}
