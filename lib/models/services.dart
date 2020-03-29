import 'package:flutter/cupertino.dart';

class Services {
  static final typeofservicesInENG = [
    'CLEANING',
    'AIR CONDITIONING',
    'DRIVER',
    'ELECTRICAL',
    'MUSIC',
    'HYDRAULIC',
    'FURNITURE ASSEMBLY',
    'TECHNICAL ASSISTANCE',
    'MASSAGES AND THERAPIES',
    'BIKEBOY',
    'LOCKSMITH',
    'ELDERLY CAREGIVER',
    'PHOTOGRAPHER',
    'GARDENER',
    'CAR WASH',
    'PETS',
    'MANICURE',
    'FOOD',
    'AUTOMOBILES',
    'MAINTENANCE',
    'PERSONAL TRAINER',
    'PARTY ANIMATION',
    'GLASS',
    'REFORM',
    'FREIGHT',
  ];
  static final typeofservicesInBR = [
    'DE LIMPEZA',
    'DE AR-CONDICIONADO',
    'MOTORISTA',
    'Eletricistas',
    'MUSICA',
    'HIDRÁULICOS',
    'MONTAGEM DE MÓVEIS',
    'ASSISTÊNCIA TÉCNICA',
    'MASSAGENS E TERAPIAS',
    'BIKEBOY',
    'CHAVEIRO',
    'CUIDADOR IDOSO',
    'FOTOGRAFO',
    'JARDINEIRO',
    'LAVAGEM DE CARRO',
    'PETS',
    'MANICURE',
    'ALIMENTAÇÃO',
    'AUTOMOVEIS',
    'MANUTENÇÃO',
    'PERSONAL TRAINER',
    'ANIMACÃO DE FESTAS',
    'VIDRACEIRO',
    'DE REFORMA',
    'FRETES',
  ];

  static final subtypeofcleaningInBR = [
    "LIMPEZA DE CAIXA D'ÁGUA",
    "DIARISTAS E FAXINEIRAS",
    "FAXINA",
    "PASSAR ROUPAS",
    "LAVAGEM DE ROUPAS"
  ];
  static final subtypeofcleaningInENG = [
    "WATER BOX CLEANING",
    "DIARISTS AND FAXINEIRAS",
    "FAXINA",
    "IRONING CLOTHES",
    "LAUNDRY WASHING"
  ];

  static final subtypeofAirCONDITIONINGInBR = [
    "LIMPEZA DE AR-CONDICIONADO",
    "INSTALAÇÃO DE AR-CONDICIONADO",
    "DESINSTALAÇÃO DE AR-CONDICIONADO",
    "CONSERTO DE AR-CONDICIONADO",
    "MANUTENÇÃO DE AR-CONDICIONADO",
    "PRÉ-INSTALAÇÃO DE AR-CONDICIONADO"
  ];
  static final subtypeofAirCONDITIONINGInENG = [
    "AIR CONDITIONING CLEANING",
    "INSTALLATION OF AIR-CONDITIONING",
    "AIR CONDITIONING UNINSTALLATION",
    "AIR CONDITIONING REPAIR",
    "AIR CONDITIONING MAINTENANCE",
    "PRE-INSTALLATION OF AIR CONDITIONING"
  ];

  static final subtypeofDriverInENG = [
    "24H SERVICE",
    "ANIMAL TRANSPORT",
    "WITHOUT OWN CAR",
    "WITH OWN CAR"
  ];

  static final subtypeofDriverInBR = [
    "ATEDIMENTO 24H",
    "TRANSPORTE DE ANIMAIS",
    "SEM CARRO PROPRIO",
    "COM CARRO PROPRIO"
  ];

  static final subtypeofElectricalInBR = [
    "INSTALAÇÃO DE CHUVEIRO ELÉTRICO",
    "INSTALAÇÃO DE VENTILADOR DE TETO",
    "INSTALAÇÃO DE TOMADA E INTERRUPTOR",
    "INSTALAÇÃO DE DISJUNTOR",
    "INSTALAÇÃO DE LUMINÁRIA",
    "INSTALAÇÃO DE COIFA E DEPURADOR",
    "INSTALAÇÃO DE HOME THEATER",
    "INSTALAÇÃO DE INTERFONE",
    "INSTALAÇÃO DE SUPORTE TELEVISÃO",
    "DESENHO ELÉTRICO",
    "PADRÃO DE ENTRADA",
    "ATENDIMENTO 24HORAS",
  ];

