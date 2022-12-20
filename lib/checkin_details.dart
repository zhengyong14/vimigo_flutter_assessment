import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'checkin_class.dart';
import 'package:intl/intl.dart';
import 'package:share/share.dart';

class CheckinDetails extends StatefulWidget {
  final Checkin checkin;
  CheckinDetails({required this.checkin});

  @override
  State<CheckinDetails> createState() => _CheckinDetailsState();
}

class _CheckinDetailsState extends State<CheckinDetails> {
  late DateFormat finalFormat = DateFormat("yyyy-MM-dd HH:mm:ss");


  @override
  void initState() {
    super.initState();
    _loadformat();
  }

  void _loadformat() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      String dateformat = (prefs.getString('datetimeformat') ?? "yyyy-MM-dd HH:mm:ss");

    finalFormat = DateFormat(dateformat);

    });
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Checkin Detail"),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            ListTile(
              title: Text("User Name"),
              subtitle: Text(widget.checkin.user),
            ),
            ListTile(
              title: Text("Check in time"),
              subtitle: Text(finalFormat.format(widget.checkin.time).toString()),
            ),
            ListTile(
              title: Text("Contact Detail"),
              subtitle: Text(widget.checkin.contact),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
              child: Column(
                children: <Widget>[
                  ElevatedButton(
                  onPressed: () {
                    Share.share("Contact number of ${widget.checkin.user}: ${widget.checkin.contact} had been shared!");
                    },
                    style: ButtonStyle(
                        backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.blue)),
                    child: const Text('Click to share contact',
                        style: TextStyle(color: Colors.white)),
                  )
                ],
              ),
            ),
      ]),
    )
    );
  }
}