import 'package:elevator/componant/componant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/appCubit.dart';
import '../cubit/appStates.dart';

class notPaidScreen extends StatelessWidget {
  const notPaidScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit,AppStates>(
      listener: (context, state) {},
      builder: (context, state)
      {
        var list = AppCubit.get(context).notPaidBuilding;
        return buildItem(list);
      }
    );
  }
}