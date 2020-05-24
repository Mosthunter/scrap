import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:scrap/widget/Loading.dart';
import 'package:scrap/widget/ScreenUtil.dart';
import 'package:scrap/function/toDatabase/scrap.dart';

class SelectPosition extends StatefulWidget {
  final LatLng defaultLatLng;
  SelectPosition({@required this.defaultLatLng});
  @override
  _SelectPositionState createState() => _SelectPositionState();
}

class _SelectPositionState extends State<SelectPosition> {
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  LatLng location, scrapLocation;
  GoogleMapController controller;
  BitmapDescriptor scrapIcon, _curIcon;
  GoogleMapController mapController;
  StreamSubscription loadStream;
  bool loading = false;

  @override
  void initState() {
    loadStream =
        scrap.loading.listen((value) => setState(() => loading = value));
    initLocation();
    super.initState();
  }

  void initLocation() {
    location = widget.defaultLatLng;
    scrapLocation = LatLng(
        widget.defaultLatLng.latitude, widget.defaultLatLng.longitude + 0.0001);
  }

  @override
  void dispose() {
    loadStream.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    screenutilInit(context);
    _createScrapImageFromAsset(context);
    _createMarkerImageFromAsset(context);
    return Scaffold(
      backgroundColor: Colors.grey[900],
      body: Stack(
        children: <Widget>[
          GoogleMap(
            myLocationButtonEnabled: false,
            myLocationEnabled: false,
            onMapCreated: onMapCreated,
            initialCameraPosition: CameraPosition(target: location, zoom: 18.5),
            markers: Set<Marker>.of(markers.values),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              alignment: Alignment.center,
              margin: EdgeInsets.only(
                  top: screenWidthDp / 12,
                  left: screenWidthDp / 24,
                  right: screenWidthDp / 24),
              height: screenHeightDp / 12,
              decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(screenWidthDp / 54),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black26,
                        blurRadius: 6.0,
                        spreadRadius: 3.0,
                        offset: Offset(0.0, 3.2))
                  ]),
              child: Text(
                'แตะค้างที่ "แสครป" ของคุณเพื่อเลือกตำแน่ง',
                textAlign: TextAlign.center,
                style: TextStyle(
                    wordSpacing: 0.1, fontSize: s46, color: Colors.white),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Row(
              children: <Widget>[
                Expanded(
                  child: GestureDetector(
                    child: Container(
                      padding: EdgeInsets.all(screenWidthDp / 42),
                      decoration: BoxDecoration(boxShadow: [
                        BoxShadow(
                            color: Colors.black26,
                            blurRadius: 6.0,
                            spreadRadius: 3.0,
                            offset: Offset(0.0, 3.2))
                      ], color: Colors.black),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(Icons.close, color: Colors.white, size: s48),
                          Text(
                            'ยกเลิก',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                wordSpacing: 0.1,
                                fontSize: s54,
                                color: Colors.white),
                          )
                        ],
                      ),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    child: Container(
                      padding: EdgeInsets.all(screenWidthDp / 42),
                      decoration: BoxDecoration(boxShadow: [
                        BoxShadow(
                            color: Colors.black26,
                            blurRadius: 6.0,
                            spreadRadius: 3.0,
                            offset: Offset(0.0, 3.2))
                      ], color: Color(0xff0099FF)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(Icons.check, color: Colors.white, size: s48),
                          Text(
                            'ตรงนี้แหละ',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                wordSpacing: 0.1,
                                fontSize: s54,
                                color: Colors.white),
                          )
                        ],
                      ),
                    ),
                    onTap: () {
                      scrap.binScrap(context,
                          location: scrapLocation, defaultLocation: location);
                    },
                  ),
                ),
              ],
            ),
          ),
          loading ? Loading() : SizedBox()
        ],
      ),
    );
  }

  void onMapCreated(GoogleMapController googleController) {
    this.mapController = googleController;
    changeMapMode();
    initScrapMarker();
    userMarker();
  }

  initScrapMarker() {
    MarkerId markerId = MarkerId('scrap');
    Marker marker = Marker(
        markerId: markerId,
        position: scrapLocation,
        icon: scrapIcon,
        draggable: true,
        onDragEnd: (position) {
          scrapLocation = position;
        });
    setState(() => markers[markerId] = marker);
  }

  userMarker() {
    MarkerId markerId = MarkerId('user');
    LatLng position = location;
    Marker marker = Marker(
      markerId: markerId,
      position: position,
      icon: _curIcon,
      draggable: false,
    );
    setState(() => markers[markerId] = marker);
  }

  Future<void> _createMarkerImageFromAsset(BuildContext context) async {
    final ImageConfiguration imageConfiguration =
        createLocalImageConfiguration(context);
    BitmapDescriptor.fromAssetImage(
            imageConfiguration, 'assets/yourlocation-icon-l.png')
        .then(_updateBitmap);
  }

  Future<void> _createScrapImageFromAsset(BuildContext context) async {
    final ImageConfiguration imageConfiguration =
        createLocalImageConfiguration(context);
    BitmapDescriptor.fromAssetImage(
            imageConfiguration, 'assets/paper-mini01.png')
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

  void _updateBitmap(BitmapDescriptor bitmap) {
    setState(() => _curIcon = bitmap);
  }

  void _updateBitScrap(BitmapDescriptor bitmap) {
    setState(() => scrapIcon = bitmap);
  }
}
