import 'package:flutter/cupertino.dart';

class Services {
  static final typeofservicesInENG = [
    'CLEANING',
    'AIR CONDITIONING',
    'DRIVER',
    'ELECTRICAL',
    'MUSIC',
    'HYDRAULIC',
    'REFORM',
    'FURNITURE ASSEMBLY',
    'FREIGHT',
    'TECHNICAL ASSISTANCE',
    'GLASS',
    'MASSAGES AND THERAPIES',
    'PARTY ANIMATION',
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
    'PERSONAL TRAINER'
  ];
  static final typeofservicesInBR = [
    'DE LIMPEZA',
    'DE AR-CONDICIONADO',
    'MOTORISTA',
    'ELÉTRICOS',
    'MUSICA',
    'HIDRÁULICOS',
    'DE REFORMA',
    'MONTAGEM DE MÓVEIS',
    'FRETES',
    'ASSISTÊNCIA TÉCNICA',
    'VIDRACEIRO',
    'MASSAGENS E TERAPIAS',
    'ANIMACÃO DE FESTAS',
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
    'PERSONAL TRAINER'
  ];

  var subtypeofcleaningInBR = [
    "LIMPEZA DE CAIXA D'ÁGUA",
    "DIARISTAS E FAXINEIRAS",
    "FAXINA",
    "PASSAR ROUPAS",
    "LAVAGEM DE ROUPAS"
  ];
  var subtypeofcleaningInENG = [
    "WATER BOX CLEANING",
    "DIARISTS AND FAXINEIRAS",
    "FAXINA",
    "IRONING CLOTHES",
    "LAUNDRY WASHING"
  ];

  var subtypeofAirCONDITIONINGInBR = [
    "LIMPEZA DE AR-CONDICIONADO",
    "INSTALAÇÃO DE AR-CONDICIONADO",
    "DESINSTALAÇÃO DE AR-CONDICIONADO",
    "CONSERTO DE AR-CONDICIONADO",
    "MANUTENÇÃO DE AR-CONDICIONADO",
    "PRÉ-INSTALAÇÃO DE AR-CONDICIONADO"
  ];
  var subtypeofAirCONDITIONINGInENG = [
    "AIR CONDITIONING CLEANING",
    "INSTALLATION OF AIR-CONDITIONING",
    "AIR CONDITIONING UNINSTALLATION",
    "AIR CONDITIONING REPAIR",
    "AIR CONDITIONING MAINTENANCE",
    "PRE-INSTALLATION OF AIR CONDITIONING"
  ];

  var subtypeofDriverInENG = [
    "24H SERVICE",
    "ANIMAL TRANSPORT",
    "WITHOUT OWN CAR",
    "WITH OWN CAR"
  ];

  var subtypeofDriverInBR = [
    "ATEDIMENTO 24H",
    "TRANSPORTE DE ANIMAIS",
    "SEM CARRO PROPRIO",
    "COM CARRO PROPRIO"
  ];

