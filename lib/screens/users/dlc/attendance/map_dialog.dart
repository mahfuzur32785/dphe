import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapDialog extends StatefulWidget {
  final double latitude;
  final double longitude;
  final String date;
   

  MapDialog({required this.latitude, required this.longitude, required this.date});

  @override
  _MapDialogState createState() => _MapDialogState();
}

class _MapDialogState extends State<MapDialog> {
  late GoogleMapController mapController;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        dialogBackgroundColor: Colors.white,
      ),
      child: AlertDialog(
        title: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text('Date : ${widget.date}'),
        ),
        actionsPadding: EdgeInsets.zero,
        contentPadding: EdgeInsets.zero,
        insetPadding: EdgeInsets.symmetric(horizontal: 18),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(20.0),
          ),
        ),
        backgroundColor: Colors.white,
        content: SizedBox(
          width: double.maxFinite,
          height: MediaQuery.of(context).size.height / 2,
          child: GoogleMap(
            initialCameraPosition: CameraPosition(
              target: LatLng(widget.latitude, widget.longitude),
              zoom: 15,
            ),
            onMapCreated: (GoogleMapController controller) {
              mapController = controller;
            },
            markers: {
              Marker(
                markerId: MarkerId('Location'),
                position: LatLng(widget.latitude, widget.longitude),
                infoWindow: InfoWindow(title: 'Location'),
              ),
            },
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Close'),
          ),
        ],
      ),
    );
  }
}
