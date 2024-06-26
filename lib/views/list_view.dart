import 'package:flutter/material.dart';
import 'package:notes_json/providers/data_provider.dart';
import 'package:provider/provider.dart';
import 'package:yaru/yaru.dart';

class NoteList extends StatelessWidget {
  const NoteList({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: context.read<Data>().notes.length,
      itemBuilder: (context, index) {
        return ListTile(
          tileColor: Colors.grey[200],
          title: Text(
            context.read<Data>().notes[index].title,
            maxLines: 1,
          ),
          subtitle: Text(
            context.read<Data>().notes[index].content,
            maxLines: 2,
          ),
          trailing: IconButton(
              icon: Icon(YaruIcons.trash_filled),
              onPressed: () {
                context.read<Data>().delete(index);
              }),
          onTap: () {
            context.read<Data>().selectIndex(index);
          },
        );
      },
    );
  }
}
