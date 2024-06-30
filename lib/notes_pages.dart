import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class NotesPage extends StatefulWidget {
  @override
  _NotesPageState createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  final _noteController = TextEditingController();
  final _box = Hive.box('notes');
  int _editIndex = -1; // -1 means no edit mode

  void _addNote() {
    if (_noteController.text.isNotEmpty) {
      if (_editIndex == -1) {
        // Add new note
        _box.add(_noteController.text);
      } else {
        // Update existing note
        _box.putAt(_editIndex, _noteController.text);
        setState(() {
          _editIndex = -1; // Reset edit mode
        });
      }
      _noteController.clear();
    }
  }

  void _deleteNote(int index) {
    _box.deleteAt(index);
  }

  void _startEdit(int index, String initialText) {
    setState(() {
      _editIndex = index; // Start editing mode
      _noteController.text = initialText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60.0),
        child: AppBar(
          title: Text(
            'Notes',
            style: TextStyle(color: Colors.white, fontSize: 24.0),
          ),
          backgroundColor: Colors.purple.shade500,
          centerTitle: true,
        ),
      ),
      backgroundColor: Colors.white, // Pale purple background color
      body: Column(
        children: [
          Expanded(
            child: Container(
              margin: EdgeInsets.all(16.0),
              child: ValueListenableBuilder(
                valueListenable: _box.listenable(),
                builder: (context, Box box, _) {
                  if (box.isEmpty) {
                    return Center(
                      child: Text(
                        'No notes yet',
                        style: TextStyle(color: Colors.white, fontSize: 18.0),
                      ),
                    );
                  }
                  return ListView.builder(
                    itemCount: box.length,
                    itemBuilder: (context, index) {
                      final note = box.getAt(index) as String;
                      return GestureDetector(
                        onTap: () => _startEdit(index, note),
                        child: Container(
                          margin: EdgeInsets.only(bottom: 12.0),
                          padding: EdgeInsets.all(12.0),
                          decoration: BoxDecoration(
                            color: Colors.purple,
                            borderRadius: BorderRadius.circular(8.0),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: 4.0,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: ListTile(
                            title: Text(
                              note,
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: Icon(Icons.edit),
                                  onPressed: () => _startEdit(index, note),
                                  color: Colors.white,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                IconButton(
                                    icon: Icon(Icons.delete),
                                    onPressed: () => _deleteNote(index),
                                    color: Colors.white),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: Colors.purple.shade500,
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(1.0)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 12.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: TextField(
                      controller: _noteController,
                      decoration: InputDecoration(
                        hintText: 'Enter note',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 15),
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                  child: IconButton(
                    icon: Icon(Icons.add),
                    onPressed: _addNote,
                    color: Colors.purple,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
