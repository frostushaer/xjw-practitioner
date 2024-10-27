import 'package:flutter/material.dart';
import '../services/api_service.dart';

class RevenueScreen extends StatefulWidget {
  final String practitionerId;

  RevenueScreen({required this.practitionerId});

  @override
  _RevenueScreenState createState() => _RevenueScreenState();
}

class _RevenueScreenState extends State<RevenueScreen> {
  final ApiService _apiService = ApiService();
  bool _isLoading = true;
  double _totalRevenue = 0.0;

  @override
  void initState() {
    super.initState();
    _fetchTotalRevenue();
  }

  Future<void> _fetchTotalRevenue() async {
    setState(() {
      _isLoading = true;
    });

    final totalRevenue =
        await _apiService.getTotalRevenue(widget.practitionerId);

    setState(() {
      _totalRevenue = totalRevenue ?? 0.0;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Total Revenue'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Center(
        child: _isLoading
            ? CircularProgressIndicator()
            : _totalRevenue == 0.0
                ? Text(
                    'No revenue data available for this practitioner.',
                    style: TextStyle(fontSize: 18, color: Colors.grey[700]),
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Total Revenue:',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[700],
                        ),
                      ),
                      SizedBox(height: 20),
                      Text(
                        '\$$_totalRevenue',
                        style: TextStyle(
                          fontSize: 40,
                          color: Colors.deepPurple,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
      ),
    );
  }
}
