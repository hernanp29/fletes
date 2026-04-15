import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() => runApp(MaterialApp(home: FletesPilarApp()));

class FletesPilarApp extends StatefulWidget {
  @override
  _FletesPilarAppState createState() => __FletesPilarAppState();
}

class _FletesPilarAppState extends State<FletesPilarApp> {
  String _status = "Listo para trackear";

  Future<void> _enviarUbicacion() async {
    setState(() => _status = "Obteniendo GPS...");
    
    try {
      // 1. Pedir permisos
      LocationPermission permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return;

      // 2. Obtener posición
      Position pos = await Geolocator.getCurrentPosition();

      // 3. ENVIAR A RAILWAY (Cambiá esto por tu URL real)
      final url = Uri.parse('https://fletes.up.railway.app/update-location');
      
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "driver_id": 1,
          "lat": pos.latitude,
          "lng": pos.longitude
        }),
      );

      if (response.statusCode == 200) {
        setState(() => _status = "¡Ubicación enviada a Railway!");
      } else {
        setState(() => _status = "Error del servidor: ${response.statusCode}");
      }
    } catch (e) {
      setState(() => _status = "Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Fletes Pilar - Chofer")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_status, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _enviarUbicacion,
              child: Text("MANDAR MI UBICACIÓN", style: TextStyle(fontSize: 20)),
              style: ElevatedButton.styleFrom(padding: EdgeInsets.all(20)),
            ),
          ],
        ),
      ),
    );
  }
}
