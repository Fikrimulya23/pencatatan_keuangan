import 'package:flutter/material.dart';

class About extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Tentang"),
      ),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: Center(
          child: Column(
            children: [
              SizedBox(
                height: 10,
              ),
              Text(
                "Nama Kelompok",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                '-',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w300),
              ),
              SizedBox(
                height: 15,
              ),
              Text(
                '-',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w300),
              ),
              SizedBox(
                height: 15,
              ),
              Text(
                '-',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w300),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
