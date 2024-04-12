import 'package:flutter/material.dart';
// import 'package:markdown_widget/config/all.dart';
import 'package:notes_json/models/note.dart';
import 'package:notes_json/providers/data_provider.dart';
import 'package:notes_json/views/vertical_split_view.dart';
import 'package:provider/provider.dart';
import 'package:markdown_widget/markdown_widget.dart';
import 'package:flutter_highlight/themes/github.dart';

class NoteDetail extends StatelessWidget {
  // These TextEditingControllers are used to get and set the note's
  // title and text
  final TextEditingController noteTitleController = TextEditingController();
  final TextEditingController noteTextController = TextEditingController();

  NoteDetail({super.key});

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
    noteTextController.text = selNote.content;

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
                        onChanged: (value) {
                          var position =
                              noteTitleController.selection.base.offset;
                          // context.read<Data>().update(title: value);
                          noteTitleController.selection = TextSelection(
                              baseOffset: position, extentOffset: position);
                        }),
                  ),

                  // Note Text TextField---------------------------------
                  Padding(
                    padding: EdgeInsets.only(
                      top: 15,
                      bottom: 15,
                    ),
                    child: TextField(
                      controller: noteTextController,
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
                    ),
                  ),

                  // Save Button------------------------------------------
                  Padding(
                    padding: EdgeInsets.only(
                      top: 15,
                      bottom: 15,
                    ),
                    child: ElevatedButton(
                      child: Text('Save'),
                      onPressed: () async {
                        selNote = context.read<Data>().selectedNote;

                        var title = noteTitleController.text;
                        var content = noteTextController.text;
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
                        data: noteTextController.text,
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
