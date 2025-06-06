import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:matule/core/colors/brand_colors.dart';

class Notebookf extends StatefulWidget {
  Notebookf({super.key});

  @override
  State<Notebookf> createState() => _NotebookfState();
}

class _NotebookfState extends State<Notebookf> {
  final List<Map<String, dynamic>> _notes = [];

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
                });
              },
            ),
      ),
    );
  }

  void _deleteNote(int index) {
    setState(() {
      _notes.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BrandColors.black,
      appBar: AppBar(
        backgroundColor: BrandColors.black,
        title: Text(
          context.tr('notebook'),
          style: GoogleFonts.roboto(
            fontSize: 25,
            color: BrandColors.block,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        actions: [
          Row(
            children: [
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
                    const SizedBox(height: 16),
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
                padding: const EdgeInsets.all(16),
                itemCount: _notes.length,
                itemBuilder: (context, index) {
                  final note = _notes[index];
                  return Card(
                    color: BrandColors.darkbackground,
                    margin: const EdgeInsets.only(bottom: 12),
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