  static final subtypeofElectricalInENG = [
    "INSTALLATION OF ELECTRIC SHOWER",
    "CEILING FAN INSTALLATION",
    "SOCKET AND SWITCH INSTALLATION",
    "BREAKER INSTALLATION",
    "LUMINAIRE INSTALLATION",
    "INSTALLATION OF COIFA AND PURPLE",
    "HOME THEATER INSTALLATION",
    "INTERFACE INSTALLATION",
    "TELEVISION SUPPORT INSTALLATION",
    "ELECTRICAL DRAWING",
    "ENTRY STANDARD",
    "24HORAS SERVICE"
  ];

  static final subtypeofMusicInENG = [
    "KEYBOARD",
    "PIANO",
    "CORNER",
    "GUITAR",
    "LOW",
    "DRUMS",
    "GUITAR"
  ];

  static final subtypeofMusicInBR = [
    "TECLADO",
    "PIANO",
    "CANTO",
    "GUITARRA",
    "BAIXO",
    "BATERIA",
    "VIOLÃO"
  ];

  static final subtypeofHYDRAULICInENG = [
    "INSTALLATION OF GAS HEATER",
    "GAS HEATER REPAIR",
    "LEAK REPAIR",
    "WASHING MACHINE INSTALLATION",
    "INSTALLATION OF WASHING MACHINE",
    "CLEANING OF WATER CAPS",
    "TAP INSTALLATION",
    "UNPLUG SANITARY VASE",
    "PLUMBER",
    "24HORAS ATTENDANCE",
    "LEAKS"
  ];

  static final subtypeofHYDRAULICInBR = [
    "INSTALAÇÃO DE AQUECEDOR A GÁS",
    "CONSERTO DE AQUECEDOR A GÁS",
    "CONSERTO DE VAZAMENTO",
    "INSTALAÇÃO DE MÁQUINA DE LAVAR LOUÇA",
    "INSTALAÇÃO DE MÁQUINA DE LAVAR ROUPA",
    "LIMPEZA DE CAIXA D'ÁGUA",
    "INSTALAÇÃO DE TORNEIRA",
    "DESENTUPIR VASO SANITÁRIO",
    "ENCANADOR",
    "ATEDIMENTO 24HORAS",
    "VAZAMENTOS"
  ];

  static final subtypeofREFORMInENG = [
    "EXTERNAL PAINTING",
    "HONEY MASONRY SERVICE",
    "PAINTING OF DOORS AND WINDOWS",
    "GATE AND GRID PAINTING",
    "WALL AND CEILING PAINT (INTERNAL)",
    "PLACEMENT OF PORCELAIN FLOOR",
    "LAMINATE FLOOR INSTALLATION",
    "PLACEMENT OF CERAMIC FLOOR",
    "WALL COVERING INSTALLATION",
    "REPAIR FLOOR OR FINISHING",
    "RENT HUSBAND",
    "INSTALLATION OF PERSIANA AND CURTAIN",
    "PERSIANAS REPAIR",
    "SKIRTING INSTALLATION",
    "PROTECTION NETWORK INSTALLATION",
    "WALLPAPER INSTALLATION"
  ];

  static final subtypeofREFORMInBR = [
    "PINTURA EXTERNA ",
    "SERVIÇO PEDREIRO HORA",
    "PINTURA DE PORTAS E JANELAS",
    "PINTURA DE PORTÃO E GRADE",
    "PINTURA DE PAREDE E TETO (INTERNA)",
    "COLOCAÇÃO DE PISO PORCELANATO",
    "INSTALAÇÃO DE PISO LAMINADO",
    "COLOCAÇÃO DE PISO CERÂMICO",
    "INSTALAÇÃO DE REVESTIMENTO NA PAREDE",
    "REPARAR PISO OU REVESTIMENTO",
    "MARIDO DE ALUGUEL",
    "INSTALAÇÃO DE PERSIANA E CORTINA",
    "CONSERTO DE PERSIANAS",
    "INSTALAÇÃO DE RODAPÉ",
    "INSTALAÇÃO DE REDE DE PROTEÇÃO",
    "INSTALAÇÃO DE PAPEL DE PAREDE"
  ];

