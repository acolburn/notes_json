import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:convert';

import 'package:notes_json/models/note.dart';

class Data extends ChangeNotifier {
  // ----------showList------------
  bool showList = true;

  void changeDisplay() {
    showList = !showList;
    notifyListeners();
  }
  // ----------showList----------

  // ----------json--------------
  List<Note> notes = [];
  Note selectedNote = Note('', '');

  void add(title, content) {
    var note = Note(title, content);
    notes.add(note);
    notifyListeners();

    writeJson();
  }

  void newNote() {
    var note = Note('','');
    notes.add(note);
    selectedNote=note;
    notifyListeners();
  }

  void delete(index) {
    notes.removeAt(index);
    // After deleting, no note is then selected
    selectedNote = Note('', '');
    notifyListeners();
    writeJson();
  }

  void update({title = '', content = ''}) {
    // Don't do anything if user hasn't selected a note
    if (selectedNote.title != '' || selectedNote.content != '') {
      if (title != '') selectedNote.title = title;
      if (content != '') selectedNote.content = content;
      notifyListeners();
      writeJson();
    }
  }

  void selIndex(index) {
    selectedNote = notes[index];
    notifyListeners();
  }

  // Find the correct local path
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  // Create a reference to the file location
  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/notes.json');
  }

  // Read data from the file
  Future<void> readJson() async {
    try {
      // Read the file
      final file = await _localFile;
      final contents = await file.readAsString();
      List<dynamic> dataList = jsonDecode(contents);
      notes.clear();
      for (var item in dataList) {
        Note note = Note.fromJson(item);
        notes.add(note);
      }
    } catch (e) {
      // If encountering an error, make empty list
      debugPrint("error loading json: $e");
      notes = [];
    }
    notifyListeners();
  }

  void writeJson() async {
    var currentNotes = notes; // still need notes as is; next line changes list
    currentNotes.map((note) => note.toJson()).toList();
    final file = await _localFile;
    file.writeAsStringSync(json.encode(currentNotes));
  }
}
