class Practitioner {
  final int id; // Changed to int
  final String firstname;
  final String lastname;
  final String email;
  final String ccode;
  final String mobile;
  final String gender;
  final String serviceType;
  final String professionalExp;
  final String reference;
  final String udp;
  final String auth;
  final bool status;
  final String doj;
  final int todayBookings; // New field for dashboard
  final double todayRevenue; // New field for dashboard

  Practitioner({
    required this.id, // Keep it as int
    required this.firstname,
    required this.lastname,
    required this.email,
    required this.ccode,
    required this.mobile,
    required this.gender,
    required this.serviceType,
    required this.professionalExp,
    required this.reference,
    required this.udp,
    required this.auth,
    required this.status,
    required this.doj,
    required this.todayBookings,
    required this.todayRevenue,
  });

  // Factory method to create a Practitioner instance from JSON
  factory Practitioner.fromJson(Map<String, dynamic> json) {
    return Practitioner(
      id: json['id'], // No need to convert to string, keep it as int
      firstname: json['firstname'] ?? '',
      lastname: json['lastname'] ?? '',
      email: json['email'] ?? '',
      ccode: json['ccode'] ?? '',
      mobile: json['mobile'] ?? '',
      gender: json['gender'] ?? '',
      serviceType: json['service_type'] ?? '',
      professionalExp: json['professional_exp'] ?? '',
      reference: json['reference'] ?? '',
      udp: json['udp'] ?? '',
      auth: json['auth'] ?? '',
      status:
          json['status'] == '1', // Assuming '1' for active, '0' for inactive
      doj: json['doj'] ?? '',
      todayBookings: json['today_bookings'] != null
          ? int.parse(json['today_bookings'])
          : 0,
      todayRevenue: json['today_revenue'] != null
          ? double.parse(json['today_revenue'])
          : 0.0,
    );
  }

  // Convert Practitioner instance to JSON (optional if you need to send as JSON)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstname': firstname,
      'lastname': lastname,
      'email': email,
      'ccode': ccode,
      'mobile': mobile,
      'gender': gender,
      'service_type': serviceType,
      'professional_exp': professionalExp,
      'reference': reference,
      'udp': udp,
      'auth': auth,
      'status': status ? '1' : '0',
      'doj': doj,
      'today_bookings': todayBookings.toString(),
      'today_revenue': todayRevenue.toString(),
    };
  }
}
