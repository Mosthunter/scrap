import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:scrap/widget/ScreenUtil.dart';

class MapSheet extends StatefulWidget {
  final LatLng position;
  MapSheet({@required this.position});
  @override
  _MapSheetState createState() => _MapSheetState();
}

class _MapSheetState extends State<MapSheet> {
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  BitmapDescriptor scrapIcon;
  GoogleMapController mapController;
  @override
  Widget build(BuildContext context) {
    screenutilInit(context);
    _createScrapImageFromAsset(context);
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Align(
        alignment: Alignment.bottomCenter,
        child: Container(
            decoration: BoxDecoration(
                color: Color(0xff282828),
                borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
            width: screenWidthDp,
            height: screenHeightDp / 1.8,
            child: Stack(
              children: <Widget>[
                ClipRRect(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                  child: GoogleMap(
                    myLocationButtonEnabled: false,
                    myLocationEnabled: false,
                    onMapCreated: onMapCreated,
                    initialCameraPosition:
                        CameraPosition(target: widget.position, zoom: 18.5),
                    markers: Set<Marker>.of(markers.values),
                  ),
                ),
                Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                    margin: EdgeInsets.only(top: 12, bottom: 4),
                    width: screenWidthDp / 3.2,
                    height: screenHeightDp / 81,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(screenHeightDp / 42),
                      color: Color(0xff929292),
                    ),
                  ),
                )
              ],
            )),
      ),
    );
  }

//locationmarker.png
  Future<void> _createScrapImageFromAsset(BuildContext context) async {
    final ImageConfiguration imageConfiguration =
        createLocalImageConfiguration(context);
    BitmapDescriptor.fromAssetImage(
            imageConfiguration, 'assets/locationmarker.png')
        .then(_updateBitScrap);
  }

  changeMapMode() {
    getJsonFile("assets/mapStyle.json").then(setMapStyle);
  }

  Future<String> getJsonFile(String path) async {
    return await rootBundle.loadString(path);
  }

  void setMapStyle(String mapStyle) {
    this.mapController.setMapStyle(mapStyle);
  }

  void _updateBitScrap(BitmapDescriptor bitmap) {
    setState(() {
      scrapIcon = bitmap;
    });
  }

  void writerMarker() {
    MarkerId markerId = MarkerId('user');
    LatLng position = widget.position;
    Marker marker = Marker(
      markerId: markerId,
      position: position,
      icon: scrapIcon,
      draggable: false,
    );
    if (this.mounted) {
      setState(() {
        markers[markerId] = marker;
      });
    }
  }

  void onMapCreated(GoogleMapController mapController) {
    this.mapController = mapController;
    changeMapMode();
    writerMarker();
  }
}
