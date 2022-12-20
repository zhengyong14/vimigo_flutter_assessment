import 'package:flutter/material.dart';
import 'package:slide_action/slide_action.dart';
import 'checkin_details.dart';
import 'checkin_class.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hive/hive.dart';

import 'introduction_page.dart';

void main() {
  runApp(MaterialApp(
    home: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<Checkin> checkins = [
    Checkin(
        user: "Chan Saw Lin",
        contact: "0152131113",
        time: DateTime.parse('2020-06-30 16:10:05')),
    Checkin(
        user: "Lee Saw Loy",
        contact: "0161231346",
        time: DateTime.parse('2020-07-11 15:39:59')),
    Checkin(
        user: "Khaw Tong Lin",
        contact: "0158398109",
        time: DateTime.parse('2020-08-19 11:10:18')),
    Checkin(
        user: "Lim Kok Lin",
        contact: "0168279101",
        time: DateTime.parse('2020-08-19 11:11:35'))
  ];

  // This list holds the data for the list view
  List<Checkin> _foundRecord = [];

  final _controller = ScrollController();

  bool isSwitched = false;
  bool introstatus = true;

  String dateformat = "yyyy-MM-dd HH:mm:ss";

  @override
  initState() {
    // at the beginning, all users are shown
    checkins.sort((a, b) {
      //sorting in ascending order
      return DateTime.parse(b.time.toString())
          .compareTo(DateTime.parse(a.time.toString()));
    });
    _foundRecord = checkins;

    _controller.addListener(() {
      if (_controller.position.atEdge) {
        bool isTop = _controller.position.pixels == 0;
        if (!isTop) {
          showDialog(
            context: context,
            builder: (BuildContext context) => _bottomDialog(context),
          );
        }
      }
    });

    _getChangeTimeZoneToggleButton();
    _getIntroStatus();
    super.initState();
  }

  // This function is called whenever the text field changes
  void _runFilter(String enteredKeyword) {
    List<Checkin> results = [];
    if (enteredKeyword.isEmpty) {
      // if the search field is empty or only contains white-space, we'll display all users
      results = checkins;
    } else {
      results = checkins
          .where((checkin) =>
              checkin.user.toLowerCase().contains(enteredKeyword.toLowerCase()))
          .toList();
      // we use the toLowerCase() method to make it case-insensitive
    }

    // Refresh the UI
    setState(() {
      _foundRecord = results;
    });
  }

  void _changeTimeZone(String format) async {
    // DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss");

    final prefs = await SharedPreferences.getInstance();
    setState(() {
      prefs.setString('datetimeformat', format);
    });
  }

  void _setChangeTimeZoneToggleButton(bool status) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      prefs.setBool('datetimeformattoogle', status);
    });
  }

  void _getChangeTimeZoneToggleButton() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
       isSwitched = (prefs.getBool('datetimeformattoogle') ?? false);

    });
  }

  void _getIntroStatus() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      introstatus = (prefs.getBool('introduction') ?? true);

    });
  }

  Widget _buildPopupDialog(BuildContext context) {
    return AlertDialog(
      title: const Text('Checked-in Successfully'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const <Widget>[
          Text("Checked-in successfully"),
        ],
      ),
    );
  }

  Widget _bottomDialog(BuildContext context) {
    return AlertDialog(
      title: const Text('List View Reached Bottom'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const <Widget>[
          Text("You have reached the end of the list"),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    bool firstTimeState = introstatus;
    return firstTimeState
        ? const IntroductionPage()
        : Scaffold(
        appBar: AppBar(
          title: const Text("Check-in"),
        ),
        body: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(children: [
              SlideAction(
                trackBuilder: (context, state) {
                  return Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: Colors.white,
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 8,
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        "Slide to check-in",
                      ),
                    ),
                  );
                },
                thumbBuilder: (context, state) {
                  return Container(
                    margin: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.orange,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.chevron_right,
                        color: Colors.white,
                      ),
                    ),
                  );
                },
                action: () {
                  checkins.add(Checkin(
                      user: "Kong Zheng Yong",
                      contact: "0162218806",
                      time: DateTime.now().toLocal()));
                  showDialog(
                    context: context,
                    builder: (BuildContext context) =>
                        _buildPopupDialog(context),
                  );
                  setState(() {
                    checkins.sort((a, b) {
                      //sorting in ascending order
                      return DateTime.parse(b.time.toString())
                          .compareTo(DateTime.parse(a.time.toString()));
                    });
                    _foundRecord = checkins;
                  });
                },
              ),
              const SizedBox(
                height: 20,
              ),
              TextField(
                onChanged: (value) => _runFilter(value),
                decoration: const InputDecoration(
                    labelText: 'Search', suffixIcon: Icon(Icons.search)),
              ),
              const SizedBox(
                height: 20,
              ),
              SwitchListTile(
                value: isSwitched,
                onChanged: (value) {
                  setState(() {
                    isSwitched = value;
                        setState(() {
                          if (isSwitched == true) {
                            _changeTimeZone("dd-MM-yyyy HH:mm");
                          } else {
                            _changeTimeZone("yyyy-MM-dd HH:mm:ss");
                          }
                          _setChangeTimeZoneToggleButton(isSwitched);
                        });
                  });
                },
                title: Text("Change date time format"),
                activeTrackColor: Colors.lightGreenAccent,
                activeColor: Colors.green,
              ),
              Expanded(
                child: _foundRecord.isNotEmpty
                    ? ListView.builder(
                        controller: _controller,
                        itemCount: _foundRecord.length,
                        itemBuilder: (context, index) => Card(
                              color: Colors.amberAccent,
                              elevation: 4,
                              margin: const EdgeInsets.symmetric(vertical: 10),
                              child: ListTile(
                                title: Text(_foundRecord[index].user),
                                subtitle: Text(
                                    "Check-in on ${timeago.format(_foundRecord[index].time).toString()}"),
                                onTap: () => Navigator.of(context)
                                    .push(MaterialPageRoute(
                                  builder: (context) => CheckinDetails(
                                      checkin: _foundRecord[index]),
                                )),
                              ),
                            ))
                    : const Text(
                        'No results found',
                        style: TextStyle(fontSize: 24),
                      ),
              ),
            ])));
  }
}