  var subtypeofElectricalInBR = [
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

  var subtypeofElectricalInENG = [
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

  var subtypeofMusicInENG = [
    "KEYBOARD",
    "PIANO",
    "CORNER",
    "GUITAR",
    "LOW",
    "DRUMS",
    "GUITAR"
  ];

  var subtypeofMusicInBR = [
    "TECLADO",
    "PIANO",
    "CANTO",
    "GUITARRA",
    "BAIXO",
    "BATERIA",
    "VIOLÃO"
  ];

  var subtypeofHYDRAULICInENG = [
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

  var subtypeofHYDRAULICInBR = [
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

  var subtypeofREFORMInENG = [
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

  var subtypeofREFORMInBR = [
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

  var subtypeofFURNITUREASSEMBLYInENG = [
    "TV SUPPORT INSTALLATION",
    "FURNITURE ASSEMBLY"
  ];

  var subtypeofFURNITUREASSEMBLYInBR = [
    "INSTALAÇÃO DE SUPORTE DE TV",
    "MONTADOR DE MÓVEIS "
  ];

  var subtypeofFREIGHTInENG = ["TV SUPPORT INSTALLATION", "FURNITURE ASSEMBLY"];

  var subtypeofFREIGHTInBR = [
    "WI-FI NETWORK INSTALLATION",
    "COMPUTER FORMATTING"
  ];

  var subtypeofTECHNICALASSISTANCEInENG = [
    "TV SUPPORT INSTALLATION",
    "FURNITURE ASSEMBLY"
  ];

  var subtypeofTECHNICALASSISTANCEInBR = [
    "INSTALAÇÃO DE REDE WI-FI",
    "FORMATAÇÃO DE COMPUTADORES"
  ];

  var subtypeofGLASSInENG = [
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

  var subtypeofGLASSInBR = [
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

  var subtypeofMASSAGESandTHERAPIESInENG = [
    "CHIROPRAXY",
    "QUICK MASSAGE",
    "REFLEXOLOGY",
    "SHIATSU",
    "SUCTION CUP",
    "ACUPUNCTURE",
    "SPORT MASSAGE"
  ];

  var subtypeofMASSAGESandTHERAPIESInBR = [
    "QUIROPRAXIA",
    "QUICK MASSAGE",
    "REFLEXOLOGIA",
    "SHIATSU",
    "VENTOSA",
    "ACUPUNTURA",
    "MASSAGEM DESPORTIVA"
  ];

  var subtypeofPARTYANIMATIONInENG = [
    "CHILDREN RECREATION",
    "CLOWNS",
    "FACE PAINT"
  ];

  var subtypeofPARTYANIMATIONInBR = [
    "RECREAÇÃO INFANTIL",
    "PALHAÇOS",
    "PINTURA FACIAL"
  ];

  var subtypeofLOCKSMITHInENG = [
    "LOCK INSTALLATION",
    "EXCHANGE OF SECRET",
    "AUTOMOBILE KEY",
    "24 HOUR SERVICE",
    "CONTROL FOR AUTOMATIC GATE",
    "CODED KEY"
  ];

  var subtypeofLOCKSMITHInBR = [
    "INSTALAÇÃO DE FECHADURA",
    "TROCA DE SEGREDO",
    "CHAVE DE AUTOMÓVEL",
    "ATENDIMENTO 24 HORAS",
    "CONTROLE PARA PORTÃO AUTOMÁTICO",
    "CHAVE CODIFICADA"
  ];

  var subtypeofBIKEBOYInENG = ["SPARE RACING"];

  var subtypeofBIKEBOYInBR = ["CORRIDA AVULSA"];

  var subtypeofELDERLYCAREGIVERInENG = ["NIGHT", "DAY", "NURSING ASSISTANT"];

  var subtypeofELDERLYCAREGIVERInBR = [
    "NOTURNO",
    "DIURNO",
    "AUXILIAR DE ENFERMAGEM"
  ];

  var subtypeofPHOTOGRAPHERInENG = [
    "FILMING",
    "GRADUATION",
    "BIRTHDAY PARTIES",
    "WEDDINGS",
    "BOOK",
    "DEBUTANT PARTIES"
  ];

  var subtypeofPHOTOGRAPHERInBR = [
    "FILMAGEM",
    "FORMATURA",
    "FESTAS DE ANIVERSÁRIO",
    "CASAMENTOS",
    "BOOK",
    "FESTAS DE DEBUTANTES"
  ];

  var subtypeofGARDENERInENG = [
    "GARDEN MAINTENANCE",
    "TREES REMOVAL",
    "PRUNING TREE"
  ];

  var subtypeofGARDENERInBR = [
    "MANUTENÇÃO JARDINS",
    "REMOÇÃO ÁRVORES",
    "PODA DE ÁRVORE"
  ];

  var subtypeofCARWASHInENG = [
    "NORMAL WASHING",
    "COMPLETE WASHING",
    "DRY CLEAN",
    "CLOSURE",
    "LEATHER HYDRATION",
    "MOTOR",
    "POLISHING"
  ];

  var subtypeofCARWASHInBR = [
    "LAVAGEM NORMAL",
    "LAVAGEM COMPLETA",
    "LAVAGEM A SECO",
    "ENCERAMENTO",
    "HIDRATAÇÃO DE COURO",
    "MOTOR",
    "POLIMENTO"
  ];

  var subtypeofPETSInENG = [
    "TAXI DOG",
    "CAT SITTER",
    "DOG WALKER",
    "VETERINARIO A DOMICILIO"
  ];

  var subtypeofPETSInBR = [
    "TAXI DOG",
    "CAT SITTER",
    "DOG WALKER",
    "VETERINARIO A DOMECILIO "
  ];

  var subtypeofMANICUREInENG = [
    "PEDICURE",
    "DECORATED NAILS",
    "GEL NAILS",
    "PORCELAIN NAILS",
    "NAIL CUTTING",
    "CUTICULAGEM"
  ];

  var subtypeofMANICUREInBR = [
    "PEDICURE",
    "UNHAS DECORADAS",
    "UNHAS DE GEL",
    "UNHAS DE PORCELANA",
    "CORTE DE UNHA",
    "CUTICULAGEM"
  ];

  var subtypeofFOODInENG = ["BUFFET", "CAKES", "BARBECUE"];

  var subtypeofFOODInBR = ["BUFFET", "BOLOS", "CHURRASQUEIRO"];

  var subtypeofAUTOMOBILESInENG = ["MECHANICAL 24H", "24H ELECTRICIAN"];

  var subtypeofAUTOMOBILESInBR = ["MECANICO 24H", "ELETRICISTA 24H"];

  var subtypeofMAINTENANCEInENG = [
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

  var subtypeofMAINTENANCEInBR = [
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

  var subtypeofPERSONALTRAINERInENG = ["BODYBUILDING", "AEROBICS"];

  var subtypeofPERSONALTRAINERInBR = ["MUSCULAÇÃO", "AERÓBICA"];

  String language;
  //singleton logic
  static final Services services = Services._internal();
  Services._internal();
  factory Services() {
    return services;
  }

  static final listOfIcons = [
    "assets/icons/cleaning.png",
    "assets/icons/ac.png",
    "assets/icons/automobile.png",
    "assets/icons/biker.png",
    "assets/icons/car.png",
    "assets/icons/carwash.png",
    "assets/icons/eldercare.png",
    "assets/icons/electrical.png",
    "assets/icons/fa.png",
    "assets/icons/food.png",
    "assets/icons/gardner.png",
    "assets/icons/hydraulic.png",
    "assets/icons/kidparty.png",
    "assets/icons/locksmith.png",
    "assets/icons/maintanance.png",
    "assets/icons/manicure.png",
    "assets/icons/massage.png",
    "assets/icons/music.png",
    "assets/icons/personaltrainer.png",
    "assets/icons/pets.png",
    "assets/icons/photographer.png",
    "assets/icons/reform.png",
    "assets/icons/technicalassistance.png",
     "assets/icons/health.png",
    "assets/icons/repair.png"
    ];

}
