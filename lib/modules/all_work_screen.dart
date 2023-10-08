import 'package:elevator/componant/componant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/appCubit.dart';
import '../cubit/appStates.dart';

class allWork extends StatelessWidget {
  const allWork({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit,AppStates>(
      listener: (context, state) {},
      builder: (context, state)
      {
        var list = new List.from(AppCubit.get(context).notPaidBuilding)..addAll(AppCubit.get(context).paidBuilding);
        return buildItem(list);
      }
    );
  }
}
