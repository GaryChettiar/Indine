import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';


class SelectDeliveryLocationScreen extends StatefulWidget {
  @override
  State<SelectDeliveryLocationScreen> createState() => _SelectDeliveryLocationScreenState();
}

class _SelectDeliveryLocationScreenState extends State<SelectDeliveryLocationScreen> {
  Position? _currentLocation;

  late bool servicePermisssion= false;

  late LocationPermission permission;

  String currentAddress="";

  Future<Position> _getCurrentLocation() async{
    servicePermisssion = await Geolocator.isLocationServiceEnabled();
    if(!servicePermisssion){
      print("service disabled");
    }
    permission= await Geolocator.checkPermission();
      if(permission==LocationPermission.denied){
        permission= await Geolocator.requestPermission();
      }
    return await Geolocator.getCurrentPosition();
  }

  _getAddressFromCoordinates() async{
    try {
      List<Placemark> placemarks= await placemarkFromCoordinates(_currentLocation!.latitude, _currentLocation!.longitude);
      Placemark place=placemarks[0];
       setState(() {
         currentAddress = "${place.locality},${place.country}";
       });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back,color: Colors.black,),
          onPressed: () {
            Navigator.pop(context);
          
            // Add functionality to handle back navigation if needed
          },
        ),
        title: Text('Select delivery location',style: TextStyle(color: Colors.black),),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton.icon(
              onPressed: () async{
                  _currentLocation = await  _getCurrentLocation();
                  print("${_currentLocation}");
                  await _getAddressFromCoordinates();
                  print("${currentAddress}");
                  Navigator.pop(context,currentAddress);
                // Add functionality to use current location
              },
              icon: Icon(Icons.my_location),
              label: Text('Use current location'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey,
                padding: EdgeInsets.symmetric(vertical: 16.0),
                minimumSize: Size(double.infinity, 48),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: Row(
                children: [
                  Expanded(
                    child: Divider(
                      thickness: 1,
                      color: Colors.grey,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      'OR',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                  Expanded(
                    child: Divider(
                      thickness: 1,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            TextField(
              decoration: InputDecoration(
                hintText: 'Search',
                contentPadding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                filled: true,
                fillColor: Colors.grey[200],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
