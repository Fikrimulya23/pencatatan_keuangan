import 'package:flutter/material.dart';
import 'package:flutter_latihan_shared_preferences/helper.dart';
import 'package:flutter_latihan_shared_preferences/insert.dart';
import 'package:flutter_latihan_shared_preferences/about.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class AllNote extends StatefulWidget {
  @override
  _AllNoteState createState() => _AllNoteState();
}

class _AllNoteState extends State<AllNote> {
  final CalendarController _calendarController = CalendarController();

  var savedData = [];

  getSavedData() async {
    var data = await Data.getData();
    // setelah data didapat panggil setState agar data segera dirender
    setState(() {
      savedData = data;
    });
  }

  @override
  initState() {
    // _calendarController.selectedDate = DateTime.now();
    super.initState();
    // baca Shared Preferences

    getSavedData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            // action tombol ADD untuk proses insert
            // nilai yang dikirim diisi null
            // agar di halaman insert tahu jika null berarti operasi insert data
            // jika tidak null maka update data
            Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Insert(index: null, value: null)))
                .then((value) {
              // jika halaman insert ditutup ambil kembali Shared Preferences
              // untuk mendapatkan data terbaru dan segera ditampilkan ke user
              // misal jika ada data customer yang ditambahkan
              getSavedData();
            });
          },
        ),
        appBar: AppBar(
          title: Text('Lihat semua'),
          actions: <Widget>[
            FlatButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) {
                    return About();
                  },
                ));
              },
              child: Icon(
                Icons.group,
                color: Colors.white,
              ),
            )
          ],
        ),
        body: Padding(
          padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
          child: Container(
            height: MediaQuery.of(context).size.height - 100,
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: [
                Container(
                  height: (MediaQuery.of(context).size.height / 2) - 150,
                  child: ListView.builder(
                      itemCount: savedData.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(savedData[index]['name']),
                          subtitle: Text(savedData[index]['detail'] +
                              ' ' +
                              savedData[index]['date'].toString()),
                          contentPadding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                          onTap: () {
                            //
                            /* print(savedData[index]['date']);
                            print(DateFormat.yMMMd()
                                .format(_calendarController.selectedDate)); */

                            // aksi saat user klik pada item customer pada list view
                            // nilai diisi selain null menandakan di halaman insert operasi yang berjalan adalah update atau delete
                            Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Insert(
                                            index: index,
                                            value: savedData[index])))
                                .then((value) {
                              // jika halaman insert ditutup ambil kembali Shared Preferences
                              // untuk mendapatkan data terbaru dan segera ditampilkan ke user
                              // misal jika ada data customer yang diedit atau dihapus
                              getSavedData();
                            });
                          },
                        );
                      }),
                ),
              ],
            ),
          ),
        ));
  }
}
