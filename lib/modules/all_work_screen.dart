import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../component/component.dart';
import '../cubit/appCubit.dart';
import '../cubit/appStates.dart';

class AllWork extends StatelessWidget {
  const AllWork({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit,AppStates>(
      listener: (context, state) {},
      builder: (context, state)
      {

        return buildItem(AppCubit.get(context).allBuilding,state);

      }
    );
  }
}
