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
  });
}

final List<FlightDetailModel> flights = [
  FlightDetailModel(
    airlineLogo:
        'https://brandstruck.co/wp-content/uploads/2016/08/british-airways-logo.png',
    airline: 'British Airways',
    flightNo: 'BA 947',
    fromCode: 'MUC',
    toCode: 'LHR',
    fromLocation: 'Munich, Germany',
    toLocation: 'London, UK',
    arrivalTime: '16:05:25',
    departureTime: '16:05:33',
    duration: '00:06',
    status: 'on-time',
  ),
  FlightDetailModel(
    airlineLogo:
        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTTBc71Wi9Jmn98jzC-d4EQE3_7komn9EAjSA&s',
    airline: 'Iberia',
    flightNo: 'IB 6798',
    fromCode: 'MAD',
    toCode: 'BCN',
    fromLocation: 'Madrid, Spain',
    toLocation: 'Barcelona, Spain',
    arrivalTime: '12:45:00',
    departureTime: '11:30:00',
    duration: '00:11',
    status: 'on-time',
  ),
  FlightDetailModel(
    airlineLogo:
        'https://upload.wikimedia.org/wikipedia/commons/thumb/d/d0/Emirates_logo.svg/1200px-Emirates_logo.svg.png',
    airline: 'Emirates Airline',
    flightNo: 'EK 802',
    fromCode: 'DXB',
    toCode: 'DOH',
    fromLocation: 'Dubai, UAE',
    toLocation: 'Doha, Qatar',
    arrivalTime: '09:50:00',
    departureTime: '08:30:00',
    duration: '00:05',
    status: 'late',
  ),
  FlightDetailModel(
    airlineLogo:
        'https://brandstruck.co/wp-content/uploads/2016/08/british-airways-logo.png',
    airline: 'Qatar Airways',
    flightNo: 'QR 101',
    fromCode: 'DOH',
    toCode: 'CDG',
    fromLocation: 'Doha, Qatar',
    toLocation: 'Paris, France',
    arrivalTime: '14:05:00',
    departureTime: '07:00:00',
    duration: '00:12',
    status: 'on-time',
  ),
  FlightDetailModel(
    airlineLogo:
        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTTBc71Wi9Jmn98jzC-d4EQE3_7komn9EAjSA&s',
    airline: 'Air India',
    flightNo: 'AI 187',
    fromCode: 'DEL',
    toCode: 'YYZ',
    fromLocation: 'Delhi, India',
    toLocation: 'Toronto, Canada',
    arrivalTime: '19:15:00',
    departureTime: '03:30:00',
    duration: '00:03',
    status: 'on-time',
  ),
  FlightDetailModel(
    airlineLogo:
        'https://upload.wikimedia.org/wikipedia/commons/thumb/d/d0/Emirates_logo.svg/1200px-Emirates_logo.svg.png',
    airline: 'Singapore Airlines',
    flightNo: 'SQ 322',
    fromCode: 'SIN',
    toCode: 'LHR',
    fromLocation: 'Singapore',
    toLocation: 'London, UK',
    arrivalTime: '18:40:00',
    departureTime: '09:05:00',
    duration: '00:09',
    status: 'on-time',
  ),
  FlightDetailModel(
    airlineLogo:
        'https://brandstruck.co/wp-content/uploads/2016/08/british-airways-logo.png',
    airline: 'Etihad Airways',
    flightNo: 'EY 151',
    fromCode: 'AUH',
    toCode: 'JFK',
    fromLocation: 'Abu Dhabi, UAE',
    toLocation: 'New York, USA',
    arrivalTime: '21:10:00',
    departureTime: '14:15:00',
    duration: '00:20',
    status: 'late',
  ),
  FlightDetailModel(
    airlineLogo:
        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTTBc71Wi9Jmn98jzC-d4EQE3_7komn9EAjSA&s',
    airline: 'American Airlines',
    flightNo: 'AA 101',
    fromCode: 'JFK',
    toCode: 'LAX',
    fromLocation: 'New York, USA',
    toLocation: 'Los Angeles, USA',
    arrivalTime: '17:05:00',
    departureTime: '14:00:00',
    duration: '06h 05m',
    status: 'on-time',
  ),
  FlightDetailModel(
    airlineLogo:
        'https://upload.wikimedia.org/wikipedia/commons/thumb/d/d0/Emirates_logo.svg/1200px-Emirates_logo.svg.png',
    airline: 'Lufthansa',
    flightNo: 'LH 400',
    fromCode: 'FRA',
    toCode: 'JFK',
    fromLocation: 'Frankfurt, Germany',
    toLocation: 'New York, USA',
    arrivalTime: '12:00:00',
    departureTime: '08:15:00',
    duration: '00:08',
    status: 'on-time',
  ),
];