  static final subtypeofFURNITUREASSEMBLYInENG = [
    "TV SUPPORT INSTALLATION",
    "FURNITURE ASSEMBLY"
  ];

  static final subtypeofFURNITUREASSEMBLYInBR = [
    "INSTALAÇÃO DE SUPORTE DE TV",
    "MONTADOR DE MÓVEIS "
  ];

  static final subtypeofFREIGHTInENG = ["TV SUPPORT INSTALLATION", "FURNITURE ASSEMBLY"];

  static final subtypeofFREIGHTInBR = [
    "WI-FI NETWORK INSTALLATION",
    "COMPUTER FORMATTING"
  ];

  static final subtypeofTECHNICALASSISTANCEInENG = [
    "TV SUPPORT INSTALLATION",
    "FURNITURE ASSEMBLY"
  ];

  static final subtypeofTECHNICALASSISTANCEInBR = [
    "INSTALAÇÃO DE REDE WI-FI",
    "FORMATAÇÃO DE COMPUTADORES"
  ];

  static final subtypeofGLASSInENG = [
    "GLASS PRINTING",
    "GLASS PAINTINGS",
    "MIRROR PRINTING",
    "MODELED MIRROR",
    "GLASS TOPS",
    "BOX GLASS",
    "BALCONIES",
    "BLASTED GLASSES",
    "TEMPERED GLASSES"
  ];

  static final subtypeofGLASSInBR = [
    "IMPRESSÃO VIDROS",
    "PINTURAS EM VIDROS",
    "IMPRESSÃO EM ESPELHOS",
    "ESPELHO MODELADO",
    "TAMPOS DE VIDRO",
    "BOX VIDRO",
    "SACADAS",
    "VIDROS JATEADOS",
    "VIDOROS TEMPERADOS"
  ];

  static final subtypeofMASSAGESandTHERAPIESInENG = [
    "CHIROPRAXY",
    "QUICK MASSAGE",
    "REFLEXOLOGY",
    "SHIATSU",
    "SUCTION CUP",
    "ACUPUNCTURE",
    "SPORT MASSAGE"
  ];

  static final subtypeofMASSAGESandTHERAPIESInBR = [
    "QUIROPRAXIA",
    "QUICK MASSAGE",
    "REFLEXOLOGIA",
    "SHIATSU",
    "VENTOSA",
    "ACUPUNTURA",
    "MASSAGEM DESPORTIVA"
  ];

  static final subtypeofPARTYANIMATIONInENG = [
    "CHILDREN RECREATION",
    "CLOWNS",
    "FACE PAINT"
  ];

  static final subtypeofPARTYANIMATIONInBR = [
    "RECREAÇÃO INFANTIL",
    "PALHAÇOS",
    "PINTURA FACIAL"
  ];

  static final subtypeofLOCKSMITHInENG = [
    "LOCK INSTALLATION",
    "EXCHANGE OF SECRET",
    "AUTOMOBILE KEY",
    "24 HOUR SERVICE",
    "CONTROL FOR AUTOMATIC GATE",
    "CODED KEY"
  ];

  static final subtypeofLOCKSMITHInBR = [
    "INSTALAÇÃO DE FECHADURA",
    "TROCA DE SEGREDO",
    "CHAVE DE AUTOMÓVEL",
    "ATENDIMENTO 24 HORAS",
    "CONTROLE PARA PORTÃO AUTOMÁTICO",
    "CHAVE CODIFICADA"
  ];

  static final subtypeofBIKEBOYInENG = ["SPARE RACING"];

  static final subtypeofBIKEBOYInBR = ["CORRIDA AVULSA"];

  static final subtypeofELDERLYCAREGIVERInENG = ["NIGHT", "DAY", "NURSING ASSISTANT"];

  static final subtypeofELDERLYCAREGIVERInBR = [
    "NOTURNO",
    "DIURNO",
    "AUXILIAR DE ENFERMAGEM"
  ];

  static final subtypeofPHOTOGRAPHERInENG = [
    "FILMING",
    "GRADUATION",
    "BIRTHDAY PARTIES",
    "WEDDINGS",
    "BOOK",
    "DEBUTANT PARTIES"
  ];

  static final subtypeofPHOTOGRAPHERInBR = [
    "FILMAGEM",
    "FORMATURA",
    "FESTAS DE ANIVERSÁRIO",
    "CASAMENTOS",
    "BOOK",
    "FESTAS DE DEBUTANTES"
  ];

