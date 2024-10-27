import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/practitioner_model.dart';

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

    // Fetch practitioner details
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
        _isActive = !status; // Revert if update fails
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
      body: Stack(
        children: [
          // Background image and overlay
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                    'assets/app_login_bg.PNG'), // Ensure this image path is correct
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Opacity overlay for text readability
          Container(
            color: Colors.black.withOpacity(0.5),
          ),
          SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
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
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Center(
      child: Text(
        'Practitioner Dashboard',
        style: TextStyle(
          fontFamily: 'Lobster',
          fontSize: 28,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildUserCard() {
    return Card(
      color: Colors.white.withOpacity(0.9),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 6,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundImage: AssetImage('assets/user_ico.png'),
            ),
            SizedBox(width: 15),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Hi, ${_practitioner?.firstname ?? ''}',
                  style: TextStyle(
                    fontSize: 18,
                    fontFamily: 'Lobster',
                    color: Colors.grey[700],
                  ),
                ),
                Text(
                  _practitioner?.lastname ?? '',
                  style: TextStyle(
                    fontSize: 20,
                    fontFamily: 'Lobster',
                    color: Colors.blueAccent,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusCard() {
    return Card(
      color: Colors.blueAccent.withOpacity(0.85),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 4,
      margin: EdgeInsets.only(top: 16),
      child: ListTile(
        title: Text(
          'Active Status',
          style: TextStyle(
            fontSize: 16,
            color: Colors.white,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
          ),
        ),
        trailing: Switch(
          value: _isActive,
          onChanged: (bool value) {
            _toggleActiveStatus(value);
          },
          activeColor: Colors.greenAccent,
        ),
      ),
    );
  }

  Widget _buildBookingAndRevenueCards() {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Row(
        children: [
          Expanded(
              child: _buildInfoCard('Today\'s Booking', '$_todayBookings')),
          SizedBox(width: 10),
          Expanded(
              child: _buildInfoCard('Today\'s Revenue', '\$$_todayRevenue')),
        ],
      ),
    );
  }

  Widget _buildInfoCard(String title, String value) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
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
                color: Colors.blueAccent,
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
            borderRadius: BorderRadius.circular(15),
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

  // Placeholder functions for buttons
  void fetchBookings() {
    // TODO: Implement API call to fetch bookings
  }

  void fetchRevenue() {
    // TODO: Implement API call to fetch revenue details
  }

  void blockTimeSlot() {
    // TODO: Implement functionality to block timeslot
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
