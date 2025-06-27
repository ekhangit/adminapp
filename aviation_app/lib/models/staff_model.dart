import 'package:aviation_app/models/flight_model.dart';

class StaffModel {
  final int id;
  final String name;
  final String? avatar;
  final int airportId;
  final Airport airport;

  StaffModel({
    required this.id,
    required this.name,
    this.avatar,
    required this.airportId,
    required this.airport,
  });

  factory StaffModel.fromJson(Map<String, dynamic> json) {
    return StaffModel(
      id: json['id'],
      name: json['name'],
      avatar: json['avatar'],
      airportId: json['airport_id'],
      airport: Airport.fromJson(json['airport']),
    );
  }

  // Method to get first and last name only
  String get displayName {
    List<String> nameParts = name.trim().split(' ');

    if (nameParts.length == 1) {
      // If only one name, return it
      return nameParts[0];
    } else if (nameParts.length == 2) {
      // If two names, return both
      return name;
    } else {
      // If more than two names, return first and last
      return '${nameParts.first} ${nameParts.last}';
    }
  }

  // Method to get only first name
  String get firstName {
    return name.trim().split(' ').first;
  }

  // Method to get only last name
  String get lastName {
    List<String> nameParts = name.trim().split(' ');
    return nameParts.length > 1 ? nameParts.last : nameParts.first;
  }

  // Method to get initials (first letter of first and last name)
  String get initials {
    List<String> nameParts = name.trim().split(' ');
    if (nameParts.length == 1) {
      return nameParts[0].substring(0, 1).toUpperCase();
    } else {
      return '${nameParts.first.substring(0, 1)}${nameParts.last.substring(0, 1)}'
          .toUpperCase();
    }
  }

  // Method to get custom format (first + last name only)
  String get shortDisplayName {
    List<String> nameParts =
        name.trim().split(' ').where((part) => part.isNotEmpty).toList();

    if (nameParts.isEmpty) return '';
    if (nameParts.length == 1) return nameParts[0];

    // Return first and last name, skipping middle names
    return '${nameParts.first} ${nameParts.last}';
  }
}
