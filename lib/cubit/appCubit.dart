import 'package:elevator/modules/all_work_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';

import '../component/component.dart';
import '../modules/not_paid_work_screen.dart';
import '../modules/paid_work_screen.dart';
import 'appStates.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AppInitState());

  static AppCubit get(context) => BlocProvider.of(context);

  static late Database database;
  List<Map> paidBuilding = [];
  List<Map> notPaidBuilding = [];
  List<Map> allBuilding = [];
  List search = [];
  List parts = [];
  bool sheetIsOpen = false;
  IconData fapIcon = Icons.edit;
  List<Widget> screens = [
    const AllWork(),
    const PaidScreen(),
    const NotPaidScreen(),
  ];
  int currentIndex = 0;
  static const List<String> monthList = [
    'شهر 1',
    "شهر 2",
    "شهر 3",
    "شهر 4",
    "شهر 5",
    "شهر 6",
    "شهر 7",
    "شهر 8",
    "شهر 9",
    "شهر 10",
    "شهر 11",
    "شهر 12"
  ];

  //static const List<String> paidList = <String>['لم يتم التحصيل', 'تم التحصيل'];

  String dropdownMonthValue = monthList.first;

  Future<void> createDb() async {
    openDatabase(
      'elevator.db',
      onCreate: (db, version) {
        db.execute(
            'CREATE TABLE parts (id INTEGER PRIMARY KEY, building_id INTEGER, titel TEXT,price INTEGER, date TEXT, description TEXT)')
            .then((value) {
          db.execute(
              'CREATE TABLE building (id INTEGER PRIMARY KEY, titel TEXT, price INTEGER, description TEXT, month1 INTEGER, month2 INTEGER, month3 INTEGER, month4 INTEGER, month5 INTEGER, month6 INTEGER, month7 INTEGER, month8 INTEGER, month9 INTEGER, month10 INTEGER, month11 INTEGER, month12 INTEGER)')
              .then((value) {
            emit(CreateDbState());
          }).catchError((error) {
          });
        }).catchError((error) {
        });

      },
      onOpen: (db) {
        getFromDb(db);
      },
      version: 2,
    ).then((value) {
      database = value;
    });
  }

  static void deleteDb(String s) {
    deleteDatabase(s);
  }

  Future<void> insertBuildingDb(String titel, String description,double price) async {
    await database.transaction((txn) {
      txn
          .rawInsert(
              'INSERT INTO building (titel,description,price, month1, month2, month3, month4, month5, month6, month7, month8, month9, month10, month11, month12) VALUES ("$titel", "$description", "$price", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0)')
          .then((value) {
        emit(InsertDbState());
      }).catchError((error) {
      });
      return Future(() => null);
    }).then((value) {
      getFromDb(database);
    });
  }
  Future<void> insertPartIntoDb(String titel, String description,int buildingId, double price,String date) async {
    await database.transaction((txn) {
      txn
          .rawInsert(
 //'CREATE TABLE parts (id INTEGER PRIMARY KEY, building_id INTEGER, titel TEXT,price INTEGER, date TEXT, description TEXT)')
      'INSERT INTO parts (titel,description,building_id,price,date) VALUES ("$titel", "$description","$buildingId","$price","$date")')
          .then((value) {
        emit(InsertDbState());
      }).catchError((error) {
      });
      return Future(() => null);
    }).then((value) {
      getPartsFromDb(buildingId);
    });
  }

  getAllFromDb(String titel) {
    emit(Loding());
    database
        .rawQuery("SELECT * FROM building WHERE titel LIKE '%$titel%'")
        .then((value) {
      search = value;
      emit(GetDbState());
    });
  }

  getPartsFromDb(int buildingId) {
    emit(Loding());
    database
        .rawQuery("SELECT * FROM parts WHERE building_id = $buildingId")
        .then((value) {
      parts = value;
      emit(GetPartsFromDbState());
    });
  }

  getFromDb(Database database) {
    emit(Loding());
    database
        .rawQuery(
            "SELECT * FROM building WHERE month${dropdownMonthValue.substring(dropdownMonthValue.length - 1)} = 0 ")
        .then((value) {
      database.rawQuery(
          "SELECT * FROM building WHERE month${dropdownMonthValue.substring(dropdownMonthValue.length - 1)} = 1")
          .then((value) {
        paidBuilding = value;
      }).catchError((error) {
      });
      notPaidBuilding = value;
      allBuilding = List.from(notPaidBuilding)..addAll(paidBuilding);
      emit(GetDbState());
    }).catchError((error) {
    });
  }

  void changeNavBarState(int index) {
    currentIndex = index;
    emit(NavBarChangeState());
  }

  void changeBottomSheetState(bool isShow, IconData icon) {
    sheetIsOpen = isShow;
    fapIcon = icon;
    emit(BottomSheetChangeState());
  }

  void updateDb({required int state, required int id}) {
    database.rawUpdate(
        'UPDATE building SET month${dropdownMonthValue.substring(dropdownMonthValue.length - 1)}  = ?  where id = ? ',
        ['$state', id]).then((value) {
      emit(UpdateDbState());
      getFromDb(database);
    }).catchError((error) {
    });
  }

  void updateBuildingNameDb(
      {required String titel, required String description,required double price, required int id}) {
    database.rawUpdate(
        'UPDATE building SET titel  = ?, description = ?, price = ?  where id = ? ',
        [titel, description, price, id]).then((value) {
      emit(UpdateDbState());
      toast('تم حفظ التعديل',Colors.green);
      getFromDb(database);
    }).catchError((error) {
      toast(error.toString(),Colors.red);
    });
  }

  Future<void> updateBuildingmonthDb(
      {required int month, required int state, required int id}) {
    return database.rawUpdate('UPDATE building SET month$month  = ?  where id = ? ',
        [state, id]).then((value) {
      emit(UpdateDbState());
      getFromDb(database);
    }).catchError((error) {
      //print(error);
    });
  }

  void deleteFormDb(int id) {
    database.rawDelete('DELETE FROM building WHERE id = ?', [id]).then((value) {
      database.rawDelete('DELETE FROM parts WHERE building_id = ?', [id]).then((value) {
      }).then((value) {
        emit(DeleteDbState());
        getFromDb(database);
      });

    });
  }

  void deletepartFormDb(int id, int buildingId ) {
      database.rawDelete('DELETE FROM parts WHERE id = ?', [id]).then((value) {
        emit(DeleteDbState());
        getPartsFromDb(buildingId);
      });

  }

  static bool isDark = false;

  void changeThemeMode() {
    isDark = !isDark;
    emit(ChangeMode());
  }

  void dropdownButtonChange(value) {
    dropdownMonthValue = value!;
    getFromDb(database);
    emit(DropdownButtonState());
  }
  bool isEnabled = false;

 void change (bool s){
   isEnabled = s;
    emit(ChangeMode());
 }
// void getSearch (value) {
//   emit(Loding());
//   DioHelper.getData('api/1/news',
//       {
//         'q' : '$value',
//         'apiKey': 'pub_28793fc9a3e454f2a8bd56e834c38948d309d'
//       }).then((value) {
//     search = value.data['results'];
//     emit(GetSearch());
//   }).catchError((error) {
//     print(error);
//     emit(GetsearchError());
//   });
// }
}
