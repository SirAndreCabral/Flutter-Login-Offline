import 'package:action_slider/action_slider.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class TelaSecundaria extends StatefulWidget {
  const TelaSecundaria({super.key});

  @override
  State<TelaSecundaria> createState() => _TelaSecundariaState();
}

class _TelaSecundariaState extends State<TelaSecundaria> {
  String _locationMessage = "Localização não disponivel";

  Future<void> _getLocation() async {
    bool serviceEnable;
    LocationPermission permission;

    //GPS ativo ou não
    serviceEnable = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnable) {
      setState(() {
        _locationMessage = "Serviço de localização desativado";
      });
      return;
    }

    //Permissão habilitada ou não
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        setState(() {
          _locationMessage = "Permissão negada";
        });
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      setState(() {
        _locationMessage = "Permissão negada permanentemente. Vá para as configurações do app.";
      });
      await Geolocator.openAppSettings();
      return;
    }

    //Pegar a localização atual
    try {
      Position position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );
      setState(() {
        _locationMessage = "Latitude: ${position.latitude}, Longitude: ${position.longitude}";
      });
    } catch (e) {
      setState(() {
        _locationMessage = "Erro ao obter localização: $e";
      });
    }

    print("====================================");
    print(_locationMessage);
    print("====================================");

  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ActionSlider.standard(
                  sliderBehavior: SliderBehavior.stretch,
                  width: MediaQuery.of(context).size.width * 0.9,
                  backgroundColor: Colors.white,
                  toggleColor: Colors.lightGreenAccent,
                  action: (controller) async {
                    controller.loading();
                    await _getLocation();
                    controller.success();
                    await Future.delayed(const Duration(seconds: 0));
                    controller.reset();
                  },
                  child: const Text('Deslize para confirmar',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                      decoration: TextDecoration.none
                    ),
                  ),
                ),
                const SizedBox(height: 20,),
                Text(
                  _locationMessage,
                  style: const TextStyle(fontSize: 14, color: Colors.black, decoration: TextDecoration.none),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
