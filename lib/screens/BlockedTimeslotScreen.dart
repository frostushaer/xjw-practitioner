import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'AddBlockedTimeslotScreen.dart';

class BlockedTimeslotScreen extends StatefulWidget {
  final String practitionerId;

  BlockedTimeslotScreen({required this.practitionerId});

  @override
  _BlockedTimeslotScreenState createState() => _BlockedTimeslotScreenState();
}

class _BlockedTimeslotScreenState extends State<BlockedTimeslotScreen> {
  final ApiService _apiService = ApiService();
  List<Map<String, dynamic>> _blockedTimeslots = [];

  @override
  void initState() {
    super.initState();
    _loadBlockedTimeslots();
  }

  Future<void> _loadBlockedTimeslots() async {
    _blockedTimeslots = await _apiService.getBlockedTimeslots();
    setState(() {});
  }

  Future<void> _deleteTimeslot(String id) async {
    bool success = await _apiService.deleteBlockedTimeslot(id);
    if (success) {
      _loadBlockedTimeslots();
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Timeslot deleted successfully')));
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Failed to delete timeslot')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Blocked Timeslots'),
        backgroundColor: Colors.deepPurple,
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () async {
              bool? result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddBlockedTimeslotScreen(
                    practitionerId: widget.practitionerId,
                  ),
                ),
              );

              if (result == true) {
                _loadBlockedTimeslots();
              }
            },
          ),
        ],
      ),
      body: _blockedTimeslots.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _blockedTimeslots.length,
              itemBuilder: (context, index) {
                final timeslot = _blockedTimeslots[index];
                return ListTile(
                  title: Text(timeslot['service_name']),
                  subtitle: Text(
                      'Duration: ${timeslot['duration']} | Timeslot: ${timeslot['timeslot']}'),
                  trailing: IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _deleteTimeslot(timeslot['id'].toString()),
                  ),
                );
              },
            ),
    );
  }
}
