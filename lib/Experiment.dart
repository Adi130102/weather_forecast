import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:weather/weather.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(const MaterialApp(home: MainFunction(), debugShowCheckedModeBanner: false));
}

class MainFunction extends StatefulWidget {
  const MainFunction({super.key});

  @override
  State<MainFunction> createState() => _MainFunctionState();
}

class _MainFunctionState extends State<MainFunction> {
  TextEditingController mycityField = TextEditingController();
  String myLocation = "Current Location";
  double lat=0;
  double lon=0;
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
        myLocation = "Location permissions are denied";
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      myLocation =
      "Location permissions are permanently denied, we cannot request permissions.";
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
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
        "Address : ${place.name}, ${place.street}, ${place.subLocality}, ${place
            .administrativeArea}, ${place.postalCode}, ${place.country}"
            "\n\nLatitude : ${position.latitude} \nLongitude : ${position
            .longitude} \nAltitude : ${position.altitude}";
        // print(myLocation);
        lat = position.latitude;
        lon = position.longitude;
      });
    } catch (e) {
      setState(() {
        myLocation = "Failed to get Location : ${e}";
      });
    }
    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }

  Future<void> weathereByCity() async {
    WeatherFactory wf =
    WeatherFactory("617a4272b293ee938fd8451ce1c1a5ec");
    if (flag == 1) {
      if (mycityField.text.isNotEmpty) {
        myCity=mycityField.text.trim();
      }
      if(mycityField.text.isEmpty){
        myCity="Ahmedabad";
        mycityField.text="Ahmedabad";
      }
      mycityField.text=myCity;
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

  Future<void> PreciseLocationAditya() async {
    if (flag == 0) {
      WeatherFactory wf =
      new WeatherFactory("617a4272b293ee938fd8451ce1c1a5ec");
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
      print(
          "Sunset : ${DateFormat('dd-MM-yyyy hh:mm:ss a').format(
              w.sunset!)}");

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
      mycityField.text=myArea;
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
    await PreciseLocationAditya();
    currentDateTime();
    FocusScope.of(context).unfocus();

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
          "Current Weather of ${myArea}",
          style: TextStyle(color: Colors.white),
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
              physics: AlwaysScrollableScrollPhysics(),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    color: Colors.blue,
                    padding: EdgeInsets.symmetric(horizontal: 30.0),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 15,
                        ),
                        Container(
                          child: TextField(
                            controller: mycityField,
                            decoration: InputDecoration(
                                fillColor: Colors.white,
                                hintText: "Enter your City name",
                                label: Text(
                                  "city",
                                  style: TextStyle(color: Colors.white),
                                ),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15.0)),
                                prefixIcon: IconButton(
                                  icon: Icon(
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
                                  icon: Icon(Icons.my_location),
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
                        "https://openweathermap.org/img/wn/${myIcon}@2x.png"),

                    // child: Image.network(
                    //     "https://openweathermap.org/img/wn/10d@2x.png"),
                  ),
                  SizedBox(
                    height: 35,
                  ),
                  Container(
                    child: Text(
                      myTemperature,
                      style: TextStyle(fontSize: 50, color: Colors.blue),
                    ),
                  ),
                  Container(
                    child: Text("FeelsLike : ${myFeelsLike}"),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Container(
                    child: Text(
                      myAtmosphere,
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  SizedBox(
                    height: 30.0,
                  ),
                  Container(
                    child: Text(
                      "${currentDate}  ${currentTime}",
                      // style: TextStyle(fontSize: 15),
                    ),
                  ),
                  SizedBox(
                    height: 30.0,
                  ),
                  Container(
                    // padding: EdgeInsets.symmetric(horizontal: 50.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          child: Column(
                            children: [
                              Container(
                                child: Image.asset(
                                  "Assets/sun.png",
                                  width: 80,
                                  height: 80,
                                ),
                              ),
                              Container(
                                child: Column(
                                  children: [Text("Sunrise"), Text(sunRise)],
                                ),
                              ),
                            ],
                          ),
                        ), //Sunrise
                        Container(
                          child: Column(
                            children: [
                              Container(
                                child: Image.asset(
                                  "Assets/sunset.png",
                                  width: 80,
                                  height: 80,
                                ),
                              ),
                              Container(
                                child: Column(
                                  children: [Text("Sunset"), Text(sunSet)],
                                ),
                              ),
                            ],
                          ),
                        ), //Sunset
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 25.0,
                  ),
                  Divider(
                    color: Colors.black12,
                    thickness: 2,
                    indent: 50.0,
                    endIndent: 50.0,
                  ),
                  SizedBox(
                    height: 25.0,
                  ),
                  Container(
                    // padding: EdgeInsets.symmetric(horizontal: 50.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          child: Column(
                            children: [
                              Container(
                                child: Image.asset(
                                  "Assets/Max Temp.png",
                                  width: 80,
                                  height: 80,
                                ),
                              ),
                              Container(
                                child: Column(
                                  children: [
                                    Text("Max Temp"),
                                    Text("${myMaxTemp} °C")
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ), //Sunrise
                        Container(
                          child: Column(
                            children: [
                              Container(
                                child: Image.asset(
                                  "Assets/Min Temp.png",
                                  width: 80,
                                  height: 80,
                                ),
                              ),
                              Container(
                                child: Column(
                                  children: [
                                    Text("Min Temp"),
                                    Text("${myMinTemp} °C")
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ), //Sunset
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 25.0,
                  ),
                  Divider(
                    color: Colors.black12,
                    thickness: 2,
                    indent: 50.0,
                    endIndent: 50.0,
                  ),
                  SizedBox(
                    height: 25.0,
                  ),
                  Container(
                    // padding: EdgeInsets.symmetric(horizontal: 50.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          child: Column(
                            children: [
                              Container(
                                child: Image.asset(
                                  "Assets/barometer.png",
                                  width: 80,
                                  height: 80,
                                ),
                              ),
                              Container(
                                child: Column(
                                  children: [
                                    Text("Pressure"),
                                    Text("${myPressure} hPa")
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ), //Sunrise
                        Container(
                          child: Column(
                            children: [
                              Container(
                                child: Image.asset(
                                  "Assets/humidity.png",
                                  width: 80,
                                  height: 80,
                                ),
                              ),
                              Container(
                                child: Column(
                                  children: [
                                    Text("Humidity"),
                                    Text("${myHumidity}%")
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ), //Sunset
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 25.0,
                  ),
                  Divider(
                    color: Colors.black12,
                    thickness: 2,
                    indent: 50.0,
                    endIndent: 50.0,
                  ),
                  SizedBox(
                    height: 25.0,
                  ),
                  Container(
                    // padding: EdgeInsets.symmetric(horizontal: 50.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          child: Column(
                            children: [
                              Container(
                                child: Image.asset(
                                  "Assets/wind speed.png",
                                  width: 80,
                                  height: 80,
                                ),
                              ),
                              Container(
                                child: Column(
                                  children: [
                                    Text("Wind Speed"),
                                    Text("${myWindSpeed} m/s")
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ), //Sunrise
                        Container(
                          child: Column(
                            children: [
                              Container(
                                child: Image.asset(
                                  "Assets/WindGust.png",
                                  width: 80,
                                  height: 80,
                                ),
                              ),
                              Container(
                                child: Column(
                                  children: [
                                    Text("Wind Gust"),
                                    Text(myWindGust)
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ), //Sunset
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 25.0,
                  ),
                  Divider(
                    color: Colors.black12,
                    thickness: 2,
                    indent: 50.0,
                    endIndent: 50.0,
                  ),
                  SizedBox(
                    height: 25.0,
                  ),
                  Container(
                    // padding: EdgeInsets.symmetric(horizontal: 50.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          child: Column(
                            children: [
                              Container(
                                child: Image.asset(
                                  "Assets/Weather.png",
                                  width: 80,
                                  height: 80,
                                ),
                              ),
                              Container(
                                child: Column(
                                  children: [
                                    Text("WeatherMain"),
                                    Text(myWeatherMain)
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ), //Sunrise
                        Container(
                          child: Column(
                            children: [
                              Container(
                                child: Image.asset(
                                  "Assets/wind-vane.png",
                                  width: 80,
                                  height: 80,
                                ),
                              ),
                              Container(
                                child: Column(
                                  children: [
                                    Text("Wind Degree"),
                                    Text("${myWindDegree}°")
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ), //Sunset
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 50.0,
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Text(
                        "weatherConditionCode : ${myweatherConditionCode}"),
                  ),
                  Divider(
                    color: Colors.black12,
                    thickness: 3,
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 30.0),
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
