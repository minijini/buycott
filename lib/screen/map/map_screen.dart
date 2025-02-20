import 'dart:async';
import 'dart:io';
import 'dart:ui' as ui;
import 'package:auto_size_text/auto_size_text.dart';
import 'package:buycott/constants/screen_size.dart';
import 'package:buycott/data/store_model.dart';
import 'package:buycott/firebase/firebaseservice.dart';
import 'package:buycott/states/store_notifier.dart';
import 'package:buycott/utils/color/basic_color.dart';
import 'package:buycott/utils/log_util.dart';
import 'package:buycott/widgets/dialog/custom_dialog.dart';
import 'package:flutter/material.dart' hide ModalBottomSheetRoute;
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:store_redirect/store_redirect.dart';

import '../../constants/basic_text.dart';
import '../../constants/constants.dart';
import '../../constants/padding_size.dart';
import '../../data/category_map.dart';
import '../../states/user_notifier.dart';
import '../../widgets/circle_progressbar.dart';
import '../../widgets/style/container.dart';
import 'bottom_sheet_screen.dart';
import 'package:open_app_settings/open_app_settings.dart';


class MapScreen extends StatefulWidget {
  final StoreNotifier storeNotifier;
  const MapScreen({super.key, required this.storeNotifier});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> with TickerProviderStateMixin{
  final TAG = "MapScreen";

  Location location = Location();
  bool location_permission = false;

  final TextEditingController _searchTextController = TextEditingController();

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

  StoreModel? _storeModel;

  String? shopTitle;

  String? categorySelectData;
  String? categoryClickData;

  bool isAppversionCheck = true;

  String? apptype;

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

    _appVersionCheck();

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

    // setCustomMapPin();

    _currentLocation();

    _kMapMarker = LatLng(37.898989, 129.362536);

    _kGooglePosition = CameraPosition(
      target:  _kMapMarker,
      zoom: 17,
    );
    checkLocationPermission();
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _searchTextController.dispose();
    super.dispose();
  }



  void _appVersionCheck() async{ //appversion + pushtoken등록

    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String deviceAppversion = packageInfo.version;

    Log.logs(TAG, "deviceAppversion :: $deviceAppversion");


    if (Platform.isAndroid) {
      apptype = "A";
    } else if (Platform.isIOS) {
      apptype = "I";
    }

    final _result =  await Provider.of<UserNotifier>(context,listen: false).appversion(context,  apptype!);
    final _updateYn = _result!.forceYn;
    String? _appversion = _result.appVersion;

    Log.logs(TAG, "_appversion :: $_appversion");


    if(_updateYn == 'Y'){
      CustomDialog(funcAction: appUpdate).normalDialog(context, '필수 업데이트를 진행해주세요', '확인');
      setState(() {
        appUpdateYn = true;
        isAppversionCheck = false;
      });

    }else{
      if(_appversion != null) {
        if (_appversion.compareTo(deviceAppversion) != 0) {
          CustomDialog(funcAction: appUpdate).actionDialog(context, '업데이트를 진행해주세요', '아니오', '확인');
        }

        setState(() {
          isAppversionCheck = false;
        });

      }
    }
  }

  //TODO:APPUpdate 정보입력
  void appUpdate(BuildContext context){
    StoreRedirect.redirect(androidAppId: 'com.minijini.buycott', iOSAppId:'');
  }


