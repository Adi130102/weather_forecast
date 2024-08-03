import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:weather/weather.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(const MaterialApp(
      home: MainFunction(), debugShowCheckedModeBanner: false));
}

class MainFunction extends StatefulWidget {
  const MainFunction({super.key});

  @override
  State<MainFunction> createState() => _MainFunctionState();
}

class _MainFunctionState extends State<MainFunction> {
  TextEditingController mycityField = TextEditingController();
  String myLocation = "Current Location";
  double lat = 0;
  double lon = 0;
  String myTemperature = "0";
  String myAtmosphere = "0";
  String currentTime = "";
  String currentDate = "";
  String sunRise = "";
  String sunSet = "";
  String o1 = "";
  String myIcon = "";
  String myMaxTemp = "0";
  String myMinTemp = "0";
  String myFeelsLike = "0";
  String myPressure = "0";
  String myHumidity = "0";
  String myWindDegree = "0";
  String myWindSpeed = "0";
  String myWindGust = "0";
  String myArea = "City";
  String myWeatherMain = "";
  String myweatherConditionCode = "";
  String myCity = "Ahmedabad";
  int flag = 0;
  List<dynamic> names = [
    "Aditya",
    "Patel",
    "33",
    "202300819010088",
    "GLS University",
    "MScIT",
    "Sem-3"
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    callAllFunctionDirectly();
  }

  // Future<void> checkConnectivity() async {
  //   // var connectivityResult = await Connectivity().checkConnectivity();
  //   var connectivityResult = await Connectivity().checkConnectivity();
  //   if (connectivityResult == ConnectivityResult.none) {
  //   // if (connectivityResult == connectivityResult.isEmpty) {
  //     showDialog(
  //       context: context,
  //       builder: (context) {
  //         return AlertDialog(
  //           title: Text("No Internet Connection"),
  //           backgroundColor: Colors.blueAccent,
  //           content: Text("Please check your internet connection and try again"),
  //           actions: [
  //             TextButton(onPressed: (){
  //               Navigator.of(context).pop();
  //             }, child: Text("OK"))
  //           ],
  //         );
  //       },
  //     );
  //   }
  // }

  Future<Position> _determinePosition() async {
    LocationPermission permission;

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        setState(() {
          myLocation = "Location permissions are denied";
        });
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      setState(() {
        myLocation =
            "Location permissions are permanently denied, we cannot request permissions.";
      });
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    // showDialog(builder: (context) {
    //   return const Center(child: CircularProgressIndicator(),);
    // },);
    showDialog(
      context: context,
      builder: (context) {
        return const Center(child: CircularProgressIndicator());
      },
    );
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    Placemark place = placemarks[0];

    try {
      setState(() {
        myLocation =
            // "Address : ${place.street}, ${place.thoroughfare}, ${place.locality}, ${place.administrativeArea}, ${place.postalCode}, ${place.country}."
            // "Address : ${place.name} ${place.subAdministrativeArea}, ${place.thoroughfare}, ${place.subLocality}, ${place.postalCode}, ${place.locality}, ${place.administrativeArea}, ${place.country}"
            "Address : ${place.name}, ${place.street}, ${place.subLocality}, ${place.administrativeArea}, ${place.postalCode}, ${place.country}"
            "\n\nLatitude : ${position.latitude} \nLongitude : ${position.longitude} \nAltitude : ${position.altitude}";
        // print(myLocation);
        lat = position.latitude;
        lon = position.longitude;
      });
    } catch (e) {
      setState(() {
        myLocation = "Failed to get Location : $e";
      });
    }
    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    // return await Geolocator.getCurrentPosition();
    return position;
  }

