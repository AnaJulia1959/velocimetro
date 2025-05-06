import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:provider/provider.dart';
import '../viewmodels/location_viewmodel.dart';


class LocationView extends StatelessWidget {
  const LocationView({super.key});

  String _format(double value) => value.toStringAsFixed(2);
  String _formatDuration(Duration d) =>
      "${d.inMinutes.toString().padLeft(2, '0')}:${(d.inSeconds % 60).toString().padLeft(2, '0')}";

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<LocationViewModel>();
    final loc = vm.current;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Velocímetro e Hodômetro'),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: loc == null
            ? const CircularProgressIndicator()
            : Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Velocidade Atual',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '${_format(loc.speed)} km/h',
                      style: const TextStyle(fontSize: 32, color: Colors.red),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Distância Percorrida',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '${_format(vm.totalDistance)} km',
                      style: const TextStyle(fontSize: 28),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Velocidade Média',
                      style: TextStyle(fontSize: 18),
                    ),
                    Text('${_format(vm.averageSpeed)} km/h'),
                    const SizedBox(height: 20),
                    const Text(
                      'Tempo de Deslocamento',
                      style: TextStyle(fontSize: 18),
                    ),
                    Text(_formatDuration(vm.elapsedTime)),
                    const SizedBox(height: 30),
                    ElevatedButton.icon(
                      onPressed: () => vm.reset(),
                      icon: const Icon(Icons.refresh),
                      label: const Text('Resetar'),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
