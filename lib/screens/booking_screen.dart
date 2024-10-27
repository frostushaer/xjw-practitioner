import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../models/booking_model.dart';
import '../services/api_service.dart';

class BookingScreen extends StatefulWidget {
  final String practitionerId;

  BookingScreen({required this.practitionerId});

  @override
  _BookingScreenState createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  final ApiService _apiService = ApiService();
  bool _isLoading = true;
  List<Booking>? _bookings;

  @override
  void initState() {
    super.initState();
    _fetchBookings();
  }

  Future<void> _fetchBookings() async {
    final bookings = await _apiService.getBookings(widget.practitionerId);
    setState(() {
      _bookings = bookings;
      _isLoading = false;
    });
  }

  Future<void> _updateStatus(Booking booking, String newStatus) async {
    setState(() {
      _isLoading = true;
    });

    bool success = await _apiService.updateBookingStatus(booking.id, newStatus);

    setState(() {
      _isLoading = false;
      if (success) {
        booking.status = newStatus;
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Failed to update status'),
        ));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text('My Bookings'),
      ),
      child: _isLoading
          ? Center(child: CupertinoActivityIndicator())
          : _bookings == null || _bookings!.isEmpty
              ? Center(child: Text('No bookings found.'))
              : ListView.builder(
                  itemCount: _bookings!.length,
                  itemBuilder: (context, index) {
                    final booking = _bookings![index];
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                booking.service,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.deepPurple,
                                ),
                              ),
                              SizedBox(height: 8),
                              Row(
                                children: [
                                  Icon(CupertinoIcons.calendar),
                                  SizedBox(width: 5),
                                  Expanded(
                                    child: Text(
                                      'Date: ${booking.bdate}',
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 8),
                              Row(
                                children: [
                                  Icon(CupertinoIcons.time),
                                  SizedBox(width: 5),
                                  Expanded(
                                    child: Text(
                                      'Time: ${booking.timeslot}',
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 8),
                              Row(
                                children: [
                                  Icon(CupertinoIcons.person),
                                  SizedBox(width: 5),
                                  Expanded(
                                    child: Text(
                                      'Recipient: ${booking.recipient}',
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 8),
                              Row(
                                children: [
                                  Icon(CupertinoIcons.location),
                                  SizedBox(width: 5),
                                  Expanded(
                                    child: Text(
                                      'Location: ${booking.address}',
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 8),
                              Row(
                                children: [
                                  Icon(CupertinoIcons.money_dollar_circle),
                                  SizedBox(width: 5),
                                  Expanded(
                                    child: Text(
                                      'Total: \$${booking.total}',
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Status: ${_getStatusText(booking.status)}',
                                style: TextStyle(
                                  color: booking.status == "1"
                                      ? Colors.green
                                      : booking.status == "2"
                                          ? Colors.red
                                          : Colors.orange,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(height: 12),
                              if (booking.status ==
                                  "0") // Only show buttons if status is Pending (0)
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    CupertinoButton(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 5, horizontal: 15),
                                      color: Colors.green,
                                      child: Text('Mark as Completed'),
                                      onPressed: () => _updateStatus(booking,
                                          "1"), // Set to 1 for Completed
                                    ),
                                    CupertinoButton(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 5, horizontal: 15),
                                      color: Colors.red,
                                      child: Text('Cancel'),
                                      onPressed: () => _updateStatus(booking,
                                          "2"), // Set to 2 for Canceled
                                    ),
                                  ],
                                )
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
    );
  }

  String _getStatusText(String status) {
    switch (status) {
      case "1":
        return "Completed";
      case "2":
        return "Canceled";
      default:
        return "Pending"; // Default case for "0" or any unrecognized status
    }
  }
}