  Future<void> weathereByCity() async {
    WeatherFactory wf = WeatherFactory("617a4272b293ee938fd8451ce1c1a5ec");
    if (flag == 1) {
      if (mycityField.text.isNotEmpty) {
        myCity = mycityField.text.trim();
      }
      if (mycityField.text.isEmpty) {
        myCity = "Ahmedabad";
        mycityField.text = "Ahmedabad";
      }
      mycityField.text = myCity;
      Weather w = await wf.currentWeatherByCityName(myCity);

      // print("Temperature is ${w.temperature?.celsius?.toString()}");
      myTemperature = "${w.temperature?.celsius?.toStringAsPrecision(4)}° C";

      myAtmosphere = w.weatherDescription.toString();
      // print("Atmosphere is ${myAtmosphere}");

      // sunRise=w.sunrise.toString();
      // sunRise = DateFormat("dd-MM-yyyy hh:mm:ss a").format(w.sunrise!);
      sunRise = DateFormat("hh:mm:ss a").format(w.sunrise!);
      // print(
      //     "Sunrise : ${DateFormat("dd-MM-yyyy hh:mm:ss a").format(w.sunrise!)}");

      // sunSet=w.sunset.toString();
      // sunSet = DateFormat("dd-MM-yyyy hh:mm:ss a").format(w.sunset!);
      sunSet = DateFormat("hh:mm:ss a").format(w.sunset!);
      // print(
      //     "Sunset : ${DateFormat('dd-MM-yyyy hh:mm:ss a').format(
      //         w.sunset!)}");

      // o1=w.areaName.toString();
      // o1=w.cloudiness.toString();
      myIcon = w.weatherIcon.toString();
      myMaxTemp = w.tempMax!.celsius!.toStringAsPrecision(4);
      myMinTemp = w.tempMin!.celsius!.toStringAsPrecision(4);
      myFeelsLike = w.tempFeelsLike.toString();
      myPressure = w.pressure!.toString();
      myHumidity = w.humidity.toString();
      myWindDegree = w.windDegree.toString();
      myWindSpeed = w.windSpeed.toString();
      myArea = w.areaName.toString();
      myWeatherMain = w.weatherMain.toString();
      myweatherConditionCode = w.weatherConditionCode.toString();
      myWindGust = w.windGust.toString();
      // print("Max Temp : ${myMaxTemp}");
      // print("Min Temp : ${myMinTemp}");
      // print("FeelsLike : ${myFeelsLike}");

      setState(() {});
    }
  }

  Future<void> preciseLocationAditya() async {
    if (flag == 0) {
      WeatherFactory wf = WeatherFactory("617a4272b293ee938fd8451ce1c1a5ec");
      Weather w = await wf.currentWeatherByLocation(lat, lon);
      // Weather w = await wf.currentWeatherByCityName(myCity);

      // print("Temperature is ${w.temperature?.celsius?.toString()}");
      myTemperature = "${w.temperature?.celsius?.toStringAsPrecision(4)}° C";

      myAtmosphere = w.weatherDescription.toString();
      // print("Atmosphere is ${myAtmosphere}");

      // sunRise=w.sunrise.toString();
      // sunRise = DateFormat("dd-MM-yyyy hh:mm:ss a").format(w.sunrise!);
      sunRise = DateFormat("hh:mm:ss a").format(w.sunrise!);
      // print(
      //     "Sunrise : ${DateFormat("dd-MM-yyyy hh:mm:ss a").format(w.sunrise!)}");

      // sunSet=w.sunset.toString();
      // sunSet = DateFormat("dd-MM-yyyy hh:mm:ss a").format(w.sunset!);
      sunSet = DateFormat("hh:mm:ss a").format(w.sunset!);
      // print(
      //     "Sunset : ${DateFormat('dd-MM-yyyy hh:mm:ss a').format(
      //         w.sunset!)}");

      // o1=w.areaName.toString();
      // o1=w.cloudiness.toString();
      myIcon = w.weatherIcon.toString();
      myMaxTemp = w.tempMax!.celsius!.toStringAsPrecision(4);
      myMinTemp = w.tempMin!.celsius!.toStringAsPrecision(4);
      myFeelsLike = w.tempFeelsLike.toString();
      myPressure = w.pressure!.toString();
      myHumidity = w.humidity.toString();
      myWindDegree = w.windDegree.toString();
      myWindSpeed = w.windSpeed.toString();
      myArea = w.areaName.toString();
      myWeatherMain = w.weatherMain.toString();
      myweatherConditionCode = w.weatherConditionCode.toString();
      myWindGust = w.windGust.toString();
      mycityField.text = myArea;
      setState(() {});
    }
  }

