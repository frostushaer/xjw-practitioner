import 'package:flutter/material.dart';
import '../services/api_service.dart';

class AddBlockedTimeslotScreen extends StatefulWidget {
  final String practitionerId;

  AddBlockedTimeslotScreen({required this.practitionerId});

  @override
  _AddBlockedTimeslotScreenState createState() =>
      _AddBlockedTimeslotScreenState();
}

class _AddBlockedTimeslotScreenState extends State<AddBlockedTimeslotScreen> {
  final ApiService _apiService = ApiService();
  final _formKey = GlobalKey<FormState>();

  List<String> _services = [];
  List<String> _durations = [];
  String? _selectedService;
  String? _selectedDuration;
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  String _status = '1';

  @override
  void initState() {
    super.initState();
    _loadServicesAndDurations();
  }

  Future<void> _loadServicesAndDurations() async {
    _services = await _apiService.getServiceNames();
    _durations = await _apiService.getDurations();
    setState(() {});
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 1),
    );
    if (picked != null) setState(() => _selectedDate = picked);
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) setState(() => _selectedTime = picked);
  }

  Future<void> _blockTimeslot() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      String date = _selectedDate!.toIso8601String().split('T')[0];
      String time = _selectedTime!.format(context);

      bool success = await _apiService.addBlockedTimeslot(
        _selectedService!,
        _selectedDuration!,
        date,
        time,
        _status,
        widget.practitionerId,
      );

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Timeslot blocked successfully')));
        Navigator.pop(context, true); // Return true on success
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Failed to block timeslot')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Blocked Timeslot'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              DropdownButtonFormField<String>(
                decoration: InputDecoration(labelText: 'Service Name'),
                items: _services
                    .map((service) =>
                        DropdownMenuItem(value: service, child: Text(service)))
                    .toList(),
                onChanged: (value) => _selectedService = value,
                validator: (value) =>
                    value == null ? 'Please select a service' : null,
              ),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(labelText: 'Duration'),
                items: _durations
                    .map((duration) => DropdownMenuItem(
                        value: duration, child: Text(duration)))
                    .toList(),
                onChanged: (value) => _selectedDuration = value,
                validator: (value) =>
                    value == null ? 'Please select a duration' : null,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Date'),
                readOnly: true,
                onTap: () => _selectDate(context),
                controller: TextEditingController(
                  text: _selectedDate == null
                      ? ''
                      : _selectedDate!.toLocal().toString().split(' ')[0],
                ),
                validator: (value) =>
                    value!.isEmpty ? 'Please select a date' : null,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Time'),
                readOnly: true,
                onTap: () => _selectTime(context),
                controller: TextEditingController(
                  text: _selectedTime == null
                      ? ''
                      : _selectedTime!.format(context),
                ),
                validator: (value) =>
                    value!.isEmpty ? 'Please select a time' : null,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _blockTimeslot,
                child: Text('Block Timeslot'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
