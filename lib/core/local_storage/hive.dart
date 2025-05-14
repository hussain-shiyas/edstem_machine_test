import 'dart:developer';

import 'package:edstem_machine_test/ui/home_screen/models/get_movie_res_model.dart';
import 'package:hive_flutter/hive_flutter.dart';

enum MainBoxKeys { allMovies  }

mixin class StorageServiceMixin {
  static late Box? mainBox;
  static const _boxName = 'localData';

  static Future<void> initHive() async {
      await Hive.initFlutter();
      await registerAdaptor();
      mainBox = await Hive.openBox(_boxName);


  }

  Future<void> addData<T>(MainBoxKeys key, T value) async {
    await mainBox?.put(key.name, value);
  }

  Future<void> removeData(MainBoxKeys key) async {
    await mainBox?.delete(key.name);
  }

  T getData<T>(MainBoxKeys key) => mainBox?.get(key.name) as T;

  Future<void> closeBox() async {
    try {
      if (mainBox != null) {
        await mainBox?.close();
        await mainBox?.deleteFromDisk();
      }
    } catch (e) {
      log(e.toString());
    }
  }
  static registerAdaptor() {
    Hive.registerAdapter(GetMovieResModelAdapter());
    Hive.registerAdapter(MovieListAdapter());
  }
}
