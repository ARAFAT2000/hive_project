

import 'package:hive/hive.dart';

import '../model/notes_model.dart';

class Boxes{
  static Box<NoteModel> getData() => Hive.box<NoteModel>('notes');
}