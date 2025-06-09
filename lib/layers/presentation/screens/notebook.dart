import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:matule/core/colors/brand_colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class Notebookf extends StatefulWidget {
  Notebookf({super.key});

  @override
  State<Notebookf> createState() => _NotebookfState();
}

class _NotebookfState extends State<Notebookf> {
  final List<Map<String, dynamic>> _notes = [];
  String _sortBy = 'newest';

  @override
  void initState() {
    super.initState();
    _loadNotes();
    _loadSortPreference();
  }

  Future<void> _loadNotes() async {
    final prefs = await SharedPreferences.getInstance();
    final notesJson = prefs.getStringList('notes') ?? [];
    setState(() {
      _notes.addAll(
        notesJson.map((note) => Map<String, dynamic>.from(json.decode(note))),
      );
      _sortNotes();
    });
  }

  Future<void> _loadSortPreference() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _sortBy = prefs.getString('sortBy') ?? 'newest';
    });
  }

  Future<void> _saveNotes() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setStringList(
      'notes',
      _notes.map((note) => json.encode(note)).toList(),
    );
  }

  Future<void> _saveSortPreference() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('sortBy', _sortBy);
  }

  void _sortNotes() {
    setState(() {
      if (_sortBy == 'newest') {
        _notes.sort((a, b) => b['id'].compareTo(a['id']));
      } else if (_sortBy == 'oldest') {
        _notes.sort((a, b) => a['id'].compareTo(b['id']));
      } else if (_sortBy == 'title') {
        _notes.sort((a, b) => a['title'].compareTo(b['title']));
      }
    });
  }

  void _addNewNote() {
    final newNote = {
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
      'title': '',
      'description': '',
    };

    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => NoteEditScreen(
              note: newNote,
              onSave: (updatedNote) {
                setState(() {
                  _notes.insert(0, updatedNote);
                  _sortNotes();
                  _saveNotes();
                });
              },
            ),
      ),
    );
  }

  void _editNote(int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => NoteEditScreen(
              note: Map<String, dynamic>.from(_notes[index]),
              onSave: (updatedNote) {
                setState(() {
                  _notes[index] = updatedNote;
                  _sortNotes();
                  _saveNotes();
                });
              },
            ),
      ),
    );
  }

  void _deleteNote(int index) {
    setState(() {
      _notes.removeAt(index);
      _saveNotes();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BrandColors.black,
      appBar: AppBar(
        backgroundColor: BrandColors.black,
        title: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            context.tr('notebook'),
            style: GoogleFonts.roboto(
              fontSize: 25,
              color: BrandColors.block,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        centerTitle: false,
        actions: [
          Row(
            children: [
              DropdownButton<String>(
                value: _sortBy,
                dropdownColor: BrandColors.darkbackground,
                alignment: Alignment.center,
                underline: Container(),
                items: [
                  DropdownMenuItem(
                    value: 'newest',
                    child: Center(
                      child: Text(
                        context.tr('newest'),
                        style: GoogleFonts.roboto(
                          fontSize: 18,
                          color: BrandColors.block,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  DropdownMenuItem(
                    value: 'oldest',
                    child: Center(
                      child: Text(
                        context.tr('oldest'),
                        style: GoogleFonts.roboto(
                          fontSize: 18,
                          color: BrandColors.block,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  DropdownMenuItem(
                    value: 'title',
                    child: Center(
                      child: Text(
                        context.tr('alphabet'),
                        style: GoogleFonts.roboto(
                          fontSize: 18,
                          color: BrandColors.block,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    _sortBy = value!;
                    _sortNotes();
                    _saveSortPreference();
                  });
                },
              ),
              SizedBox(width: 5),
              IconButton(
                onPressed: () => context.go('/settings'),
                icon: Icon(Icons.settings, color: BrandColors.purple),
              ),
              SizedBox(width: 6),
            ],
          ),
        ],
      ),
      body:
          _notes.isEmpty
              ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.note_add_outlined,
                      size: 64,
                      color: BrandColors.subTextDark,
                    ),
                    SizedBox(height: 16),
                    Text(
                      context.tr('notes'),
                      style: TextStyle(
                        color: BrandColors.subTextDark,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              )
              : ListView.builder(
                padding: EdgeInsets.all(16),
                itemCount: _notes.length,
                itemBuilder: (context, index) {
                  final note = _notes[index];
                  return Card(
                    color: BrandColors.darkbackground,
                    margin: EdgeInsets.only(bottom: 12),
                    child: ListTile(
                      title: Text(
                        note['title'].isEmpty
                            ? context.tr('notitle')
                            : note['title'],
                        style: TextStyle(color: BrandColors.block),
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.delete, color: BrandColors.block),
                        onPressed: () => _deleteNote(index),
                      ),
                      onTap: () => _editNote(index),
                    ),
                  );
                },
              ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: BrandColors.purple,
        shape: CircleBorder(),
        child: Icon(Icons.add, color: BrandColors.block),
        onPressed: _addNewNote,
      ),
    );
  }
}

class NoteEditScreen extends StatefulWidget {
  final Map<String, dynamic> note;
  final Function(Map<String, dynamic>) onSave;

  const NoteEditScreen({required this.note, required this.onSave, super.key});

  @override
  State<NoteEditScreen> createState() => _NoteEditScreenState();
}

class _NoteEditScreenState extends State<NoteEditScreen> {
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.note['title']);
    _descriptionController = TextEditingController(
      text: widget.note['description'],
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _saveNote() {
    widget.onSave({
      ...widget.note,
      'title': _titleController.text,
      'description': _descriptionController.text,
    });
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BrandColors.black,
      appBar: AppBar(
        iconTheme: IconThemeData(color: BrandColors.block),
        backgroundColor: BrandColors.black,
        title: Text(
          context.tr('note'),
          style: GoogleFonts.roboto(
            fontSize: 25,
            color: BrandColors.block,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.check, color: BrandColors.block),
            onPressed: _saveNote,
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              style: TextStyle(color: BrandColors.block, fontSize: 18),
              decoration: InputDecoration(
                hintText: context.tr('title'),
                hintStyle: TextStyle(color: BrandColors.subTextDark),
                border: InputBorder.none,
              ),
            ),
            SizedBox(height: 12),
            Expanded(
              child: TextField(
                controller: _descriptionController,
                style: TextStyle(color: BrandColors.block, fontSize: 16),
                decoration: InputDecoration(
                  hintText: context.tr('description'),
                  hintStyle: TextStyle(color: BrandColors.subTextDark),
                  border: InputBorder.none,
                ),
                maxLines: null,
                expands: true,
                keyboardType: TextInputType.multiline,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
