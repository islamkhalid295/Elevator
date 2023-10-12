import 'package:conditional_builder_rec/conditional_builder_rec.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../component/component.dart';
import '../cubit/appCubit.dart';
import '../cubit/appStates.dart';

class NotPaidScreen extends StatelessWidget {
  const NotPaidScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit,AppStates>(
      listener: (context, state) {},
      builder: (context, state)
      {
        var list = AppCubit.get(context).notPaidBuilding;
        return ConditionalBuilderRec(
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
          builder: (context) => buildItem(list,state),
        );
      }
    );
  }
}
