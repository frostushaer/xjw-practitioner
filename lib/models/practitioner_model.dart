class Practitioner {
  final int id;
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
  final int todayBookings;
  final double todayRevenue;

  Practitioner({
    required this.id,
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

  factory Practitioner.fromJson(Map<String, dynamic> json) {
    return Practitioner(
      id: json['id'],
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
      status: json['status'] == '1',
      doj: json['doj'] ?? '',
      todayBookings: json['today_bookings'] ?? 0,
      todayRevenue: double.tryParse(json['today_revenue'].toString()) ?? 0.0,
    );
  }
}
