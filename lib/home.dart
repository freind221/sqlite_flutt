import 'package:flutter/material.dart';
import 'package:sqlite_flutt/db_handler.dart';
import 'package:sqlite_flutt/note_keep.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DBhelper? dBhelper;
  late Future<List<NodeModel>> noteslist;
  @override
  void initState() {
    super.initState();
    dBhelper = DBhelper();
    loadData();
  }

  loadData() async {
    noteslist = dBhelper!.getNotes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notes Keeper'),
        centerTitle: true,
      ),
      body: FutureBuilder(
          future: noteslist,
          builder: ((context, AsyncSnapshot<List<NodeModel>> snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: ((context, index) {
                  return InkWell(
                    onLongPress: () {
                      dBhelper!.deleteTable();
                      setState(() {
                        noteslist = dBhelper!.getNotes();
                      });
                    },
                    onDoubleTap: () {
                      dBhelper!.update(NodeModel(
                          id: snapshot.data![index].id!,
                          title: 'It is done',
                          age: 19,
                          desc:
                              'NodeModel({int? id, required String title, required int age, required String desc, required String email})',
                          email: ''));
                      setState(() {
                        noteslist = dBhelper!.getNotes();
                      });
                    },
                    child: Dismissible(
                      background: Container(
                        decoration: const BoxDecoration(color: Colors.red),
                        alignment: Alignment.center,
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: const Icon(Icons.delete_forever),
                      ),
                      onDismissed: (direction) {
                        setState(() {
                          dBhelper!.delete(snapshot.data![index].id!);
                          noteslist = dBhelper!.getNotes();
                          snapshot.data!.remove(snapshot.data![index]);
                        });
                      },
                      key: ValueKey<int>(snapshot.data![index].id!),
                      child: Card(
                        child: ListTile(
                          title: Text(snapshot.data![index].title),
                          subtitle: Text(snapshot.data![index].desc),
                          trailing: Text(snapshot.data![index].age.toString()),
                        ),
                      ),
                    ),
                  );
                }));
          })),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          dBhelper!.insert(NodeModel(
              title: 'Kamran',
              age: 22,
              desc: "HOO HOO HOO OOH",
              email: 'kami@gmail.com'));

          setState(() {
            noteslist = dBhelper!.getNotes();
          });
        },
      ),
    );
  }
}
