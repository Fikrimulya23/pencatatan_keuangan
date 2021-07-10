import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import 'helper.dart';

class Insert extends StatefulWidget {
  final index;
  final value;
  Insert({Key key, @required this.index, @required this.value})
      : super(key: key);

  @override
  _InsertState createState() => _InsertState(index: index, value: value);
}

class _InsertState extends State<Insert> {
  _InsertState({@required this.index, @required this.value}) : super();
  // variabel untuk menampung data yang dikirim dari halaman home
  final index;
  final value;

  DateTime _selectedDate = DateTime.now();

  // controller TextField untuk validasi
  final nameController = TextEditingController();
  final detailController = TextEditingController();
  final dateController = TextEditingController();

  // cek semua data sudah diisi atau belum
  isDataValid() {
    if (nameController.text.isEmpty) {
      return false;
    }

    if (detailController.text.isEmpty) {
      return false;
    }

    if (dateController.text.isEmpty) {
      return false;
    }

    return true;
  }

  getData() {
    // jika nilai index dan value yang dikirim dari halaman home tidak null
    // artinya ini adalah operasi update
    // tampilkan data yang dikirim, sehingga user bisa edit
    if (index != null && value != null) {
      setState(() {
        nameController.text = value['name'];
        detailController.text = value['detail'];
        dateController.text = value['date'];
      });
    }
  }

  // proses menyimpan data yang diinput user ke Shared Preferences
  saveData() async {
    // cek semua data sudah diisi atau belum
    // jika belum tampilkan pesan error
    if (isDataValid()) {
      // data yang akan dimasukkan atau diupdate ke Shared Preferences sesuai input user
      var note = {
        'name': nameController.text,
        'detail': detailController.text,
        'date': dateController.text
      };

      // ambil data Shared Preferences sebagai list
      var savedData = await Data.getData();

      if (index == null) {
        // index == null artinya proses insert
        // masukkan data pada index 0 pada data Shared Preferences
        // sehingga pada halaman Home data yang baru dimasukkan
        // akan tampil paling atas
        savedData.insert(0, note);
      } else {
        // jika index tidak null artinya proses update
        // update data Shared Preferences sesuai index-nya
        savedData[index] = note;
      }
      // simpan data yang diinsert / diedit user ke Shared Preferences kembali
      // kemudian tutup halaman insert ini
      await Data.saveData(savedData);

      Navigator.pop(context);
    } else {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Empty Field'),
              content: Text('Please fill all field.'),
              actions: <Widget>[
                FlatButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('OK'),
                )
              ],
            );
          });
    }
  }

  deleteData() async {
    // ambil data Shared Preferences sebagai list
    // delete data pada index yang sesuai
    // kemudian simpan kembali ke Shared Preferences
    // dan kembali ke halaman Home
    var savedData = await Data.getData();
    savedData.removeAt(index);

    await Data.saveData(savedData);

    Navigator.pop(context);
  }

  getDeleteButton() {
    // jika proses update tampilkan tombol delete
    // jika insert return widget kosong
    if (index != null && value != null) {
      return FlatButton(
        child: Text(
          'Hapus',
          style: TextStyle(color: Colors.white),
        ),
        onPressed: () {
          deleteData();
        },
      );
    } else {
      return SizedBox.shrink();
    }
  }

  @override
  initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Note'),
          actions: <Widget>[
            getDeleteButton(),
            FlatButton(
              onPressed: () {
                saveData();
              },
              child: Text(
                'Simpan',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
        body: Padding(
          padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('Note'),
              TextField(
                controller: nameController,
              ),
              Padding(
                padding: EdgeInsets.only(top: 20),
              ),
              Text('Harga'),
              TextField(
                keyboardType: TextInputType.number,
                controller: detailController,
              ),
              Padding(
                padding: EdgeInsets.only(top: 20),
              ),
              Text('Tanggal'),
              TextField(
                decoration: InputDecoration(
                  suffixIcon: Icon(Icons.calendar_today),
                ),
                keyboardType: null,
                controller: dateController,
                onTap: () {
                  _selectDate(context);
                },
              )
            ],
          ),
        ));
  }

  _selectDate(BuildContext context) async {
    final newSelectedDate = await showDatePicker(
      context: context,
      initialDate: (_selectedDate != null) ? _selectedDate : DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2040),
      /* builder: (BuildContext context, Widget child) {
          return Theme(
            data: ThemeData.dark().copyWith(
              colorScheme: ColorScheme.dark(
                primary: Colors.deepPurple,
                onPrimary: Colors.white,
                surface: Colors.blueGrey,
                onSurface: Colors.yellow,
              ),
              dialogBackgroundColor: Colors.blue[500],
            ),
            child: child,
          );
        } */
    );

    if (newSelectedDate != null) {
      _selectedDate = newSelectedDate;
      dateController
        ..text = DateFormat.yMMMd().format(_selectedDate)
        ..selection = TextSelection.fromPosition(TextPosition(
            offset: dateController.text.length,
            affinity: TextAffinity.upstream));
    }
  }

  /* showDatePicker(
  context: context,
  initialDate: DateTime.now(),
  firstDate: DateTime(2019, 1),
  lastDate: DateTime(2021,12),
  builder: (context,picker){
    return Theme(
    //TODO: change colors
    data: ThemeData.dark().copyWith(
      colorScheme: ColorScheme.dark(
        primary: Colors.deepPurple,
        onPrimary: Colors.white,
        surface: Colors.pink,
        onSurface: Colors.yellow,
      ),
      dialogBackgroundColor:Colors.green[900],
     ),
     child: picker!,);
   })
   .then((selectedDate) {
     //TODO: handle selected date
     if(selectedDate!=null){
       _controller.text = selectedDate.toString();
     }
 }); */
}
