class Booking {
  final int id;
  final String service;
  final String bdate;
  final String duration;
  final String timeslot;
  final String recipient;
  final String address;
  final String total;
  String status; // Now mutable for UI updates
  final String paymentStatus;

  Booking({
    required this.id,
    required this.service,
    required this.bdate,
    required this.duration,
    required this.timeslot,
    required this.recipient,
    required this.address,
    required this.total,
    required this.status, // Note: No `final` keyword here
    required this.paymentStatus,
  });

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      id: json['id'],
      service: json['service'],
      bdate: json['bdate'],
      duration: json['duration'],
      timeslot: json['timeslot'],
      recipient: json['recipient'],
      address: json['address'],
      total: json['total'],
      status: json['status'],
      paymentStatus: json['payment_status'],
    );
  }
}
