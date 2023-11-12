import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import 'package:hive_project/pages/home_pages.dart';
import 'package:hive_project/screen/splass_screen.dart';
import 'package:path_provider/path_provider.dart';

import 'model/notes_model.dart';

void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  var directory= await getApplicationDocumentsDirectory();
  Hive.init(directory.path);

  Hive.registerAdapter(NoteModelAdapter());
  await Hive.openBox<NoteModel>('notes');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
      home: SplassScreen(),

    );
  }
}


