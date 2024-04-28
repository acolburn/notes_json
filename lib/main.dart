import 'package:flutter/material.dart';
import 'package:notes_json/providers/data_provider.dart';
import 'package:notes_json/views/detaills_view.dart';
import 'package:notes_json/views/list_view.dart';
import 'package:provider/provider.dart';
import 'package:yaru/yaru.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<Data>(
      create: (context) => Data(),
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        // theme: yaruBlueLight,
        // darkTheme: yaruBlueDark,
        // highContrastTheme: yaruHighContrastLight,
        // highContrastDarkTheme: yaruHighContrastDark,
        theme: ThemeData(textTheme: GoogleFonts.robotoTextTheme()),

        home: const MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<Data>().readJson();
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 650,
        leading: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            TextButton.icon(
                icon: const Icon(Icons.menu),
                onPressed: () {},
                label: Text('Toggle Notebooks')),
            TextButton.icon(
              icon: const Icon(
                YaruIcons.sidebar,
              ),
              onPressed: () {
                context.read<Data>().changeDisplay();
                // setState(() {
                //   showList = !showList;
                // });
              },
              label: Text("Toggle Sidebar"),
            ),
            TextButton.icon(
              icon: const Icon(Icons.note_add_outlined),
              onPressed: () {
                context.read<Data>().newNote();
              },
              label: Text("New Note"),
            ),
            TextButton.icon(
              icon: const Icon(Icons.library_books_outlined),
              onPressed: () {},
              label: Text('New Notebook'),
            ),
          ],
        ),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          var isWidescreen = constraints.maxWidth > 600;
          // Widescreen and showList=true, show list and detail
          if (isWidescreen && context.watch<Data>().showList) {
            return Row(
              children: [
                Expanded(
                  flex: 1,
                  child: NoteList(),
                ),
                Container(
                  width: 1,
                  color: Colors.blue,
                ),
                Expanded(
                  flex: 3,
                  child: NoteDetail(),
                ),
              ],
            );
            // Not widescreen but showList still true, show list but no detail
          } else if (!isWidescreen && context.watch<Data>().showList) {
            return const Row(
              children: [
                Expanded(
                  child: NoteList(),
                ),
              ],
            );
          } else {
            // showList is false (regardless of screenWidth), show detail
            return Row(
              children: [
                Expanded(child: NoteDetail()),
              ],
            );
          }
        },
      ),
    );
  }
}
