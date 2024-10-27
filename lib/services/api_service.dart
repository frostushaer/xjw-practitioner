import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/practitioner_model.dart';
import '../models/booking_model.dart';

class ApiService {
  static const String _baseUrl = 'https://xjwmobilemassage.com.au/app/api.php';

  Future<bool> signup({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required String ccode,
    required String mobile,
    required String gender,
    required String serviceType,
    required String professionalExp,
    required String reference,
    required String udp,
    required String auth,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(_baseUrl),
        body: {
          'action': 'practitioner_signup',
          'firstname': firstName,
          'lastname': lastName,
          'email': email,
          'password': password,
          'ccode': ccode,
          'mobile': mobile,
          'gender': gender,
          'service_type': serviceType,
          'professional_exp': professionalExp,
          'reference': reference,
          'udp': udp,
          'auth': auth,
        },
      );

      if (response.body.isEmpty) {
        print("Signup Error: Empty response received.");
        return false;
      }

      final data = json.decode(response.body);
      return data['error'] == false;
    } catch (e) {
      print("Signup error: $e");
      return false;
    }
  }

  Future<String?> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(_baseUrl),
        body: {
          'action': 'practitioner_signin',
          'email': email,
          'password': password,
        },
      );

      if (response.body.isEmpty) {
        print("Login Error: Empty response received.");
        return null;
      }

      final data = json.decode(response.body);
      return data['error'] == false ? data['user']['id'].toString() : null;
    } catch (e) {
      print('Login error: $e');
      return null;
    }
  }

  Future<bool> toggleStatus(String id, bool status) async {
    try {
      final response = await http.post(
        Uri.parse(_baseUrl),
        body: {
          'action': 'update_status_pract',
          'id': id,
          'status': status ? '1' : '0',
        },
      );

      if (response.body.isEmpty) {
        print("Toggle Status Error: Empty response received.");
        return false;
      }

      final data = json.decode(response.body);
      return data['error'] == false;
    } catch (e) {
      print('Error decoding toggle status response: $e');
      return false;
    }
  }

  Future<Practitioner?> getPractitionerDetails(String id) async {
    try {
      final response = await http.post(
        Uri.parse(_baseUrl),
        body: {'action': 'get_practitioner_detail_via_id', 'id': id},
      );

      if (response.body.isEmpty) {
        print("Practitioner Details Error: Empty response received.");
        return null;
      }

      final data = json.decode(response.body);
      return data['error'] == false
          ? Practitioner.fromJson(data['user'])
          : null;
    } catch (e) {
      print('Error fetching practitioner details: $e');
      return null;
    }
  }

  Future<List<Booking>?> getBookings(String practitionerId) async {
    try {
      final response = await http.post(
        Uri.parse(_baseUrl),
        body: {
          'action': 'get_all_bookings_for_practitioner',
          'practitioner_id': practitionerId
        },
      );

      if (response.body.isEmpty) {
        print("Bookings Error: Empty response received.");
        return null;
      }

      final data = json.decode(response.body);
      return data['error'] == false
          ? (data['bookings'] as List)
              .map((booking) => Booking.fromJson(booking))
              .toList()
          : null;
    } catch (e) {
      print('Error fetching bookings: $e');
      return null;
    }
  }

  Future<bool> updateBookingStatus(int bookingId, String newStatus) async {
    try {
      final response = await http.post(
        Uri.parse(_baseUrl),
        body: {
          'action': 'update_booking_status',
          'booking_id': bookingId.toString(),
          'status': newStatus
        },
      );

      if (response.body.isEmpty) {
        print("Update Booking Status Error: Empty response received.");
        return false;
      }

      final data = json.decode(response.body);
      return data['error'] == false;
    } catch (e) {
      print('Exception during booking status update: $e');
      return false;
    }
  }

  Future<double?> getTotalRevenue(String practitionerId) async {
    try {
      final response = await http.post(
        Uri.parse(_baseUrl),
        body: {
          'action': 'calculate_total_revenue',
          'practitioner_id': practitionerId
        },
      );

      if (response.body.isEmpty) {
        print("Revenue Error: Empty response received.");
        return 0.0;
      }

      final data = json.decode(response.body);
      return data['error'] == false
          ? (data['total_revenue'] as num).toDouble()
          : 0.0;
    } catch (e) {
      print('Error fetching revenue: $e');
      return 0.0;
    }
  }

  Future<bool> addBlockedTimeslot(String serviceName, String duration,
      String date, String timeslot, String status, String pid) async {
    try {
      final response = await http.post(
        Uri.parse(_baseUrl),
        body: {
          'action': 'add_block_timeslot',
          'service_name': serviceName,
          'duration': duration,
          'date': date,
          'timeslot': timeslot,
          'status': status,
          'pid': pid,
        },
      );

      if (response.body.isEmpty) {
        print("Add Blocked Timeslot Error: Empty response received.");
        return false;
      }

      final data = json.decode(response.body);
      return data['error'] == false;
    } catch (e) {
      print('Error adding blocked timeslot: $e');
      return false;
    }
  }

  Future<List<String>> getServiceNames() async {
    try {
      final response = await http
          .post(Uri.parse(_baseUrl), body: {'action': 'get_services'});

      if (response.body.isEmpty) {
        print("Service Names Error: Empty response received.");
        return [];
      }

      final data = json.decode(response.body);
      return data['error'] == false ? List<String>.from(data['services']) : [];
    } catch (e) {
      print('Error fetching services: $e');
      return [];
    }
  }

  Future<List<String>> getDurations() async {
    try {
      final response = await http.post(
        Uri.parse(_baseUrl),
        body: {'action': 'get_durations'},
      );

      if (response.body.isEmpty) {
        print("Durations Error: Empty response received.");
        return [];
      }

      final data = json.decode(response.body);
      return data['error'] == false
          ? List<String>.from(Set<String>.from(data['durations']))
          : [];
    } catch (e) {
      print('Error fetching durations: $e');
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> getBlockedTimeslots() async {
    try {
      final response = await http.post(
        Uri.parse(_baseUrl),
        body: {'action': 'timeslot_block_list'},
      );

      if (response.body.isEmpty) {
        print("Blocked Timeslots Error: Empty response received.");
        return [];
      }

      final data = json.decode(response.body);
      return data['error'] == false
          ? List<Map<String, dynamic>>.from(data['data'])
          : [];
    } catch (e) {
      print('Error fetching blocked timeslots: $e');
      return [];
    }
  }

  Future<bool> deleteBlockedTimeslot(String id) async {
    try {
      final response = await http.post(
        Uri.parse(_baseUrl),
        body: {'action': 'delete_blocktimeslot', 'id': id},
      );

      if (response.body.isEmpty) {
        print("Delete Blocked Timeslot Error: Empty response received.");
        return false;
      }

      final data = json.decode(response.body);
      return data['error'] == false;
    } catch (e) {
      print('Error deleting blocked timeslot: $e');
      return false;
    }
  }

  Future<List<Map<String, dynamic>>> getBlockedDates() async {
    try {
      final response = await http.post(
        Uri.parse(_baseUrl),
        body: {'action': 'dates_block_list'},
      );

      if (response.body.isEmpty) {
        print("Blocked Dates Error: Empty response received.");
        return [];
      }

      print("Blocked Dates Response: ${response.body}"); // Debug print

      final data = json.decode(response.body);
      if (data is List) {
        return List<Map<String, dynamic>>.from(data);
      } else if (data['error'] == false && data['data'] != null) {
        return List<Map<String, dynamic>>.from(data['data']);
      }

      return [];
    } catch (e) {
      print('Error fetching blocked dates: $e');
      return [];
    }
  }

  Future<bool> deleteBlockedDate(String id) async {
    try {
      final response = await http.post(
        Uri.parse(_baseUrl),
        body: {'action': 'delete_blockdates', 'id': id},
      );

      if (response.body.isEmpty) {
        print("Delete Blocked Date Error: Empty response received.");
        return false;
      }

      final data = json.decode(response.body);
      return data['error'] == false;
    } catch (e) {
      print('Error deleting blocked date: $e');
      return false;
    }
  }

  Future<bool> addBlockedDate(
      String startDate, String endDate, String status, String pid) async {
    try {
      final response = await http.post(
        Uri.parse(_baseUrl),
        body: {
          'action': 'add_block_dates',
          'start_date': startDate,
          'end_date': endDate,
          'status': status,
          'pid': pid,
        },
      );

      if (response.body.isEmpty) {
        print("Add Blocked Date Error: Empty response received.");
        return false;
      }

      final data = json.decode(response.body);
      return data['error'] == false;
    } catch (e) {
      print("Error adding blocked date: $e");
      return false;
    }
  }

  Future<bool> logout() async {
    try {
      final response = await http.post(
        Uri.parse(_baseUrl),
        body: {'action': 'logout'},
      );

      if (response.body.isEmpty) {
        print("Logout Error: Empty response received.");
        return false;
      }

      final data = json.decode(response.body);
      return data['error'] == false;
    } catch (e) {
      print("Error logging out: $e");
      return false;
    }
  }
}
