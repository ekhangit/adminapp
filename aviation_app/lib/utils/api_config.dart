class ApiConfig {
  // AUTH
  static const loginAPI = '/api/v1/login';
  static const logoutAPI = '/api/v1/logout';

  // FLIGHT COMM
  static const allFlightComm = '/api/v1/flight-comm/all-flights';
  static const getFlightDetail = '/api/v1/flight-comm/get-flight-details';
  static const getFlightChats = '/api/v1/flight-comm/get-chat';

  static const getAllFlightNo = '/api/v1/flight-comm/all-flight-numbers';
  static const getAircraftType = '/api/v1/flight-comm//get-aircraft-type';
  static const getAircraftReg = '/api/v1/flight-comm//get-aircraft-reg';
  static const getFlightNo = '/api/v1/flight-comm//get-flight-no';
  static const getAirlines = '/api/v1/flight-comm//get-airlines';
  static const getAirlineFlightNo =
      '/api/v1/flight-comm//get-airline-flight-number';
  static const getAirports = '/api/v1/flight-comm//get-airports';

  static const sendArr = '/api/v1/flight-comm/send-arr';
  static const sendDsr = '/api/v1/flight-comm/dsr-send';
  static const sendFhr = '/api/v1/flight-comm/fhr-send';
  static const sendOcc = '/api/v1/flight-comm//occ-send';
}
