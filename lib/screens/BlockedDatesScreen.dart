import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'AddBlockedDatesScreen.dart';

class BlockedDatesScreen extends StatefulWidget {
  final String practitionerId;

  BlockedDatesScreen({required this.practitionerId});

  @override
  _BlockedDatesScreenState createState() => _BlockedDatesScreenState();
}

class _BlockedDatesScreenState extends State<BlockedDatesScreen> {
  final ApiService _apiService = ApiService();
  List<Map<String, dynamic>> _blockedDates = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadBlockedDates();
  }

  Future<void> _loadBlockedDates() async {
    setState(() {
      _isLoading = true;
    });
    _blockedDates = await _apiService.getBlockedDates();
    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _deleteDate(String id) async {
    bool success = await _apiService.deleteBlockedDate(id);
    if (success) {
      _loadBlockedDates();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Date blocked record deleted successfully')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete date block')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Blocked Dates'),
        backgroundColor: Colors.deepPurple,
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () async {
              bool? result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddBlockedDatesScreen(
                    practitionerId: widget.practitionerId,
                  ),
                ),
              );

              if (result == true) {
                _loadBlockedDates();
              }
            },
          ),
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _blockedDates.isEmpty
              ? Center(child: Text("No blocked dates found."))
              : ListView.builder(
                  itemCount: _blockedDates.length,
                  itemBuilder: (context, index) {
                    final dateBlock = _blockedDates[index];
                    return ListTile(
                      title: Text('Start: ${dateBlock['start_date']}'),
                      subtitle: Text('End: ${dateBlock['end_date']}'),
                      trailing: IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () =>
                            _deleteDate(dateBlock['id'].toString()),
                      ),
                    );
                  },
                ),
    );
  }
}
