import '../models/not.dart';
import '../helpers/database_helper.dart';

class NoteController {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  Future<void> addNote(Not note) async {
    await _dbHelper.insertNote(note);
  }

  Future<void> updateNot(Not note) async {
    await _dbHelper.updateNot(note);
  }

  Future<List<Not>> getNotes() async {
    return await _dbHelper.notes();
  }

  Future<void> removeNote(int id) async {
    await _dbHelper.deleteNote(id);
  }
}
