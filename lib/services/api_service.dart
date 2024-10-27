import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/practitioner_model.dart';

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
    final uri = Uri.parse(_baseUrl);

    print("Making signup request to $uri with data:");
    print({
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
    });

    try {
      final response = await http.post(
        uri,
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

      print('Signup Response: ${response.body}');

      final data = json.decode(response.body);

      if (data['error'] == false) {
        print("Signup successful.");
        return true;
      } else {
        print("Signup failed: ${data['message']}");
        return false;
      }
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

      print('Login Response: ${response.body}'); // Debugging response

      final data = json.decode(response.body);

      if (data['error'] == false) {
        // Return the practitioner ID as a string
        return data['user']['id'].toString(); // Convert int to String
      } else {
        print('Login failed: ${data['message']}');
        return null;
      }
    } catch (e) {
      print('Login error: $e');
      return null;
    }
  }

  Future<bool> toggleStatus(String id, bool status) async {
    final response = await http.post(
      Uri.parse(_baseUrl),
      body: {
        'action': 'update_status_pract',
        'id': id,
        'status': status ? '1' : '0',
      },
    );

    try {
      final data = json.decode(response.body);
      return data['error'] == false;
    } catch (e) {
      print('Error decoding toggle status response: $e');
      return false;
    }
  }

  Future<Practitioner?> getPractitionerDetails(String id) async {
    final response = await http.post(
      Uri.parse(_baseUrl),
      body: {
        'action': 'get_practitioner_detail_via_id',
        'id': id,
      },
    );

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      try {
        final data = json.decode(response.body);

        // Check the response structure
        if (data['error'] == false) {
          return Practitioner.fromJson(data['user']);
        } else {
          print('API Error: ${data['message']}');
        }
      } catch (e) {
        print('Error decoding JSON: $e');
      }
    } else {
      print(
          'Failed to fetch practitioner details, Status code: ${response.statusCode}');
    }
    return null;
  }
}
