import 'package:flutter/material.dart';
import 'controllers/note_controller.dart';
import 'models/not.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: NoteListScreen(),
    );
  }
}

class NoteListScreen extends StatefulWidget {
  @override
  _NoteListScreenState createState() => _NoteListScreenState();
}

class _NoteListScreenState extends State<NoteListScreen> {
  final NoteController _noteController = NoteController();
  List<Not> _notes = [];

  @override
  void initState() {
    super.initState();
    _loadNotes();
  }

  void _loadNotes() async {
    _notes = await _noteController.getNotes();
    setState(() {});
  }

  void _addOrUpdateNote([Not? note]) async {
    final updatedNote = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NoteEditScreen(note: note),
      ),
    );
    if (updatedNote != null) {
      if (note == null) {
        await _noteController.addNote(updatedNote);
      } else {
        await _noteController.updateNot(updatedNote);
      }
      _loadNotes();
    }
  }

  void _deleteNote(int id) async {
    await _noteController.removeNote(id);
    _loadNotes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notlar'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () =>   _addOrUpdateNote(),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: _notes.length,
        itemBuilder: (context, index) {
          final note = _notes[index];
          return ListTile(
            title: Text(note.title),
            subtitle: Text('${note.date.toLocal()}'),
            onTap: () => _addOrUpdateNote(note),
            onLongPress: () => _deleteNote(note.id!),
          );
        },
      ),
    );
  }
}

class NoteEditScreen extends StatefulWidget {
  final Not? note;  // Güncellenebilir not

  NoteEditScreen({this.note});

  @override
  _NoteEditScreenState createState() => _NoteEditScreenState();
}

class _NoteEditScreenState extends State<NoteEditScreen> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.note != null) {
      _titleController.text = widget.note!.title;
      _contentController.text = widget.note!.content;
    }
  }

  void _saveNote() {
    final title = _titleController.text;
    final content = _contentController.text;
    if (title.isNotEmpty && content.isNotEmpty) {
      final note = Not(
        id: widget.note?.id,
        title: title,
        content: content,
        date: widget.note != null ? widget.note!.date : DateTime.now(),
      );
      Navigator.pop(context, note);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.note == null ? 'Yeni Not' : 'Not Düzenleme'),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _saveNote,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(labelText: 'Başlık'),
            ),
            TextField(
              controller: _contentController,
              decoration: InputDecoration(labelText: 'İçerik'),
              maxLines: null,
              keyboardType: TextInputType.multiline,
            ),
          ],
        ),
      ),
    );
  }
}