  static final subtypeofGARDENERInENG = [
    "GARDEN MAINTENANCE",
    "TREES REMOVAL",
    "PRUNING TREE"
  ];

  static final subtypeofGARDENERInBR = [
    "MANUTENÇÃO JARDINS",
    "REMOÇÃO ÁRVORES",
    "PODA DE ÁRVORE"
  ];

  static final subtypeofCARWASHInENG = [
    "NORMAL WASHING",
    "COMPLETE WASHING",
    "DRY CLEAN",
    "CLOSURE",
    "LEATHER HYDRATION",
    "MOTOR",
    "POLISHING"
  ];

  static final subtypeofCARWASHInBR = [
    "LAVAGEM NORMAL",
    "LAVAGEM COMPLETA",
    "LAVAGEM A SECO",
    "ENCERAMENTO",
    "HIDRATAÇÃO DE COURO",
    "MOTOR",
    "POLIMENTO"
  ];

  static final subtypeofPETSInENG = [
    "TAXI DOG",
    "CAT SITTER",
    "DOG WALKER",
    "VETERINARIO A DOMICILIO"
  ];

  static final subtypeofPETSInBR = [
    "TAXI DOG",
    "CAT SITTER",
    "DOG WALKER",
    "VETERINARIO A DOMECILIO "
  ];

  static final subtypeofMANICUREInENG = [
    "PEDICURE",
    "DECORATED NAILS",
    "GEL NAILS",
    "PORCELAIN NAILS",
    "NAIL CUTTING",
    "CUTICULAGEM"
  ];

  static final subtypeofMANICUREInBR = [
    "PEDICURE",
    "UNHAS DECORADAS",
    "UNHAS DE GEL",
    "UNHAS DE PORCELANA",
    "CORTE DE UNHA",
    "CUTICULAGEM"
  ];

  static final subtypeofFOODInENG = ["BUFFET", "CAKES", "BARBECUE"];

  static final subtypeofFOODInBR = ["BUFFET", "BOLOS", "CHURRASQUEIRO"];

  static final subtypeofAUTOMOBILESInENG = ["MECHANICAL 24H", "24H ELECTRICIAN"];

  static final subtypeofAUTOMOBILESInBR = ["MECANICO 24H", "ELETRICISTA 24H"];

  static final subtypeofMAINTENANCEInENG = [
    "ALARM INSTALLATION",
    "24HORAS SERVICE",
    "DEDETIZATION",
    "FENCE ELECTRIC INSTALLATION",
    "GASISTA",
    "ELECTRONIC GATE",
    "PROTECTION NETWORKS",
    "INSTALLATION OF SECURITY CAMERAS",
    "HEATERS",
    "DIGITAL ANTENNA INSTALLATION",
    "WALL PAPER INSTALLATION",
    "GUTTERS"
  ];

  static final subtypeofMAINTENANCEInBR = [
    "INSTALAÇÃO DE ALARME",
    "ATENDIMENTO 24HORAS",
    "DEDETIZAÇÃO",
    "INTALAÇÃO CERCA ELETRICA",
    "GASISTA",
    "PORTÃO ELETRÔNICO",
    "REDES PROTEÇÃO",
    "INSTALAÇÃO DE CÂMERAS DE SEGURANÇA",
    "AQUECEDEROS",
    "INSTALAÇÃO DE ANTENA DIGITAL",
    "INSTALAÇÃO DE PAPAEL DE PAREDE",
    "CALHAS"
  ];

  static final subtypeofPERSONALTRAINERInENG = ["BODYBUILDING", "AEROBICS"];

  static final subtypeofPERSONALTRAINERInBR = ["MUSCULAÇÃO", "AERÓBICA"];

  String language;
  //singleton logic
  static final Services services = Services._internal();
  Services._internal();
  factory Services() {
    return services;
  }

