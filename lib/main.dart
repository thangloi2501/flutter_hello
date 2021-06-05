import 'package:flutter/material.dart';
import 'package:flutter_hello/api/accu_weather_api.dart';
import 'api/open_weather_api.dart';
import 'model/city.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Future<List<City>>? _cities;
  City? _selectedCity;

  @override
  void initState() {
    super.initState();

    _cities = _loadCityData();
  }

  Future<List<City>> _loadCityData() async {
    return new AccuWeatherApi().getCities(150);
  }

  final resultHolder = TextEditingController();

  void _clearAction() {
    resultHolder.clear();
  }

  void _saveAction() => showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text('Sorry!'),
          content: const Text('No action implemented at the moment.'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context, 'Cancel'),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, 'OK'),
              child: const Text('OK'),
            ),
          ],
        ),
      );

  void _callWeatherApi(String city) {
    var api = new OpenWeatherApi();
    api.getCurrentWeather(city).then((weather) {
      resultHolder.text = weather.toString();
    }, onError: (error) {
      resultHolder.text = error.toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image(image: AssetImage('images/weather-icon.png')),
            FutureBuilder<List<City>>(
              future: _cities,
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting: return Text('Loading....');
                  default:
                    if (snapshot.hasError)
                      return Text('Error: ${snapshot.error}');
                    else
                      return DropdownButton<City>(
                      hint: Text("Select city"),
                      value: _selectedCity,
                      onChanged: (City? value) {
                        setState(() {
                          _selectedCity = value;
                        });
                        _callWeatherApi(value!.toFullName());
                      },
                      items: snapshot.data!.map((City city) {
                        return DropdownMenuItem<City>(
                          value: city,
                          child: Row(
                            children: <Widget>[
                              const Icon(
                                Icons.arrow_right,
                                color: Colors.blue,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                city.toFullName(),
                                style: TextStyle(color: Colors.black),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    );
                }
              },
            ),
            Theme(
              data: new ThemeData(
                primaryColor: Colors.redAccent,
                primaryColorDark: Colors.red,
              ),
              child: new TextField(
                decoration: new InputDecoration(
                    border: new OutlineInputBorder(
                        borderSide: new BorderSide(color: Colors.teal)),
                    hintText: 'Please put anything here',
                    helperText: 'Blah blah blah...',
                    labelText: 'Put your note here...',
                    prefixIcon: const Icon(
                      Icons.airplanemode_on,
                      color: Colors.green,
                    ),
                    prefixText: ' ',
                    suffixStyle: const TextStyle(color: Colors.green)),
                controller: resultHolder,
                keyboardType: TextInputType.multiline,
                maxLines: null,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                // TextButton(
                //   style: TextButton.styleFrom(
                //     primary: Colors.black, // foreground
                //     backgroundColor: Colors.blue,
                //   ),
                //   onPressed: _callWeatherApi,
                //   child: Text('LOAD'),
                // ),
                TextButton(
                  style: TextButton.styleFrom(
                    primary: Colors.black, // foreground
                    backgroundColor: Colors.green,
                  ),
                  onPressed: _saveAction,
                  child: Text('SAVE'),
                ),
                TextButton(
                  style: TextButton.styleFrom(
                    primary: Colors.black, // foreground
                    backgroundColor: Colors.red,
                  ),
                  onPressed: _clearAction,
                  child: Text('CLEAR'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
