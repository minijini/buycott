import 'dart:async';
import 'dart:ui' as ui;
import 'package:buycott/constants/screen_size.dart';
import 'package:buycott/firebase/firebaseservice.dart';
import 'package:buycott/states/store_notifier.dart';
import 'package:buycott/utils/color/basic_color.dart';
import 'package:buycott/utils/log_util.dart';
import 'package:flutter/material.dart' hide ModalBottomSheetRoute;
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';

import '../../constants/padding_size.dart';
import '../../widgets/style/container.dart';
import 'bottom_sheet_screen.dart';

class MapScreen extends StatefulWidget {
  final StoreNotifier storeNotifier;
  const MapScreen({super.key, required this.storeNotifier});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> with TickerProviderStateMixin {
  final TAG = "MapScreen";
  bool isVisible = true;
  late AnimationController _animationController;
  late Animation<Offset> _offsetAnimation;

  Completer<GoogleMapController> _controller = Completer();
  GoogleMapController? _mapController;
  late CameraPosition _kGooglePosition;
  late LatLng _kMapMarker;
  Uint8List? _markerIcon;
  double? latitude ;
  double? longitude;
  List<Marker> _marker = [];

  String? shopTitle;

  @override
  void initState() {
    // setState(() {
    //   isVisible = !isVisible;
    //   if (isVisible) {
    //     _animationController.reverse();
    //   } else {
    //     _animationController.forward();
    //   }
    // });

    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );

    _offsetAnimation = Tween<Offset>(
      begin: Offset(0.0, -0.0), // Move up when becoming visible
      end: Offset(0.0, 1.0), // Move down when becoming invisible
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    setCustomMapPin();

    _currentLocation();

    _kMapMarker = LatLng(37.898989, 129.362536);

    _kGooglePosition = CameraPosition(
      target:  _kMapMarker,
      zoom: 17,
    );

    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          (latitude != null && longitude != null) ? Container(
          height: size!.height,
        child: GoogleMap(
          mapType: MapType.normal,
          myLocationEnabled: true,
          myLocationButtonEnabled: true,
          markers: Set<Marker>.of(_marker),
          initialCameraPosition: _kGooglePosition,
          onMapCreated: (GoogleMapController controller) {
            _controller.complete(controller);
            _mapController = controller;
          },
          onCameraIdle: (){// 카메라 이동이 멈춘 경우

            _getStores(longitude!,latitude!);
          },
          onCameraMove: (object) => { //카메라 이동 시 좌표가져오기
            setState(() {
              latitude = object.target.latitude;
              longitude = object.target.longitude;
            })
          },

          padding: EdgeInsets.only(
              bottom:MediaQuery.of(context).size.height*0.15),
        ),
      ) : Center(child: CircularProgressIndicator(color: BasicColor.primary,)),

          SlideTransition(
            position: _offsetAnimation,
            child: Visibility(
              visible: isVisible,
              child: ShopBottomSheet(title: shopTitle??"",),
            ),
          ),
        ],
      ),
    );
  }

  void _currentLocation() async {
    Location location = Location();
    final currentLocation = await location.getLocation();

    setState(() {
      latitude = currentLocation.latitude!;
      longitude = currentLocation.longitude!;

      _kMapMarker = LatLng(latitude!, longitude!);
    });

    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(
        target: _kMapMarker,
        zoom: 18.0,
      ),
    ));

    _getStores(longitude!,latitude!);


    Log.logs(TAG,
        "lat : ${currentLocation.latitude!}, lng: ${currentLocation.longitude!}");
  }

  void setCustomMapPin() async {
    _markerIcon = await getBytesFromAsset('assets/icon/icon_marker.png', 130);
  }

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(), targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!.buffer.asUint8List();
  }

 void _createMarker() {

   setState(() {
     _marker.clear();
   });

   final List<Marker> _list =  [];

   for (var storeModel in widget.storeNotifier.storeList) {
     Marker marker = Marker(
         markerId: MarkerId("${storeModel.storeSrno}"),
       position: LatLng(storeModel.storeLoc!.y!, storeModel.storeLoc!.x!),
       icon: _markerIcon!= null ? BitmapDescriptor.fromBytes(_markerIcon!) : BitmapDescriptor.defaultMarker,
         infoWindow: InfoWindow(
           title: storeModel.storeName ,
         ),
         onTap: (){
           _setTitle(storeModel.storeName ?? "");
         }
     );

     _list.add(marker);
   }

   setState(() {
     _marker.addAll(_list);
   });
  }

 void _setTitle(String title) {
   return setState(() {
          shopTitle = title;
        });
 }

 void _getStores(double x, double y){
   Provider.of<StoreNotifier>(context, listen: false).getStores(context, x,y).then((value){
     _createMarker();
   });
 }


}
