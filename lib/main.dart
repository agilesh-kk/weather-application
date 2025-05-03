import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:weather_app/key.dart';
import 'package:intl/intl.dart';
import 'package:weather_icons/weather_icons.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {

  
  List<String> cities = [
  'Madurai', 'Chennai', 'Mumbai', 'Delhi', 'Bangalore',
  'New York', 'London', 'Paris', 'Tokyo', 'Sydney',
  'Dubai', 'Singapore', 'Cairo', 'Toronto', 'Berlin',
  'Moscow', 'Rome', 'Istanbul', 'Cape Town', 'Beijing',
  ];
  String selectedCity = 'Madurai';

  // @override
  // void initState(){
  //   super.initState();
  //   getcurrentweather();
  // }
  Future <Map<String, dynamic>> getcurrentweather() async{
    try{
      //String cityname="Madurai";
      final res = await http.get(
        Uri.parse('https://api.openweathermap.org/data/2.5/forecast?q=$selectedCity&APPID=$apikey')
      );
      
      final data = jsonDecode(res.body);
      
      if(data['cod']!='200'){
        throw 'An expected occur occured';
      }
      return data;
     
      // temperature = (data['list'][0]['main']['temp']) as double;
      // celcius = (temperature - 273.15).round();
      // humidity = data['list'][0]['main']['humidity'];
      // pressure = data['list'][0]['main']['pressure'];
      // windSpeed = data['list'][0]['wind']['speed'];
    
  } catch (e) {
    throw e.toString(); // 🔍 This will help you see what went wrong
  }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(useMaterial3: true),
      home: Scaffold(
        appBar: AppBar(
          title: Text("Weather App", style: TextStyle(fontWeight: FontWeight.bold),),
          centerTitle: true,
          actions: [
            IconButton(onPressed: (){
              //print(("refresh"));
              setState(() {
                
              });
            },
            icon: Icon(Icons.refresh)),
          ],
        ),


        body: FutureBuilder(
          future: getcurrentweather(),
          builder:(context,snapshot) {

            if(snapshot.connectionState==ConnectionState.waiting){
              return Center(child: CircularProgressIndicator.adaptive());
            }
            if(snapshot.hasError){
              return Center(child: Text(snapshot.error.toString()));
            }

            final data = snapshot.data!;
            
            final temperature = (data['list'][0]['main']['temp']).toDouble();
            final celcius = (temperature - 273.15).round();
            final humidity = data['list'][0]['main']['humidity'] as int;
            final pressure = data['list'][0]['main']['pressure'] as int;
            final windSpeed = (data['list'][0]['wind']['speed']) as double;
            final sky = data['list'][0]['weather'][0]['main'];

            return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [

                //drop down menu for selecting the city
                DropdownButton<String>(
                  value: selectedCity,
                  icon: const Icon(Icons.arrow_drop_down),
                  dropdownColor: Colors.grey[900],
                  elevation: 16,
                  style: const TextStyle(color: Colors.white, fontSize: 18),
                  underline: Container(height: 2, color: Colors.deepPurpleAccent),
                  items: cities.map((String city) {
                    return DropdownMenuItem<String>(
                      value: city,
                      child: Text(city),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedCity = newValue!;
                    });
                  },
                  menuMaxHeight: 200,
                ),

          
                //main weather card
                //const Placeholder(fallbackHeight: 250,),
                SizedBox(
                  width: double.infinity,
                  child: Card(
                    elevation: 10,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    child: ClipRRect(
                      borderRadius:  BorderRadius.circular(16),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10,sigmaY: 10),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            children: [
                              Text("$celcius°C",style: 
                                TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 32,
                                ),
                              ),
                              Icon(
                                sky == 'Rain' ? WeatherIcons.rain : (sky == 'Clouds' ? WeatherIcons.cloud : WeatherIcons.day_sunny),
                                size: 70,),
                                SizedBox(height: 20,),
                              Text(sky,
                                style:
                                  TextStyle(
                                    fontSize: 25,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
            
                //Hourly weather forecast cards
                //const SizedBox(height: 20,),
                Align(
                  alignment: Alignment.centerLeft,
                  child: const Text("Weather Forecast", 
                    style: 
                    TextStyle(
                      fontWeight: FontWeight.bold,fontSize: 25
                    ),
                  ),
                ),
                
                //hourly weather cards
                SizedBox(
                  height: 130,
                  child: ListView.builder(
                    itemCount: 5,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index){
                      final time = DateTime.parse(data['list'][index]['dt_txt']);
                      return weathercard(
                        //data['list'][index]['dt'].toString(),
                        DateFormat.j().format(time),
                        data['list'][index]['weather'][0]['main'] == 'Rain'
                        ? WeatherIcons.rain  // Rain icon from weather_icons
                        : (data['list'][index]['weather'][0]['main'] == 'Clouds'
                        ? WeatherIcons.cloud  // Cloud icon
                        : WeatherIcons.day_sunny),
                        (data['list'][index]['main']['temp']-273.15).round());
                    }
                  ),
                ),
                
                //additional info on weather
                //const SizedBox(height: 20,),
                Align(
                  alignment: Alignment.centerLeft,
                  child: const Text("Additional Information", 
                    style: 
                    TextStyle(
                      fontWeight: FontWeight.bold,fontSize: 25
                    ),
                  ),
                ),
                //const SizedBox(height: 10,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    additionalinfo(Icons.water_drop, "Humidity",humidity,"%"),
                    additionalinfo(Icons.air, "Wind Speed",windSpeed.toInt(),"KMPH"),
                    additionalinfo(Icons.beach_access, "Pressure",pressure,""),
                  ],
                ),
          
              ],
            ),
          );
          },
        )


      ),
    );
    
  }

  //widget for the weather forecast cards
  Widget weathercard(String time,IconData icon, int temp){
      return Card(
        elevation: 6,
        child: Container(
          width: 100,
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            children: [
              Text(time,style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),maxLines: 1, overflow: TextOverflow.ellipsis,),
              const SizedBox(height: 8,),
              Icon(icon, size: 30,),
              const SizedBox(height: 8,),
              Text(temp.toString(),style: TextStyle(fontSize: 16),),
            ],
          ),
        ),
      );
    }

    //widget for additional informations
    Widget additionalinfo(IconData icon, String info, int data, String notation){
      return Card(
        //elevation: 6,
        child: Container(
          width: 118,
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            children: [
              Icon(icon, size: 60,),
              const SizedBox(height: 8,),
              Text(info,style: TextStyle(fontSize: 18)),
              const SizedBox(height: 8,),
              Text(data.toString()+" "+notation, style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
            ],
          ),
        ),
      );
    }
}
