import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/practitioner_model.dart';
import '../models/booking_model.dart';

class ApiService {
  static const String _baseUrl = 'https://xjwmobilemassage.com.au/app/api.php';

  // Signup function
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

      final data = json.decode(response.body);
      return data['error'] == false;
    } catch (e) {
      print("Signup error: $e");
      return false;
    }
  }

  // Login function
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

      final data = json.decode(response.body);
      return data['error'] == false ? data['user']['id'].toString() : null;
    } catch (e) {
      print('Login error: $e');
      return null;
    }
  }

  // Toggle practitioner status
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

      final data = json.decode(response.body);
      return data['error'] == false;
    } catch (e) {
      print('Error decoding toggle status response: $e');
      return false;
    }
  }

  // Get practitioner details
  Future<Practitioner?> getPractitionerDetails(String id) async {
    try {
      final response = await http.post(
        Uri.parse(_baseUrl),
        body: {'action': 'get_practitioner_detail_via_id', 'id': id},
      );

      final data = json.decode(response.body);
      return data['error'] == false
          ? Practitioner.fromJson(data['user'])
          : null;
    } catch (e) {
      print('Error fetching practitioner details: $e');
      return null;
    }
  }

  // Get all bookings for a practitioner
  Future<List<Booking>?> getBookings(String practitionerId) async {
    try {
      final response = await http.post(
        Uri.parse(_baseUrl),
        body: {
          'action': 'get_all_bookings_for_practitioner',
          'practitioner_id': practitionerId
        },
      );

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

  // Update booking status
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

      final data = json.decode(response.body);
      return data['error'] == false;
    } catch (e) {
      print('Exception during booking status update: $e');
      return false;
    }
  }

  // Calculate total revenue for a practitioner
  Future<double?> getTotalRevenue(String practitionerId) async {
    try {
      final response = await http.post(
        Uri.parse(_baseUrl),
        body: {
          'action': 'calculate_total_revenue',
          'practitioner_id': practitionerId
        },
      );

      final data = json.decode(response.body);
      return data['error'] == false
          ? (data['total_revenue'] as num).toDouble()
          : 0.0;
    } catch (e) {
      print('Error fetching revenue: $e');
      return 0.0;
    }
  }

  // Add blocked timeslot
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

      final data = json.decode(response.body);
      return data['error'] == false;
    } catch (e) {
      print('Error adding blocked timeslot: $e');
      return false;
    }
  }

  // Get list of service names
  Future<List<String>> getServiceNames() async {
    try {
      final response = await http
          .post(Uri.parse(_baseUrl), body: {'action': 'get_services'});

      final data = json.decode(response.body);
      return data['error'] == false ? List<String>.from(data['services']) : [];
    } catch (e) {
      print('Error fetching services: $e');
      return [];
    }
  }

  // Get list of durations
  Future<List<String>> getDurations() async {
    try {
      final response = await http.post(
        Uri.parse(_baseUrl),
        body: {'action': 'get_durations'},
      );

      final data = json.decode(response.body);
      if (data['error'] == false) {
        // Convert to a Set to remove duplicates, then back to List
        return List<String>.from(Set<String>.from(data['durations']));
      } else {
        print('API Error: ${data['message']}');
      }
    } catch (e) {
      print('Error fetching durations: $e');
    }
    return [];
  }

  // Get blocked timeslots
  Future<List<Map<String, dynamic>>> getBlockedTimeslots() async {
    try {
      final response = await http
          .post(Uri.parse(_baseUrl), body: {'action': 'timeslot_block_list'});

      final data = json.decode(response.body);
      return data['error'] == false
          ? List<Map<String, dynamic>>.from(data['data'])
          : [];
    } catch (e) {
      print('Error fetching blocked timeslots: $e');
      return [];
    }
  }

  // Delete a blocked timeslot
  Future<bool> deleteBlockedTimeslot(String id) async {
    try {
      final response = await http.post(
        Uri.parse(_baseUrl),
        body: {'action': 'delete_blocktimeslot', 'id': id},
      );

      final data = json.decode(response.body);
      return data['error'] == false;
    } catch (e) {
      print('Error deleting blocked timeslot: $e');
      return false;
    }
  }
}
