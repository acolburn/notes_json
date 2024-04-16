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
    // noteTitleController.addListener(_doSomething);
  }

  @override
  void dispose() {
    noteContentController.dispose();
    noteTitleController.dispose();
    super.dispose();
  }

  // void _doSomething() {
  //   print('_doSomething called');
  //   noteTitleController.text = context.read<Data>().selectedNote.title;
  //   // context.read<Data>().update();
  // }

  @override
  Widget build(BuildContext context) {
    final tocController = TocController();
    Note? selNote = context.watch<Data>().selectedNote;

    // If we're creating a new note, then the page
    // should be blank. If we're displaying an existing note, this code
    // sets the note's title and text.
    // selNote == null
    //     ? noteTitleController.text = ''
    //     : noteTitleController.text = selNote.title;
    noteTitleController.text = selNote.title;

    // selNote == null
    //     ? noteTextController.text = ''
    //     : noteTextController.text = selNote.content;
    noteContentController.text = selNote.content;

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
        ),
        body: TabBarView(
          children: [
            // Edit Screen
            Container(
              margin: const EdgeInsets.all(18),
              child: ListView(
                children: [
                  // Note Title TextField---------------------------------
                  Padding(
                    padding: EdgeInsets.only(
                      top: 15,
                      bottom: 15,
                    ),
                    child: TextField(
                      controller: noteTitleController,
                      style: Theme.of(context).textTheme.titleLarge!,
                      maxLines: 1,
                      onChanged: (value) {},
                    ),
                  ),

                  // Note Text TextField---------------------------------
                  Padding(
                    padding: EdgeInsets.only(
                      top: 15,
                      bottom: 15,
                    ),
                    child: TextField(
                      controller: noteContentController,
                      // keyboardType and maxLines properties allow
                      // infinitely large amounts of text
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      // minLines assures textfield will have 10 blank
                      // lines initially, instead of just 1, so it looks more
                      // like a memo field
                      minLines: 10,
                      // Getting rid of the normal border line under the
                      // TextField. Looks more like what I expect.
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        fillColor: Colors.white,
                      ),
                      onChanged: (value) {
                        // context.read<Data>().changeButtonColor();
                      },
                    ),
                  ),

                  // Save Button------------------------------------------
                  Padding(
                    padding: EdgeInsets.only(
                      top: 15,
                      bottom: 15,
                    ),
                    child: ElevatedButton(
                      onPressed: () async {
                        selNote = context.read<Data>().selectedNote;

                        var title = noteTitleController.text;
                        var content = noteContentController.text;
                        // If this is a new note ... create it
                        if (selNote == null) {
                          context.read<Data>().add(title, content);
                        } else {
                          // If this is an already existing note ... update it
                          selNote!.title = title;
                          selNote!.content = content;
                          context
                              .read<Data>()
                              .update(title: title, content: content);
                        }
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
