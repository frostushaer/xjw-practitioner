import 'package:flutter/material.dart';
import '../services/api_service.dart';

class AddBlockedDatesScreen extends StatefulWidget {
  final String practitionerId;

  AddBlockedDatesScreen({required this.practitionerId});

  @override
  _AddBlockedDatesScreenState createState() => _AddBlockedDatesScreenState();
}

class _AddBlockedDatesScreenState extends State<AddBlockedDatesScreen> {
  final ApiService _apiService = ApiService();
  final _formKey = GlobalKey<FormState>();

  DateTime? _startDate;
  DateTime? _endDate;
  String _status = '1'; // Default status as active

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 1),
    );
    if (pickedDate != null) {
      setState(() {
        if (isStartDate) {
          _startDate = pickedDate;
          if (_endDate != null && _startDate!.isAfter(_endDate!)) {
            _endDate = _startDate; // Adjust end date if needed
          }
        } else {
          _endDate = pickedDate;
          if (_startDate != null && _endDate!.isBefore(_startDate!)) {
            _startDate = _endDate; // Adjust start date if needed
          }
        }
      });
    }
  }

  Future<void> _blockDates() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final startDate = _startDate!.toIso8601String().split('T')[0];
      final endDate = _endDate!.toIso8601String().split('T')[0];

      bool success = await _apiService.addBlockedDate(
          startDate, endDate, _status, widget.practitionerId);

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Dates blocked successfully')),
        );
        Navigator.pop(context, true); // Indicate success to parent screen
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to block dates')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Blocked Dates'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Start Date'),
                readOnly: true,
                onTap: () => _selectDate(context, true),
                controller: TextEditingController(
                  text: _startDate == null
                      ? ''
                      : _startDate!.toLocal().toString().split(' ')[0],
                ),
                validator: (value) =>
                    value!.isEmpty ? 'Please select a start date' : null,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'End Date'),
                readOnly: true,
                onTap: () => _selectDate(context, false),
                controller: TextEditingController(
                  text: _endDate == null
                      ? ''
                      : _endDate!.toLocal().toString().split(' ')[0],
                ),
                validator: (value) =>
                    value!.isEmpty ? 'Please select an end date' : null,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _blockDates,
                child: Text('Block Dates'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
