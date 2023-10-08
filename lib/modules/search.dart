import 'package:conditional_builder_rec/conditional_builder_rec.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../componant/componant.dart';
import '../cubit/appCubit.dart';
import '../cubit/appStates.dart';
import '../shared/shared.dart';

// class Search extends StatelessWidget {
//   const Search({super.key});
//
//   //TextEditingController searchController = TextEditingController();
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(),
//       body: Padding(
//         padding: const EdgeInsets.all(10),
//         child: Column(
//           children: [
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: TextFormField(
//                 decoration: InputDecoration(
//                   label: Text("Search"), border: OutlineInputBorder(),
//                   prefixIcon: Icon(Icons.search),
//                 ),
//                 validator: (value) {
//                   if (value!.isEmpty) {
//                     return "enter any text";
//                   }
//                   return null;
//                 },
//                //controller: searchController,
//                 onFieldSubmitted: (value) {
//                   AppCubit.get(context).getAllFromDb(AppCubit.database,value);
//                   print(value);
//                 },
//               ),
//             ),
//             BlocConsumer<AppCubit, AppStates>(
//                 listener: (context, state) {},
//                 builder: (context, state)
//                 {
//                   var list = AppCubit.get(context).search;
//                   return ListView.separated(
//                       itemBuilder: (context, index) {
//                         var model = list[index];
//                         return Dismissible(
//                           key: UniqueKey(),
//                           onDismissed: (direction) {
//                             AppCubit.get(context).deleteFormDb(model['id']);
//                           },
//                           child: Padding(
//                             padding: const EdgeInsets.all(20.0),
//                             child: Row(children: [
//                               CircleAvatar(child: Text("${model['id']}"),radius: 20.0,),
//                               SizedBox(width: 10),
//                               Expanded(
//                                 child: Column(
//                                     mainAxisSize: MainAxisSize.min,
//                                     crossAxisAlignment: CrossAxisAlignment.start,
//                                     children: [
//                                       Text("${model['titel']}",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,overflow: TextOverflow.ellipsis)),
//                                       Text("${model['description']}",style: TextStyle(color: Colors.grey,overflow: TextOverflow.ellipsis),maxLines: 2),
//                                     ]),
//                               ),
//                               SizedBox(width: 10),
//                               IconButton(onPressed: (){
//                                 AppCubit.get(context).updateDb(state: 'تم التحصيل', id: model['id']);
//                               },
//                                   icon: model['status'] == 'تم التحصيل' ? Icon(Icons.block, color: Colors.red,) :Icon(Icons.check_circle_outline, color: Colors.green,)
//                               ),
//                               IconButton(onPressed: (){
//                                 //appCubit.get(context).updateDb(state: 'archive', id: model['id']);
//                               },
//                                   icon: Icon(Icons.archive_outlined,color: Colors.grey,)
//                               ),
//                             ],
//                             ),
//                           ),
//                         );
//                       },
//                       separatorBuilder: (context, index) => Container(width: double.infinity, height: 1.0, color: Colors.grey,),
//                       itemCount:list.length
//                   );
//                 },
//                 ),
//           ],
//         ),
//       ),
//     );
//   }
// }
class Search extends StatelessWidget {
  const Search({super.key});

  //TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          //title: Text("البحث"),
          elevation: 0,
          backgroundColor: defaultColor[100],
        ),
        body: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: InputDecoration(
                    hintText: "ابحث عن طريق ادخال اسم العمارة",
                    label: Text("Search"),
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.search),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "enter any text";
                    }
                    return null;
                  },
                  //controller: searchController,
                  onFieldSubmitted: (value) {
                    AppCubit.get(context).getAllFromDb(value);
                    print(value);
                  },
                ),
              ),
              BlocConsumer<AppCubit, AppStates>(
                listener: (context, state) {},
                builder: (context, state) {
                  var list = AppCubit.get(context).search;
                  return Expanded(
                    child: ConditionalBuilderRec(
                      condition: state is! Loding,
                      builder: (context) => buildItem(list),
                      fallback: (context) =>
                          Center(child: CircularProgressIndicator()),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
