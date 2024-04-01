import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:info_clima/component/weatherModal.dart';
import 'package:info_clima/model/weatherInfo.dart';

class ListOfState extends StatefulWidget {
  @override
  _ListOfStateState createState() => _ListOfStateState();
}

class _ListOfStateState extends State<ListOfState> {
  List<dynamic> states = [];
  List<dynamic> filteredStates = [];
  TextEditingController filterController = TextEditingController();

  Future<void> fetchStates() async {
    print(
        '---------------------CHAMEI A LISTA DE ESTADOS-----------------------------');

    final response = await http.get(Uri.parse(
        'https://servicodados.ibge.gov.br/api/v1/localidades/estados'));

    if (response.statusCode == 200) {
      setState(() {
        states = jsonDecode(response.body);
        filteredStates =
            states; // Inicialmente, a lista filtrada é igual à lista de estados completa
      });
    } else {
      throw Exception('Failed to load states');
    }
  }

  Future<WeatherInfo> fetchWeatherInfo(
      String cityName, String region, String country) async {
    final response = await http.get(Uri.parse(
        'http://api.weatherapi.com/v1/current.json?key=01f3a9306ad140ae9e3190231240302&q=$cityName, $region $country'));

    if (response.statusCode == 200) {
      final weatherData = jsonDecode(response.body);
      return WeatherInfo(
        location: weatherData['location']['name'],
        region: weatherData['location']['region'],
        country: weatherData['location']['country'],
        tempC: weatherData['current']['temp_c'],
        conditionText: weatherData['current']['condition']['text'],
        conditionIcon: weatherData['current']['condition']['icon'],
        windMph: weatherData['current']['wind_mph'],
        pressureMb: weatherData['current']['pressure_mb'],
        humidity: weatherData['current']['humidity'],
        cloud: weatherData['current']['cloud'],
        feelslikeC: weatherData['current']['feelslike_c'],
        visKm: weatherData['current']['vis_km'],
        uv: weatherData['current']['uv'],
      );
    } else {
      throw Exception('Failed to load weather info');
    }
  }

  void filterStates(String query) {
    List<dynamic> filteredList = states.where((state) {
      String stateName = state['nome'].toString().toLowerCase();
      return stateName.contains(query.toLowerCase());
    }).toList();

    setState(() {
      filteredStates = filteredList;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchStates();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: const Color.fromARGB(255, 6, 17, 51),
        title: const Center(
          child: Text(
            'Lista de Estados',
            style: TextStyle(color: Colors.white),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                filterStates(filterController.text);
              },
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: filterController,
              decoration: InputDecoration(
                hintText: 'Filtrar por estado...',
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(Icons.clear),
                  onPressed: () {
                    filterController.clear();
                    filterStates('');
                  },
                ),
              ),
              onChanged: (value) {
                filterStates(value);
              },
            ),
          ),
          Expanded(
            child: filteredStates.isEmpty
                ? Center(
                    child: Text('Nenhum estado encontrado'),
                  )
                : ListView.builder(
                    itemCount: filteredStates.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () async {
                          WeatherInfo weatherInfo = await fetchWeatherInfo(
                            filteredStates[index]['nome'],
                            filteredStates[index]['regiao']['nome'],
                            'Brazil',
                          );
                          // ignore: use_build_context_synchronously
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return SimpleDialog(
                                contentPadding: EdgeInsets
                                    .zero, // Remove o espaçamento interno do SimpleDialog
                                children: [
                                  WeatherModal(weatherInfo: weatherInfo),
                                ],
                              );
                            },
                          );
                        },
                        child: Card(
                          elevation: 3,
                          margin: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 16),
                          color: Color.fromARGB(255, 6, 17, 51),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Color.fromARGB(255, 6, 17, 51),
                              child: Text(
                                filteredStates[index]['sigla'],
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                            title: Row(
                              children: [
                                Text(
                                  filteredStates[index]['nome'],
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(width: 8),
                                Icon(Icons.wb_sunny, color: Colors.orange),
                              ],
                            ),
                            subtitle: Text(
                              filteredStates[index]['regiao']['nome'],
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
