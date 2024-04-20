import 'package:flutter/material.dart';
// import 'package:markdown_widget/config/all.dart';
import 'package:notes_json/models/note.dart';
import 'package:notes_json/providers/data_provider.dart';
import 'package:notes_json/views/vertical_split_view.dart';
import 'package:provider/provider.dart';
import 'package:markdown_widget/markdown_widget.dart';
import 'package:flutter_highlight/themes/github.dart';

class NoteDetail extends StatefulWidget {
  NoteDetail({super.key});

  @override
  State<NoteDetail> createState() => _NoteDetailState();
}

class _NoteDetailState extends State<NoteDetail> {
  // These TextEditingControllers are used to get and set the note's
  final TextEditingController noteTitleController = TextEditingController();
  final TextEditingController noteContentController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    noteContentController.dispose();
    noteTitleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tocController = TocController();
    Note? selectedNote = context.read<Data>().selectedNote;
    // noteTitleController.text = selectedNote.title;
    // noteContentController.text = selectedNote.content;

    return DefaultTabController(
      // Two tabs, one for the Edit screen, one for the markdown Preview screen
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          flexibleSpace: TabBar(
            isScrollable: true,
            tabs: [
              Tab(text: 'Edit'),
              Tab(text: 'Preview'),
            ],
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.save_sharp),
              onPressed: () {
                var data = context.read<Data>();
                data.update(
                    title: data.selectedNote.title,
                    content: data.selectedNote.content);
              },
            ),
          ],
        ),
        body: TabBarView(
          children: [
            // Edit Screen
            Container(
              margin: const EdgeInsets.all(18),
              child: ListView(
                children: [
                  // Note's Title TextField---------------------------------
                  NoteTextField(
                    displayText: selectedNote.title,
                    controller: noteTitleController,
                    onChanged: (value) {
                      // selectedNote.title = value;
                      context.read<Data>().update(title: value);
                    },
                    minLines: 1,
                    style: Theme.of(context).textTheme.titleLarge!,
                  ),
                  // Note's Content TextField---------------------------------
                  NoteTextField(
                    displayText: selectedNote.content,
                    controller: noteContentController,
                    onChanged: (value) {
                      selectedNote.content = value;
                    },
                    minLines: 10,
                  ),

                  // Save Button------------------------------------------
                  Padding(
                    padding: EdgeInsets.only(
                      top: 15,
                      bottom: 15,
                    ),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[200],
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                      ),
                      onPressed: () {
                        var title = noteTitleController.text;
                        var content = noteContentController.text;
                        // Update (and save) note
                        selectedNote.title = title;
                        selectedNote.content = content;
                        context
                            .read<Data>()
                            .update(title: title, content: content);
                      },
                      child: Text('Save'),
                    ),
                  ),
                ],
              ),
            ),
            // End Edit Screen--------------------------------------------

            // Markdown Preview Screen-------------------------------------
            Container(
              padding: EdgeInsets.all(18),
              child: Column(
                children: [
                  // Markdown Title TextField----------------------------
                  Padding(
                    padding: EdgeInsets.only(
                      top: 15,
                      bottom: 15,
                    ),
                    child: TextField(
                      controller: noteTitleController,
                      style: Theme.of(context).textTheme.titleLarge!,
                      maxLines: 1,
                    ),
                  ),

                  // Markdown Text----------------------------------------
                  // VerticalSplitView()
                  Expanded(
                    child: VerticalSplitView(
                      left: MarkdownWidget(
                        data: noteContentController.text,
                        config: MarkdownConfig(
                          configs: [
                            PreConfig(theme: githubTheme),
                          ],
                        ),
                        tocController: tocController,
                      ),
                      right: TocWidget(controller: tocController),
                      ratio: 0.7,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class NoteTextField extends StatelessWidget {
  const NoteTextField(
      {super.key,
      required this.displayText,
      required this.controller,
      required this.onChanged,
      required this.minLines,
      this.style});

  final String displayText;
  final TextEditingController controller;
  final Function(String) onChanged;
  final int minLines;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    controller.text = displayText;
    return Padding(
      padding: EdgeInsets.only(
        top: 15,
        bottom: 15,
      ),
      child: TextField(
        controller: controller,
        style: style,
        // keyboardType and maxLines properties allow
        // infinitely large amounts of text
        keyboardType: TextInputType.multiline,
        // minLines assures content field will have 10 blank
        // lines initially, text field will have 1, so they look as expected
        minLines: minLines,
        // maxLines allows unlimted number of lines, with scrollbar,
        // like typical window memo field
        maxLines: null,
        onChanged: onChanged,
        // Getting rid of the normal border line under the
        // TextField. Looks more like what I expect.
        // decoration: InputDecoration(
        //   border: InputBorder.none,
        //   fillColor: Colors.white,
        // ),
      ),
    );
  }
}
