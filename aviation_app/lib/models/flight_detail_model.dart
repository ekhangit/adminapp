class FlightDetailModel {
  final String airline;
  final String airlineLogo;
  final String flightNo;
  final String fromCode;
  final String toCode;
  final String fromLocation;
  final String toLocation;
  final String departureTime;
  final String arrivalTime;
  final String duration;
  final String status;
  final String unreadCount;
  final bool favourite;

  FlightDetailModel({
    required this.airline,
    required this.airlineLogo,
    required this.flightNo,
    required this.fromCode,
    required this.toCode,
    required this.fromLocation,
    required this.toLocation,
    required this.departureTime,
    required this.arrivalTime,
    required this.duration,
    required this.status,
    this.unreadCount = "0",
    this.favourite = false,
  });
}

final List<FlightDetailModel> flights = [
  FlightDetailModel(
    airlineLogo:
        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQri9xyomw2yZ-JzoobdCHknKBMYEORVzqDi24YeNzQ_thREgQfcNFAg4kpkqTvkPvABB8&usqp=CAU',
    airline: 'British Airways',
    flightNo: 'BA 963',
    fromCode: 'MUC',
    toCode: 'LHR',
    fromLocation: 'Munich, Germany',
    toLocation: 'London, UK',
    arrivalTime: '24 19:05',
    departureTime: '24 18:50',
    duration: '00:15',
    status: 'on-time',
    favourite: false,
  ),
  FlightDetailModel(
    airlineLogo:
        'https://logosandtypes.com/wp-content/uploads/2020/07/Iberia.png',
    airline: 'Iberia',
    flightNo: 'IB 1332',
    fromCode: 'MAD',
    toCode: 'BCN',
    fromLocation: 'Madrid, Spain',
    toLocation: 'Barcelona, Spain',
    arrivalTime: '24 19:45',
    departureTime: '24 19:25',
    duration: '00:20',
    status: 'on-time',
    unreadCount: '5',
    favourite: false,
  ),
  FlightDetailModel(
    airlineLogo:
        'https://w7.pngwing.com/pngs/775/68/png-transparent-aegean-airlines.png',
    airline: 'Aegeane',
    flightNo: 'AE 3501',
    fromCode: 'DXB',
    toCode: 'DOH',
    fromLocation: 'Dubai, UAE',
    toLocation: 'Doha, Qatar',
    arrivalTime: '24 20:30',
    departureTime: '24 20:10',
    duration: '',
    status: 'late',
    unreadCount: '2',
    favourite: false,
  ),
  FlightDetailModel(
    airlineLogo:
        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQN3YBCc6jeY4DM7H3VP1lKfu-iFpleB8Uf3A&s',
    airline: 'Vueling',
    flightNo: 'VY 1813',
    fromCode: 'BCN',
    toCode: 'MAD',
    fromLocation: 'Barcelona, Spain',
    toLocation: 'Madrid, Spain',
    arrivalTime: '24 21:50',
    departureTime: '24 21:30',
    duration: '',
    status: 'late',
    unreadCount: '1',
  ),
  FlightDetailModel(
    airlineLogo:
        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQri9xyomw2yZ-JzoobdCHknKBMYEORVzqDi24YeNzQ_thREgQfcNFAg4kpkqTvkPvABB8&usqp=CAU',
    airline: 'British Airways',
    flightNo: 'BA 987',
    fromCode: 'LHR',
    toCode: 'DXB',
    fromLocation: 'London, UK',
    toLocation: 'Dubai, UAE',
    arrivalTime: '24 23:45',
    departureTime: '24 23:00',
    duration: '00:45',
    status: 'on-time',
    unreadCount: '0',
    favourite: false,
  ),
  FlightDetailModel(
    airlineLogo:
        'https://logosandtypes.com/wp-content/uploads/2020/07/Iberia.png',
    airline: 'Iberia',
    flightNo: 'IB 1001',
    fromCode: 'BCN',
    toCode: 'JFK',
    fromLocation: 'Barcelona, Spain',
    toLocation: 'New York, USA',
    arrivalTime: '24 17:25',
    departureTime: '24 17:00',
    duration: '00:25',
    status: 'on-time',
    unreadCount: '6',
    favourite: false,
  ),
  FlightDetailModel(
    airlineLogo:
        'https://w7.pngwing.com/pngs/775/68/png-transparent-aegean-airlines.png',
    airline: 'Aegeane',
    flightNo: 'AE 3777',
    fromCode: 'ATH',
    toCode: 'FRA',
    fromLocation: 'Athens, Greece',
    toLocation: 'Frankfurt, Germany',
    arrivalTime: '24 14:10',
    departureTime: '24 13:50',
    duration: '00:20',
    status: 'on-time',
    unreadCount: '1',
    favourite: false,
  ),
  FlightDetailModel(
    airlineLogo:
        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQN3YBCc6jeY4DM7H3VP1lKfu-iFpleB8Uf3A&s',
    airline: 'Vueling',
    flightNo: 'VY 2025',
    fromCode: 'ORY',
    toCode: 'BCN',
    fromLocation: 'Paris, France',
    toLocation: 'Barcelona, Spain',
    arrivalTime: '24 15:30',
    departureTime: '24 15:00',
    duration: '00:30',
    status: 'on-time',
    unreadCount: '0',
    favourite: false,
  ),
  FlightDetailModel(
    airlineLogo:
        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQri9xyomw2yZ-JzoobdCHknKBMYEORVzqDi24YeNzQ_thREgQfcNFAg4kpkqTvkPvABB8&usqp=CAU',
    airline: 'British Airways',
    flightNo: 'BA 315',
    fromCode: 'CDG',
    toCode: 'LHR',
    fromLocation: 'Paris, France',
    toLocation: 'London, UK',
    arrivalTime: '24 11:25',
    departureTime: '24 11:00',
    duration: '00:25',
    status: 'on-time',
    unreadCount: '0',
    favourite: false,
  ),
  FlightDetailModel(
    airlineLogo:
        'https://logosandtypes.com/wp-content/uploads/2020/07/Iberia.png',
    airline: 'Iberia',
    flightNo: 'IB 271',
    fromCode: 'LIS',
    toCode: 'MAD',
    fromLocation: 'Lisbon, Portugal',
    toLocation: 'Madrid, Spain',
    arrivalTime: '24 13:10',
    departureTime: '24 12:40',
    duration: '00:30',
    status: 'late',
    unreadCount: '7',
    favourite: false,
  ),

  FlightDetailModel(
    airlineLogo:
        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQri9xyomw2yZ-JzoobdCHknKBMYEORVzqDi24YeNzQ_thREgQfcNFAg4kpkqTvkPvABB8&usqp=CAU',
    airline: 'British Airways',
    flightNo: 'BA 963',
    fromCode: 'MUC',
    toCode: 'LHR',
    fromLocation: 'Munich, Germany',
    toLocation: 'London, UK',
    arrivalTime: '24 19:05',
    departureTime: '24 18:50',
    duration: '00:15',
    status: 'on-time',
    favourite: false,
  ),
  FlightDetailModel(
    airlineLogo:
        'https://logosandtypes.com/wp-content/uploads/2020/07/Iberia.png',
    airline: 'Iberia',
    flightNo: 'IB 1332',
    fromCode: 'MAD',
    toCode: 'BCN',
    fromLocation: 'Madrid, Spain',
    toLocation: 'Barcelona, Spain',
    arrivalTime: '24 19:45',
    departureTime: '24 19:25',
    duration: '00:20',
    status: 'on-time',
    unreadCount: '5',
    favourite: false,
  ),
  FlightDetailModel(
    airlineLogo:
        'https://w7.pngwing.com/pngs/775/68/png-transparent-aegean-airlines.png',
    airline: 'Aegeane',
    flightNo: 'AE 3501',
    fromCode: 'DXB',
    toCode: 'DOH',
    fromLocation: 'Dubai, UAE',
    toLocation: 'Doha, Qatar',
    arrivalTime: '24 20:30',
    departureTime: '24 20:10',
    duration: '',
    status: 'late',
    unreadCount: '2',
    favourite: false,
  ),
];