  Future<void> currentDateTime() async {
    DateTime now = DateTime.now();
    setState(() {
      // currentTime="${now.hour}:${now.minute}:${now.second}";
      currentTime = DateFormat('hh:mm:ss a').format(now);
      // print("currentTime is ${(currentTime)}");
      // currentDate="${now.day}/${now.month}/${now.year}";
      currentDate = DateFormat('dd/MM/yyyy').format(now);
      // print("currentDate is ${currentDate}");
    });
    Navigator.of(context).pop();
    FocusScope.of(context).unfocus();
  }

  void callAllFunctionDirectly() async {
    // await checkConnectivity();
    await _determinePosition();
    await weathereByCity();
    await preciseLocationAditya();
    currentDateTime();
  }

  Future<void> refresh() async {
    await Future.delayed(Duration.zero);
    setState(() {
      callAllFunctionDirectly();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Current Weather of $myArea",
          style: const TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: RefreshIndicator(
        onRefresh: refresh,
        backgroundColor: Colors.blue,
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    color: Colors.blue,
                    padding: const EdgeInsets.symmetric(horizontal: 30.0),
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 15,
                        ),
                        TextField(
                          controller: mycityField,
                          decoration: InputDecoration(
                              fillColor: Colors.white,
                              hintText: "Enter your City name",
                              label: const Text(
                                "city",
                                style: TextStyle(color: Colors.white),
                              ),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15.0)),
                              prefixIcon: IconButton(
                                icon: const Icon(
                                  Icons.search,
                                  color: Colors.white,
                                ),
                                onPressed: () {
                                  FocusScope.of(context).unfocus();
                                  flag = 1;
                                  callAllFunctionDirectly();
                                },
                              ),
                              suffixIcon: IconButton(
                                icon: const Icon(Icons.my_location),
                                onPressed: () {
                                  FocusScope.of(context).unfocus();
                                  flag = 0;
                                  callAllFunctionDirectly();
                                },
                              )),
                          onEditingComplete: () {
                            FocusScope.of(context).unfocus();
                            setState(() {
                              flag = 1;
                              callAllFunctionDirectly();
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: double.maxFinite,
                    height: 100,
                    color: Colors.blue,
                    child: myIcon.isEmpty
                        ? Image.asset(
                            "Assets/Weather.png",
                          )
                        : Image.network(
                            "https://openweathermap.org/img/wn/$myIcon@2x.png"),

                    // child: Image.network(
                    //     "https://openweathermap.org/img/wn/10d@2x.png"),
                  ),
                  const SizedBox(
                    height: 35,
                  ),
                  Text(
                    myTemperature,
                    style: const TextStyle(fontSize: 50, color: Colors.blue),
                  ),
                  Text("FeelsLike : $myFeelsLike"),
                  const SizedBox(
                    height: 10.0,
                  ),
                  Text(
                    myAtmosphere,
                    style: const TextStyle(fontSize: 20),
                  ),
                  const SizedBox(
                    height: 30.0,
                  ),
                  Text(
                    "$currentDate  $currentTime",
                    // style: TextStyle(fontSize: 15),
                  ),
                  const SizedBox(
                    height: 30.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        children: [
                          Image.asset(
                            "Assets/sun.png",
                            width: 80,
                            height: 80,
                          ),
                          Column(
                            children: [const Text("Sunrise"), Text(sunRise)],
                          ),
                        ],
                      ), //Sunrise
                      Column(
                        children: [
                          Image.asset(
                            "Assets/sunset.png",
                            width: 80,
                            height: 80,
                          ),
                          Column(
                            children: [const Text("Sunset"), Text(sunSet)],
                          ),
                        ],
                      ), //Sunset
                    ],
                  ),
                  const SizedBox(
                    height: 25.0,
                  ),
                  const Divider(
                    color: Colors.black12,
                    thickness: 2,
                    indent: 50.0,
                    endIndent: 50.0,
                  ),
                  const SizedBox(
                    height: 25.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        children: [
                          Image.asset(
                            "Assets/Max Temp.png",
                            width: 80,
                            height: 80,
                          ),
                          Column(
                            children: [
                              const Text("Max Temp"),
                              Text("$myMaxTemp °C")
                            ],
                          ),
                        ],
                      ), //Sunrise
                      Column(
                        children: [
                          Image.asset(
                            "Assets/Min Temp.png",
                            width: 80,
                            height: 80,
                          ),
                          Column(
                            children: [
                              const Text("Min Temp"),
                              Text("$myMinTemp °C")
                            ],
                          ),
                        ],
                      ), //Sunset
                    ],
                  ),
                  const SizedBox(
                    height: 25.0,
                  ),
                  const Divider(
                    color: Colors.black12,
                    thickness: 2,
                    indent: 50.0,
                    endIndent: 50.0,
                  ),
                  const SizedBox(
                    height: 25.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        children: [
                          Image.asset(
                            "Assets/barometer.png",
                            width: 80,
                            height: 80,
                          ),
                          Column(
                            children: [
                              const Text("Pressure"),
                              Text("$myPressure hPa")
                            ],
                          ),
                        ],
                      ), //Sunrise
                      Column(
                        children: [
                          Image.asset(
                            "Assets/humidity.png",
                            width: 80,
                            height: 80,
                          ),
                          Column(
                            children: [
                              const Text("Humidity"),
                              Text("$myHumidity%")
                            ],
                          ),
                        ],
                      ), //Sunset
                    ],
                  ),
                  const SizedBox(
                    height: 25.0,
                  ),
                  const Divider(
                    color: Colors.black12,
                    thickness: 2,
                    indent: 50.0,
                    endIndent: 50.0,
                  ),
                  const SizedBox(
                    height: 25.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        children: [
                          Image.asset(
                            "Assets/wind speed.png",
                            width: 80,
                            height: 80,
                          ),
                          Column(
                            children: [
                              const Text("Wind Speed"),
                              Text("$myWindSpeed m/s")
                            ],
                          ),
                        ],
                      ), //Sunrise
                      Column(
                        children: [
                          Image.asset(
                            "Assets/WindGust.png",
                            width: 80,
                            height: 80,
                          ),
                          Column(
                            children: [
                              const Text("Wind Gust"),
                              Text(myWindGust)
                            ],
                          ),
                        ],
                      ), //Sunset
                    ],
                  ),
                  const SizedBox(
                    height: 25.0,
                  ),
                  const Divider(
                    color: Colors.black12,
                    thickness: 2,
                    indent: 50.0,
                    endIndent: 50.0,
                  ),
                  const SizedBox(
                    height: 25.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        children: [
                          Image.asset(
                            "Assets/Weather.png",
                            width: 80,
                            height: 80,
                          ),
                          Column(
                            children: [
                              const Text("WeatherMain"),
                              Text(myWeatherMain)
                            ],
                          ),
                        ],
                      ), //Sunrise
                      Column(
                        children: [
                          Image.asset(
                            "Assets/wind-vane.png",
                            width: 80,
                            height: 80,
                          ),
                          Column(
                            children: [
                              const Text("Wind Degree"),
                              Text("$myWindDegree°")
                            ],
                          ),
                        ],
                      ), //Sunset
                    ],
                  ),
                  const SizedBox(
                    height: 50.0,
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child:
                        Text("weatherConditionCode : $myweatherConditionCode"),
                  ),
                  const Divider(
                    color: Colors.black12,
                    thickness: 3,
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(30.0, 0, 0, 15.0),
                    child: Text(myLocation),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
