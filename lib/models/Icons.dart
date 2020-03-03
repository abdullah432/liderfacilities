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
  BitmapDescriptor acIcon;
  BitmapDescriptor automobileIcon;
  BitmapDescriptor bikerIcon;
  BitmapDescriptor carIcon;
  BitmapDescriptor carwashIcon;
  BitmapDescriptor eldercareIcon;
  BitmapDescriptor electricalIcon;
  BitmapDescriptor faIcon;
  BitmapDescriptor foodIcon;
  BitmapDescriptor gardnerIcon;
  BitmapDescriptor maintanaceIcon;
  BitmapDescriptor hydraulicIcon;
  BitmapDescriptor kidpartyIcon;
  BitmapDescriptor locksmithIcon;
  BitmapDescriptor manicureIcon;
  BitmapDescriptor massageIcon;
  BitmapDescriptor musicIcon;
  BitmapDescriptor personaltrainerIcon;
  BitmapDescriptor petIcon;
  BitmapDescriptor photographerIcon;
  BitmapDescriptor reformIcon;
  BitmapDescriptor taIcon;
  //selected icon
  // BitmapDescriptor acsIcon;
  // BitmapDescriptor automobilesIcon;
  // BitmapDescriptor bikersIcon;
  // BitmapDescriptor carsIcon;
  // BitmapDescriptor carwashsIcon;
  // BitmapDescriptor eldercaresIcon;
  // BitmapDescriptor electricalsIcon;
  // BitmapDescriptor fasIcon;
  // BitmapDescriptor foodsIcon;
  // BitmapDescriptor gardnersIcon;
  // BitmapDescriptor maintanacesIcon;
  // BitmapDescriptor hydraulicsIcon;
  // BitmapDescriptor kidpartysIcon;
  // BitmapDescriptor locksmithsIcon;
  // BitmapDescriptor manicuresIcon;
  // BitmapDescriptor massagesIcon;
  // BitmapDescriptor musicsIcon;
  // BitmapDescriptor personaltrainersIcon;
  // BitmapDescriptor petsIcon;
  // BitmapDescriptor photographersIcon;
  // BitmapDescriptor reformsIcon;
  // BitmapDescriptor tasIcon;

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

  void loadAllIcons() async{
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

    //ac
    BitmapDescriptor.fromAssetImage(ImageConfiguration(size: Size(12, 12)),
            'assets/icons/ac.png')
        .then((d) {
      acIcon = d;
    });

    //automobiles
    BitmapDescriptor.fromAssetImage(ImageConfiguration(size: Size(12, 12)),
            'assets/icons/automobiles.png')
        .then((d) {
      automobileIcon = d;
    });

    //biker
    BitmapDescriptor.fromAssetImage(ImageConfiguration(size: Size(12, 12)),
            'assets/icons/biker.png')
        .then((d) {
      bikerIcon = d;
    });

    //car
    BitmapDescriptor.fromAssetImage(ImageConfiguration(size: Size(12, 12)),
            'assets/icons/car.png')
        .then((d) {
      carIcon = d;
    });

    //carwash
    BitmapDescriptor.fromAssetImage(ImageConfiguration(size: Size(12, 12)),
            'assets/icons/carwash.png')
        .then((d) {
      carwashIcon = d;
    });

    //eldercare
    BitmapDescriptor.fromAssetImage(ImageConfiguration(size: Size(12, 12)),
            'assets/icons/eldercare.png')
        .then((d) {
      eldercareIcon = d;
    });

    //electrical
    BitmapDescriptor.fromAssetImage(ImageConfiguration(size: Size(12, 12)),
            'assets/icons/electrical.png')
        .then((d) {
      electricalIcon = d;
    });

    //furniture assembly
    BitmapDescriptor.fromAssetImage(ImageConfiguration(size: Size(12, 12)),
            'assets/icons/fa.png')
        .then((d) {
      faIcon = d;
    });

    //food
    BitmapDescriptor.fromAssetImage(ImageConfiguration(size: Size(12, 12)),
            'assets/icons/food.png')
        .then((d) {
      foodIcon = d;
    });

    //gardner
    BitmapDescriptor.fromAssetImage(ImageConfiguration(size: Size(12, 12)),
            'assets/icons/gardner.png')
        .then((d) {
      gardnerIcon = d;
    });

    //hydraulic
    BitmapDescriptor.fromAssetImage(ImageConfiguration(size: Size(12, 12)),
            'assets/icons/hydraulic.png')
        .then((d) {
      hydraulicIcon = d;
    });

    //kidparty
    BitmapDescriptor.fromAssetImage(ImageConfiguration(size: Size(12, 12)),
            'assets/icons/kidparty.png')
        .then((d) {
      kidpartyIcon = d;
    });

    //locksmith
    BitmapDescriptor.fromAssetImage(ImageConfiguration(size: Size(12, 12)),
            'assets/icons/locksmith.png')
        .then((d) {
      locksmithIcon = d;
    });

    //locksmith
    BitmapDescriptor.fromAssetImage(ImageConfiguration(size: Size(12, 12)),
            'assets/icons/maintanance.png')
        .then((d) {
      maintanaceIcon = d;
    });

    //manicure
    BitmapDescriptor.fromAssetImage(ImageConfiguration(size: Size(12, 12)),
            'assets/icons/manicure.png')
        .then((d) {
      manicureIcon = d;
    });

    //massage
    BitmapDescriptor.fromAssetImage(ImageConfiguration(size: Size(12, 12)),
            'assets/icons/massage.png')
        .then((d) {
      massageIcon = d;
    });

    //music
    BitmapDescriptor.fromAssetImage(ImageConfiguration(size: Size(12, 12)),
            'assets/icons/music.png')
        .then((d) {
      musicIcon = d;
    });

    //personaltrainer
    BitmapDescriptor.fromAssetImage(ImageConfiguration(size: Size(12, 12)),
            'assets/icons/personaltrainer.png')
        .then((d) {
      personaltrainerIcon = d;
    });

    //pets
    BitmapDescriptor.fromAssetImage(ImageConfiguration(size: Size(12, 12)),
            'assets/icons/pet.png')
        .then((d) {
      petIcon = d;
    });

    //photographer
    BitmapDescriptor.fromAssetImage(ImageConfiguration(size: Size(12, 12)),
            'assets/icons/photographer.png')
        .then((d) {
      photographerIcon = d;
    });

    //reform
    BitmapDescriptor.fromAssetImage(ImageConfiguration(size: Size(12, 12)),
            'assets/icons/reform.png')
        .then((d) {
      reformIcon = d;
    });

    //technicalassistance
    BitmapDescriptor.fromAssetImage(ImageConfiguration(size: Size(12, 12)),
            'assets/icons/technicalassistance.png')
        .then((d) {
      taIcon = d;
    });

    // //selected

    // //ac
    // BitmapDescriptor.fromAssetImage(ImageConfiguration(size: Size(12, 12)),
    //         'assets/icons/selectedtypes/ac.png')
    //     .then((d) {
    //   acsIcon = d;
    // });

    // //automobiles
    // BitmapDescriptor.fromAssetImage(ImageConfiguration(size: Size(12, 12)),
    //         'assets/icons/selectedtypes/automobile.png')
    //     .then((d) {
    //   automobilesIcon = d;
    // });

    // //biker
    // BitmapDescriptor.fromAssetImage(ImageConfiguration(size: Size(12, 12)),
    //         'assets/icons/selectedtypes/biker.png')
    //     .then((d) {
    //   bikersIcon = d;
    // });


    // //car
    // BitmapDescriptor.fromAssetImage(ImageConfiguration(size: Size(12, 12)),
    //         'assets/icons/selectedtypes/car.png')
    //     .then((d) {
    //   carsIcon = d;
    // });

    // //carwash
    // BitmapDescriptor.fromAssetImage(ImageConfiguration(size: Size(12, 12)),
    //         'assets/icons/selectedtypes/carwash.png')
    //     .then((d) {
    //   carwashsIcon = d;
    // });

    // //eldercare
    // BitmapDescriptor.fromAssetImage(ImageConfiguration(size: Size(12, 12)),
    //         'assets/icons/selectedtypes/eldercare.png')
    //     .then((d) {
    //   eldercaresIcon = d;
    // });

    // //electrical
    // BitmapDescriptor.fromAssetImage(ImageConfiguration(size: Size(12, 12)),
    //         'assets/icons/selectedtypes/electrical.png')
    //     .then((d) {
    //   electricalsIcon = d;
    // });

    // //furniture assembly
    // BitmapDescriptor.fromAssetImage(ImageConfiguration(size: Size(12, 12)),
    //         'assets/icons/selectedtypes/fa.png')
    //     .then((d) {
    //   fasIcon = d;
    // });

    // //food
    // BitmapDescriptor.fromAssetImage(ImageConfiguration(size: Size(12, 12)),
    //         'assets/icons/selectedtypes/food.png')
    //     .then((d) {
    //   foodsIcon = d;
    // });

    // //gardner
    // BitmapDescriptor.fromAssetImage(ImageConfiguration(size: Size(12, 12)),
    //         'assets/icons/selectedtypes/gardner.png')
    //     .then((d) {
    //   gardnersIcon = d;
    // });

    // //hydraulic
    // BitmapDescriptor.fromAssetImage(ImageConfiguration(size: Size(12, 12)),
    //         'assets/icons/selectedtypes/hydraulic.png')
    //     .then((d) {
    //   hydraulicsIcon = d;
    // });

    // //kidparty
    // BitmapDescriptor.fromAssetImage(ImageConfiguration(size: Size(12, 12)),
    //         'assets/icons/selectedtypes/kidparty.png')
    //     .then((d) {
    //   kidpartysIcon = d;
    // });

    // //locksmith
    // BitmapDescriptor.fromAssetImage(ImageConfiguration(size: Size(12, 12)),
    //         'assets/icons/selectedtypes/locksmith.png')
    //     .then((d) {
    //   locksmithsIcon = d;
    // });

    // //locksmith
    // BitmapDescriptor.fromAssetImage(ImageConfiguration(size: Size(12, 12)),
    //         'assets/icons/selectedtypes/maintanance.png')
    //     .then((d) {
    //   maintanacesIcon = d;
    // });

    // //manicure
    // BitmapDescriptor.fromAssetImage(ImageConfiguration(size: Size(12, 12)),
    //         'assets/icons/selectedtypes/manicure.png')
    //     .then((d) {
    //   manicuresIcon = d;
    // });

    // //massage
    // BitmapDescriptor.fromAssetImage(ImageConfiguration(size: Size(12, 12)),
    //         'assets/icons/selectedtypes/massage.png')
    //     .then((d) {
    //   massagesIcon = d;
    // });

    // //music
    // BitmapDescriptor.fromAssetImage(ImageConfiguration(size: Size(12, 12)),
    //         'assets/icons/selectedtypes/music.png')
    //     .then((d) {
    //   musicsIcon = d;
    // });

    // //personaltrainer
    // BitmapDescriptor.fromAssetImage(ImageConfiguration(size: Size(12, 12)),
    //         'assets/icons/selectedtypes/personaltrainer.png')
    //     .then((d) {
    //   personaltrainersIcon = d;
    // });

    // //pets
    // BitmapDescriptor.fromAssetImage(ImageConfiguration(size: Size(12, 12)),
    //         'assets/icons/selectedtypes/pets.png')
    //     .then((d) {
    //   petsIcon = d;
    // });

    // //photographer
    // BitmapDescriptor.fromAssetImage(ImageConfiguration(size: Size(12, 12)),
    //         'assets/icons/selectedtypes/photographer.png')
    //     .then((d) {
    //   photographersIcon = d;
    // });

    // //reform
    // BitmapDescriptor.fromAssetImage(ImageConfiguration(size: Size(12, 12)),
    //         'assets/icons/selectedtypes/reform.png')
    //     .then((d) {
    //   reformsIcon = d;
    // });

    // //technicalassistance
    // BitmapDescriptor.fromAssetImage(ImageConfiguration(size: Size(12, 12)),
    //         'assets/icons/selectedtypes/technicalassistance.png')
    //     .then((d) {
    //   tasIcon = d;
    // });
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

  get ac {
    return acIcon;
  }

  get automobiles {
    return automobileIcon;
  }

  get biker {
    return bikerIcon;
  }

  get car {
    return carIcon;
  }

  get carwash {
    return carwashIcon;
  }

  get eldercare {
    return eldercareIcon;
  }

  get electrical {
    return electricalIcon;
  }

  get furnitureAssembly {
    return faIcon;
  }

  get food {
    return foodIcon;
  }

  get gardner {
    return gardnerIcon;
  }

  get hydraulic {
    return hydraulicIcon;
  }

  get kidparty {
    return kidpartyIcon;
  }

  get locksmith {
    return locksmithIcon;
  }

  get maintanace {
    return maintanaceIcon;
  }

  get manicure {
    return manicureIcon;
  }

  get massage {
    return massageIcon;
  }

  get music {
    return musicIcon;
  }

  get personaltrainer {
    return personaltrainerIcon;
  }

  get pets {
    return petIcon;
  }

  get photographer {
    return photographerIcon;
  }

  get reform {
    return reformIcon;
  }

  get technicalassistance {
    return taIcon;
  }

  //get selected icon
  // get acselected {
  //   return acsIcon;
  // }

  // get automobileselected {
  //   return automobilesIcon;
  // }

  // get bikerselected {
  //   return bikersIcon;
  // }

  // get carselected {
  //   return carsIcon;
  // }

  // get carwashselected {
  //   return carwashsIcon;
  // }

  // get eldercareselected {
  //   return eldercaresIcon;
  // }

  // get electricalselected {
  //   return electricalsIcon;
  // }

  // get furnitureAssemblyselected {
  //   return fasIcon;
  // }

  // get foodselected {
  //   return foodsIcon;
  // }

  // get gardnerselected {
  //   return gardnersIcon;
  // }

  // get hydraulicselected {
  //   return hydraulicsIcon;
  // }

  // get kidpartyselected {
  //   return kidpartysIcon;
  // }

  // get locksmithselected {
  //   return locksmithsIcon;
  // }

  // get maintanaceselected {
  //   return maintanacesIcon;
  // }

  // get manicureselected {
  //   return manicuresIcon;
  // }

  // get massageselected {
  //   return massagesIcon;
  // }

  // get musicselected {
  //   return musicsIcon;
  // }

  // get personaltrainerselected {
  //   return personaltrainersIcon;
  // }

  // get petselected {
  //   return petsIcon;
  // }

  // get photographerselected {
  //   return photographersIcon;
  // }

  // get reformselected {
  //   return reformsIcon;
  // }

  // get technicalassistanceselected {
  //   return tasIcon;
  // }

}