  Future<void> checkLocationPermission() async {
    bool serviceEnabled;
    PermissionStatus permissionGranted;


    // Check if location services are enabled
    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        // Handle when location services are still not enabled
        return;
      }
    }

    // Check location permission
    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      // Request location permission
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        // Handle when location permission is denied
        // showLocationPermissionDeniedDialog();
      }

      if(permissionGranted == PermissionStatus.granted){
        setState(() {
          location_permission = true;
        });

      }
    }else  if(permissionGranted == PermissionStatus.granted){
      setState(() {
        location_permission = true;
      });

    }
  }

  void showLocationPermissionDeniedDialog() {
    CustomDialog(funcAction: location_RecommdFunc)
        .actionDialog(
        context, "위치 권한을 허용해주세요.", '아니오', '예',
       );
  }

  void location_RecommdFunc(BuildContext context){
    OpenAppSettings.openAppSettings();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    checkLocationPermission();

    return SafeArea(
      child: Scaffold(
        // appBar: AppBar(
        //   title: Padding(
        //     padding: const EdgeInsets.only(left: sized_18),
        //     child: Text(
        //       "내 위치",
        //       style: Theme.of(context).textTheme.titleLarge,
        //     ),
        //   ),
        // ),
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
              // 지도가 생성되었을 때 처리

              _controller.complete(controller);
              _mapController = controller;
            },
            onCameraIdle: (){// 카메라 이동이 멈춘 경우
              // _getStores(longitude!,latitude!);
            },
            onCameraMove: (object) => { //카메라 이동 시 좌표가져오기

              setState(() {

                latitude = object.target.latitude;
                longitude = object.target.longitude;
              })
            },

            padding: EdgeInsets.only(
              top: MediaQuery.of(context).size.height*0.45,
                bottom:MediaQuery.of(context).size.height*0.15),
          ),
        ) : Container(color:Colors.white,child: CustomCircularProgress()),
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: sized_20,bottom:sized_10,left: sized_18,right: sized_18),
                  child: _placeSearchBar(),
                ),

                _category(),
                heightSizeBox(sized_15),
                GestureDetector(
                  onTap: () {
                    _getStores(longitude!,latitude!);
                  },
                  child: Container(
                    width: 150,
                    height: sized_30,
                    decoration: appBarDecor(Colors.white),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(Icons.refresh),
                        widthSizeBox(sized_5),
                        AutoSizeText('현 지도에서 다시 검색',
                            style: Theme.of(context)
                                .textTheme
                                .displaySmall!
                        ),
                      ],
                    ),

                  ),
                )
              ],
            ),

            SlideTransition(
              position: _offsetAnimation,
              child: Visibility(
                visible: isVisible,
                child: ShopBottomSheet(storeModel: _storeModel),
                // child: ShopBottomSheet(title: "df",),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _placeSearchBar() {
    return TextField(
        onTap: (){
          context.goNamed(
            searchRouteName,
          );
        },
        readOnly: true,
        style: Theme.of(context).textTheme.displayMedium!.copyWith(fontWeight: FontWeight.w500,color: BasicColor.lightgrey2),
      controller: _searchTextController,
      keyboardType: TextInputType.text,
      cursorColor: BasicColor.primary,
      decoration:  InputDecoration(
          hintText: "장소를 입력하세요",
          suffixIcon: Padding(
              padding: EdgeInsets.symmetric(vertical: sized_8,horizontal: sized_12),
              child: Image.asset("assets/icon/icon_search.png",scale:30,fit: BoxFit.fill,)))
    );
  }

  Widget _category(){
    return Container(
      height: sized_30,
      margin: EdgeInsets.symmetric(horizontal: padding_side),
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: placeTypeMap.entries
            .map(
              (data) => GestureDetector(
                onTap: (){
                  setState(() {
                    categoryClickData = data.key;
                  });

                  if(categorySelectData == categoryClickData){
                    setState(() {
                      categorySelectData = null;
                    });
                  }else{
                    setState(() {
                      categorySelectData = data.key;
                    });
                  }

                  _getStores(longitude!,latitude!);
                },
                child: Container(
                  margin: EdgeInsets.only(right: sized_10),
                  padding: EdgeInsets.symmetric(vertical: sized_5,horizontal: sized_10),
                  height: sized_30,
                  decoration: categoryDecor(  categorySelectData == data.key ? BasicColor.primary2 : BasicColor.primary),
                  constraints: BoxConstraints(
                    minWidth: 52, // Set the minimum width
                    minHeight: sized_30
                  ),
                  child: Center(child: AutoSizeText(data.value,style: Theme.of(context).textTheme.bodySmall!.copyWith(color: categorySelectData == data.key ? Colors.white : Colors.black),)),
                ),
              ),
        )
            .toList(),
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
        zoom: 15.0,
      ),
    ));

    _getStores(longitude!,latitude!);

    Log.logs(TAG,
        "lat : ${currentLocation.latitude!}, lng: ${currentLocation.longitude!}");
  }


  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(), targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!.buffer.asUint8List();
  }

 void _createMarker() async{

   setState(() {
     _marker.clear();
   });

   final List<Marker> _list =  [];

   for (var storeModel in widget.storeNotifier.storeList)  {

     if(storeModel.storeType == "CE7" || storeModel.storeType == "FD6") {
       _markerIcon = await getBytesFromAsset(
           'assets/icon/icon_marker_${storeModel.storeType}.png', 80);
     }else{
       _markerIcon = await getBytesFromAsset(
           'assets/icon/icon_marker_etc.png', 80);
     }

     Marker marker = Marker(
         markerId: MarkerId("${storeModel.storeSrno}"),
       position: LatLng(storeModel.storeLoc!.y!, storeModel.storeLoc!.x!),
       icon: _markerIcon!= null ? BitmapDescriptor.fromBytes(_markerIcon!) : BitmapDescriptor.defaultMarker,
         // infoWindow: InfoWindow(
         //   title: storeModel.storeName ,
         // ),
         onTap: (){
           setState(() {
             _storeModel = storeModel;
           });

           _getStoreDetail();

           // _mapController?.animateCamera(
           //   CameraUpdate.newLatLng(LatLng(storeModel.storeLoc!.y!, storeModel.storeLoc!.x!)),
           // );

           _mapController?.moveCamera( //lat : 가로, lng: 세로
             CameraUpdate.newLatLng(
               LatLng(storeModel.storeLoc!.y!-0.0005 ,storeModel.storeLoc!.x!),
             ),
           );
         }
     );

     _list.add(marker);
   }

   setState(() {
     _marker.addAll(_list);
   });
  }



  void _getStoreDetail() {
    Provider.of<StoreNotifier>(context, listen: false).storeDetail(_storeModel?.storeSrno ?? 0,userSrno);
  }

 void _getStores(double x, double y){
   if(categorySelectData != null){
     _storesNotifier(x, y, storeType: categorySelectData);
   }else{
     _storesNotifier(x, y);
   }
 }

 void _storesNotifier(double x, double y, {String? storeType}) {
   Provider.of<StoreNotifier>(context, listen: false).getStores(context, x,y,storeType: storeType).then((value){
     _createMarker();
   });
 }


}


