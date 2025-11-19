class ApiConfig {
  // AUTH
  static const loginAPI = '/api/v1/login';
  static const logoutAPI = '/api/v1/logout';

  // Location
  static const checkLocationPermissionAPI = '/api/v1/attendance/check-location';

  // ATTENDANCE
  static const trackAttendenceAPI = '/api/v1/attendance/track-attendance';
  static const clockInAPI = '/api/v1/attendance/time-in';
  static const clockOutAPI = '/api/v1/attendance/time-out';

  // LEAVE
  static const leaveTypes = '/api/v1/leave/get-leave-types';
  static const calculateTotalDays = '/api/v1/leave/calculate-totalDays';
  static const leaveRequest = '/api/v1/leave/request-leave';

  // FLIGHT COMM
  static const allFlightComm = '/api/v1/flight-comm/all-flights';
  static const favFlightComm = '/api/v1/flight-comm/mark-favourite';

  static const getFlightDetail = '/api/v1/flight-comm/get-flight-details';
  static const getFlightStaff = '/api/v1/flight-comm/get-all-users';
  static const getFlightChats = '/api/v1/flight-comm/get-chat';
  static const getStaffData = '/api/v1/flight-comm/get-staff-data';

  static const getAllFlightNo = '/api/v1/flight-comm/all-flight-numbers';
  static const getSSROption = '/api/v1/flight-comm/ssr-option-get';
  static const getPTSOption = '/api/v1/flight-comm/fetch-pts-options';

  static const getAircraftType = '/api/v1/flight-comm//get-aircraft-type';
  static const getAircraftReg = '/api/v1/flight-comm//get-aircraft-reg';
  static const getFlightNo = '/api/v1/flight-comm//get-flight-no';
  static const getAirlines = '/api/v1/flight-comm//get-airlines';
  static const getAirlineFlightNo =
      '/api/v1/flight-comm//get-airline-flight-number';
  static const getAirports = '/api/v1/flight-comm//get-airports';

  static const sendMessage = '/api/v1/flight-comm/send-message';
  static const sendSsr = '/api/v1/flight-comm/ssr-send';
  static const sendArr = '/api/v1/flight-comm/send-arr';
  static const sendDsr = '/api/v1/flight-comm/dsr-send';
  static const sendPTS = '/api/v1/flight-comm/pts-send';
  static const sendFhr = '/api/v1/flight-comm/fhr-send';
  static const sendOcc = '/api/v1/flight-comm/occ-send';

  // PTS
  static const ptsAllFlights = '/api/v1/flight-comm/pts-all-flights';

  // MY ROSTER
  static const toadyRoster = '/api/v1/my-roster/today-roster';
  static const monthlyRoster = '/api/v1/my-roster/monthly-roster';
  static const customRoster = '/api/v1/my-roster/custom-range';
  static const addBreakTimeRoster = '/api/v1/my-roster/add-break-time';
  static const markDutyRoster = '/api/v1/my-roster/mark-duty';
}
