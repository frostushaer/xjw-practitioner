import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/practitioner_model.dart';
import 'booking_screen.dart';
import 'RevenueScreen.dart';
import 'BlockedTimeslotScreen.dart';

class DashboardScreen extends StatefulWidget {
  final String practitionerId;

  DashboardScreen({required this.practitionerId});

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final ApiService _apiService = ApiService();
  bool _isLoading = true;
  bool _isActive = false;
  int _todayBookings = 0;
  double _todayRevenue = 0.0;
  Practitioner? _practitioner;

  @override
  void initState() {
    super.initState();
    _fetchDashboardData();
  }

  Future<void> _fetchDashboardData() async {
    setState(() {
      _isLoading = true;
    });

    final practitioner =
        await _apiService.getPractitionerDetails(widget.practitionerId);

    if (practitioner != null) {
      setState(() {
        _practitioner = practitioner;
        _isActive = practitioner.status;
        _todayBookings = practitioner.todayBookings;
        _todayRevenue = practitioner.todayRevenue;
        _isLoading = false;
      });
    } else {
      setState(() {
        _isLoading = false;
      });
      print('Failed to load practitioner details.');
    }
  }

  Future<void> _toggleActiveStatus(bool status) async {
    setState(() {
      _isActive = status;
    });

    bool success =
        await _apiService.toggleStatus(widget.practitionerId, status);
    if (!success) {
      setState(() {
        _isActive = !status;
      });
      print('Failed to update status.');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildHeader(),
              SizedBox(height: 20),
              _buildUserCard(),
              _buildStatusCard(),
              _buildBookingAndRevenueCards(),
              SizedBox(height: 20),
              _buildActionButtons(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Text(
      'Practitioner Dashboard',
      style: TextStyle(
        fontFamily: 'Lobster',
        fontSize: 28,
        color: Colors.deepPurple,
        fontWeight: FontWeight.bold,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildUserCard() {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 8,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 40,
              backgroundImage: AssetImage('assets/user_ico.png'),
            ),
            SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${_practitioner?.firstname ?? ''} ${_practitioner?.lastname ?? ''}',
                    style: TextStyle(
                      fontSize: 24,
                      fontFamily: 'Poppins',
                      color: Colors.deepPurple,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    'Professional Role: ${_practitioner?.serviceType ?? 'N/A'}',
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: 'Poppins',
                      color: Colors.grey[700],
                    ),
                  ),
                  SizedBox(height: 5),
                  Row(
                    children: [
                      Icon(Icons.phone, size: 16, color: Colors.grey[600]),
                      SizedBox(width: 5),
                      Text(
                        '${_practitioner?.mobile ?? 'N/A'}',
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                  SizedBox(height: 5),
                  Row(
                    children: [
                      Icon(Icons.email, size: 16, color: Colors.grey[600]),
                      SizedBox(width: 5),
                      Text(
                        '${_practitioner?.email ?? 'N/A'}',
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusCard() {
    return Card(
      color: Colors.tealAccent.withOpacity(0.85),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 4,
      margin: EdgeInsets.only(top: 16),
      child: ListTile(
        title: Text(
          'Active Status',
          style: TextStyle(
            fontSize: 16,
            color: Colors.black,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
          ),
        ),
        trailing: Switch(
          value: _isActive,
          onChanged: (bool value) {
            _toggleActiveStatus(value);
          },
          activeColor: Colors.green,
        ),
      ),
    );
  }

  Widget _buildBookingAndRevenueCards() {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(child: _buildInfoCard("Today's Booking", '$_todayBookings')),
          SizedBox(width: 10),
          Expanded(
              child: _buildInfoCard("Today's Revenue", '\$$_todayRevenue')),
        ],
      ),
    );
  }

  Widget _buildInfoCard(String title, String value) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 4,
      color: Colors.white.withOpacity(0.85),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 14,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 22,
                color: Colors.deepPurple,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Column(
      children: [
        _buildButtonRow(
          context,
          Icons.book,
          'My Booking',
          Icons.attach_money,
          'My Revenue',
          onTap1: fetchBookings,
          onTap2: fetchRevenue,
        ),
        _buildButtonRow(
          context,
          Icons.access_time,
          'Block Timeslot',
          Icons.calendar_today,
          'Block Date',
          onTap1: blockTimeSlot,
          onTap2: blockDate,
        ),
        _buildButtonRow(
          context,
          Icons.notifications,
          'Notification',
          Icons.logout,
          'Logout',
          onTap1: showNotifications,
          onTap2: logout,
        ),
      ],
    );
  }

  Widget _buildButtonRow(BuildContext context, IconData icon1, String text1,
      IconData icon2, String text2,
      {VoidCallback? onTap1, VoidCallback? onTap2}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildButton(context, icon1, text1, onTap: onTap1),
          SizedBox(width: 10),
          _buildButton(context, icon2, text2, onTap: onTap2),
        ],
      ),
    );
  }

  Widget _buildButton(BuildContext context, IconData icon, String text,
      {VoidCallback? onTap}) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.deepPurpleAccent.withOpacity(0.85),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                offset: Offset(0, 4),
                blurRadius: 6,
              ),
            ],
          ),
          padding: EdgeInsets.symmetric(vertical: 15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: Colors.white,
                size: 28,
              ),
              SizedBox(height: 5),
              Text(
                text,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 14,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void fetchBookings() {
    if (_practitioner != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              BookingScreen(practitionerId: widget.practitionerId),
        ),
      );
    } else {
      print("Practitioner information not loaded.");
    }
  }

  void fetchRevenue() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            RevenueScreen(practitionerId: widget.practitionerId),
      ),
    );
  }

  void blockTimeSlot() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            BlockedTimeslotScreen(practitionerId: widget.practitionerId),
      ),
    );
  }

  void blockDate() {
    // TODO: Implement functionality to block date
  }

  void showNotifications() {
    // TODO: Show notifications
  }

  void logout() {
    // TODO: Implement logout functionality
  }
}
