import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CustomIcon {
  String language;
  //singleton logic
  static final CustomIcon icon = CustomIcon._internal();

  BitmapDescriptor myLocationIcon;
  BitmapDescriptor repairIcon;
  BitmapDescriptor cleaningIcon;
  BitmapDescriptor buisnessIcon;
  BitmapDescriptor healthIcon;
  BitmapDescriptor weedingIcon;

  CustomIcon._internal();
  factory CustomIcon() {
    return icon;
  }

  void loadMyLocationIcon() {
    BitmapDescriptor.fromAssetImage(ImageConfiguration(size: Size(12, 12)),
            'assets/images/mylocation.png')
        .then((d) {
      myLocationIcon = d;
    });
  }

  void loadAllIcons() {
    //mylocation
    BitmapDescriptor.fromAssetImage(ImageConfiguration(size: Size(12, 12)),
            'assets/images/mylocation.png')
        .then((d) {
      myLocationIcon = d;
    });

    //cleaning
    BitmapDescriptor.fromAssetImage(ImageConfiguration(size: Size(12, 12)),
            'assets/icons/cleaning.png')
        .then((d) {
      cleaningIcon = d;
    });

    //repair
    BitmapDescriptor.fromAssetImage(ImageConfiguration(size: Size(12, 12)),
            'assets/icons/repair.png')
        .then((d) {
      repairIcon= d;
    });

    //health
    BitmapDescriptor.fromAssetImage(ImageConfiguration(size: Size(12, 12)),
            'assets/icons/health.png')
        .then((d) {
      healthIcon = d;
    });

    //weeding
    BitmapDescriptor.fromAssetImage(ImageConfiguration(size: Size(12, 12)),
            'assets/icons/weeding.png')
        .then((d) {
      weedingIcon = d;
    });
  }

  get getmyLocationIcon {
    return myLocationIcon;
  }

  get cleaning {
    return cleaningIcon;
  }

  get repair {
    return repairIcon;
  }

  get weeding {
    return weedingIcon;
  }

  get health {
    return healthIcon;
  }
}
