import 'package:flutter/material.dart';
import 'package:weather_app/models/weather_model.dart';
import 'package:weather_app/services/weather_api_client.dart';
import 'package:weather_app/views/additional_information.dart';
import 'package:weather_app/views/current_weather.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner:false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  WeatherApiClient client = WeatherApiClient();
  Weather? data;
  TextEditingController searchCity = TextEditingController();

  Future<void> getData() async {
    if (data == null) {
      data = await client.getCurrentWeather('Severodvinsk');
    } else {
      data = await client.getCurrentWeather(searchCity.text);
    }
  }

  Icon customIcon = Icon(Icons.search);
  Widget customTitle = const Text("Погода");
  var focusNode = FocusNode();

  @override
  void dispose() {
    searchCity.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.lightBlueAccent,
          elevation: 0.0,
          title: customTitle,
          actions: [
            IconButton(
              onPressed: () {
                setState(() {
                  if (customIcon.icon == Icons.search) {
                    customIcon = const Icon(Icons.cancel);
                    customTitle = ListTile(
                      leading: const Icon(
                        Icons.search,
                        color: Colors.white,
                        size: 28,
                      ),
                      title: TextField(
                        onSubmitted: (value) {
                          setState(() {
                            customIcon = const Icon(Icons.search);
                            customTitle = const Text("Погода");
                          });
                        },
                        autofocus: true,
                        controller: searchCity,
                        decoration: const InputDecoration(
                          hintText: 'Введите название города',
                          hintStyle: TextStyle(
                              color: Colors.black26,
                              fontSize: 18,
                              fontStyle: FontStyle.italic),
                          border: OutlineInputBorder(),
                        ),
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    );
                  } else {
                    customIcon = const Icon(Icons.search);
                    customTitle = const Text("Погода");
                  }
                });
              },
              icon: customIcon,
            )
          ],
          centerTitle: true,
        ),
        body: FutureBuilder(
          future: getData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  currentWeather(Icons.wb_sunny_outlined, "${data!.temp}°C",
                      "${data!.cityName}"),
                  const SizedBox(height: 60.0),
                  const Text("Дополнительная информация",
                      style: TextStyle(fontSize: 24.0, color: Colors.grey)),
                  const Divider(),
                  const SizedBox(height: 20.0),
                  additionalInformation(
                      "${data!.wind} м/с",
                      "${data!.humidity}%",
                      "${data!.pressure} гПа",
                      "${data!.feels_like}°C")
                ],
              );
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            return Container();
          },
        ));
  }
}
