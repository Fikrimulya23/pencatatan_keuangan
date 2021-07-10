import 'package:flutter/material.dart';
import 'package:flutter_latihan_shared_preferences/all_note.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'helper.dart';
import 'insert.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.green,
        primaryColor: Colors.green,
      ),
      home: MyHomePage(),
      // home: BottomNavigation(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final CalendarController _calendarController = CalendarController();
  // data customer yang akan ditampilkan di list view
  // beri nilai awal berupa list kosong agar tidak error
  // nantinya akan diisi data dari Shared Preferences
  var savedData = [];

  // method untuk mengambil data Shared Preferences
  getSavedData() async {
    var data = await Data.getData();
    // setelah data didapat panggil setState agar data segera dirender
    setState(() {
      savedData = data;
    });
  }

  // init state ini dipanggil pertama kali oleh flutter
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
          title: Text('Pencatatan Keuangan'),
          actions: <Widget>[
            FlatButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) {
                    return AllNote();
                  },
                ));
              },
              /* child: Text(
                'Lihat semua',
                style: TextStyle(color: Colors.white),
              ), */
              child: Icon(
                Icons.list,
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
                  child: SfCalendar(
                    dataSource: null,
                    view: CalendarView.month,
                    initialSelectedDate: DateTime.now(),
                    controller: _calendarController,
                    onSelectionChanged: (calendarSelectionDetails) {
                      Future.delayed(Duration.zero, () async {
                        _calendarController.selectedDate =
                            calendarSelectionDetails.date;
                        setState(() {});
                      });
                    },
                  ),
                ),
                Expanded(
                  child: Container(
                    // height: (MediaQuery.of(context).size.height / 2) - 200,
                    child: ListView.builder(
                        itemCount: savedData.length,
                        itemBuilder: (context, index) {
                          return (savedData[index]['date'] ==
                                  DateFormat.yMMMd()
                                      .format(_calendarController.selectedDate))
                              ? ListTile(
                                  title: Text(savedData[index]['name']),
                                  subtitle: Text(savedData[index]['detail'] +
                                      ' ' +
                                      savedData[index]['date'].toString()),
                                  contentPadding:
                                      EdgeInsets.fromLTRB(0, 0, 0, 0),
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
                                )
                              : Container();
                        }),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
