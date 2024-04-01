import 'package:flutter/material.dart';
import 'package:info_clima/model/weatherInfo.dart';

class WeatherModal extends StatelessWidget {
  final WeatherInfo weatherInfo;

  const WeatherModal({Key? key, required this.weatherInfo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        constraints:
            BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.6),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Localização: ${weatherInfo.location}, ${weatherInfo.region}, ${weatherInfo.country}',
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              const SizedBox(height: 12),
              Text('Temperatura: ${weatherInfo.tempC}°C'),
              const SizedBox(height: 8),
              Text('Condição: ${weatherInfo.conditionText}'),
              const SizedBox(height: 8),
              Image.network(
                'https:${weatherInfo.conditionIcon}',
                width: 64,
                height: 64,
              ),
              const SizedBox(height: 8),
              Text('Velocidade do vento: ${weatherInfo.windMph} mph'),
              const SizedBox(height: 8),
              Text('Pressão: ${weatherInfo.pressureMb} mb'),
              const SizedBox(height: 8),
              Text('Umidade: ${weatherInfo.humidity}%'),
              const SizedBox(height: 8),
              Text('Nuvens: ${weatherInfo.cloud}%'),
              const SizedBox(height: 8),
              Text('Sensação térmica: ${weatherInfo.feelslikeC}°C'),
              const SizedBox(height: 8),
              Text('Visibilidade: ${weatherInfo.visKm} km'),
              const SizedBox(height: 8),
              Text('Índice UV: ${weatherInfo.uv}'),
            ],
          ),
        ),
      ),
    );
  }
}