  static AssetImage unselectedcleaning =  AssetImage("assets/icons/cleaning.png");
  static AssetImage selectedcleaning = AssetImage("assets/icons/selectedtypes/cleanings.png");  
  static AssetImage unselectedcar = AssetImage("assets/icons/car.png");
  static AssetImage selectedcar = AssetImage("assets/icons/selectedtypes/cars.png");
  static AssetImage unselectedelectrical = AssetImage("assets/icons/electrical.png");
  static AssetImage selectedelectrical = AssetImage("assets/icons/selectedtypes/electricals.png");
  static AssetImage unselectedmusic = AssetImage("assets/icons/music.png");
  static AssetImage selectedmusic = AssetImage("assets/icons/selectedtypes/musics.png");
  static AssetImage unselectedhydraulic = AssetImage("assets/icons/hydraulic.png");
  static AssetImage selectedhydraulic = AssetImage("assets/icons/selectedtypes/hydraulics.png");
  static AssetImage unselectedbiker =  AssetImage("assets/icons/biker.png");
  static AssetImage selectedbiker = AssetImage("assets/icons/selectedtypes/bikers.png");  
  static AssetImage unselectedlocksmith = AssetImage("assets/icons/locksmith.png");
  static AssetImage selectedlocksmith = AssetImage("assets/icons/selectedtypes/locksmiths.png");
  static AssetImage unselectedeldercare = AssetImage("assets/icons/eldercare.png");
  static AssetImage selectedeldercare = AssetImage("assets/icons/selectedtypes/eldercares.png");
  static AssetImage unselectedphotographer = AssetImage("assets/icons/photographer.png");
  static AssetImage selectedphotographer= AssetImage("assets/icons/selectedtypes/photographers.png");
  static AssetImage unselectedgardner = AssetImage("assets/icons/gardner.png");
  static AssetImage selectedgardner = AssetImage("assets/icons/selectedtypes/gardners.png");
  static AssetImage unselectedcarwash = AssetImage("assets/icons/carwash.png");
  static AssetImage selectedcarwash = AssetImage("assets/icons/selectedtypes/carwashs.png");
  static AssetImage unselectedpets = AssetImage("assets/icons/pets.png");
  static AssetImage selectedpets = AssetImage("assets/icons/selectedtypes/petss.png");
  static AssetImage unselectedmanicure = AssetImage("assets/icons/manicure.png");
  static AssetImage selectedmanicure= AssetImage("assets/icons/selectedtypes/manicures.png");
  static AssetImage unselectedfood = AssetImage("assets/icons/food.png");
  static AssetImage selectedfood = AssetImage("assets/icons/selectedtypes/foods.png");
  static AssetImage unselectautomobile = AssetImage("assets/icons/automobile.png");
  static AssetImage selectedautomobile = AssetImage("assets/icons/selectedtypes/automobiles.png");
  static AssetImage unselectedmaintanance = AssetImage("assets/icons/maintanance.png");
  static AssetImage selectedmaintanance= AssetImage("assets/icons/selectedtypes/maintanances.png");
  static AssetImage unselectedac = AssetImage("assets/icons/ac.png");
  static AssetImage selectedac = AssetImage("assets/icons/selectedtypes/acs.png");
  static AssetImage unselectedfa = AssetImage("assets/icons/fa.png");
  static AssetImage selectedfa = AssetImage("assets/icons/selectedtypes/fas.png");
  static AssetImage unselectedtechnicalassistance = AssetImage("assets/icons/technicalassistance.png");
  static AssetImage selectedtechnicalassistance= AssetImage("assets/icons/selectedtypes/technicalassistances.png");
  static AssetImage unselectedmassage = AssetImage("assets/icons/massage.png");
  static AssetImage selectedmassage = AssetImage("assets/icons/selectedtypes/massages.png");
  static AssetImage unselectedpersonaltrainer= AssetImage("assets/icons/personaltrainer.png");
  static AssetImage selectedpersonaltrainer = AssetImage("assets/icons/selectedtypes/personaltrainers.png");
  static AssetImage unselectedkidparty = AssetImage("assets/icons/kidparty.png");
  static AssetImage selectedkidparty= AssetImage("assets/icons/selectedtypes/kidpartys.png");
  static AssetImage unselectedglass = AssetImage("assets/icons/glass.png");
  static AssetImage selectedglass = AssetImage("assets/icons/selectedtypes/glasss.png");
  static AssetImage unselectedreform = AssetImage("assets/icons/reform.png");
  static AssetImage selectedreform= AssetImage("assets/icons/selectedtypes/reforms.png");
  static AssetImage unselectedfreight = AssetImage("assets/icons/freight.png");
  static AssetImage selectedfreight= AssetImage("assets/icons/selectedtypes/freights.png");

}
