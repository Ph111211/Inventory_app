import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class TimestampField extends StatefulWidget {
  final String label;
  final Timestamp? initialTimestamp;
  final ValueChanged<Timestamp> onTimestampChanged;

  const TimestampField({
    super.key,
    required this.label,
    this.initialTimestamp,
    required this.onTimestampChanged,
  });

  @override
  State<TimestampField> createState() => _TimestampFieldState();
}

class _TimestampFieldState extends State<TimestampField> {
  final TextEditingController _controller = TextEditingController();
  Timestamp? _selectedTimestamp;

  @override
  void initState() {
    super.initState();
    _selectedTimestamp = widget.initialTimestamp;
    if (_selectedTimestamp != null) {
      final date = _selectedTimestamp!.toDate();
      _controller.text = DateFormat('dd/MM/yyyy HH:mm').format(date);
    }
  }

  Future<void> _pickTimestamp() async {
    final DateTime? date = await showDatePicker(
      context: context,
      initialDate: _selectedTimestamp?.toDate() ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (date == null) return;

    final TimeOfDay? time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(
        _selectedTimestamp?.toDate() ?? DateTime.now(),
      ),
    );
    if (time == null) return;

    final dateTime = DateTime(
      date.year,
      date.month,
      date.day,
      time.hour,
      time.minute,
    );

    setState(() {
      _selectedTimestamp = Timestamp.fromDate(dateTime);
      _controller.text = DateFormat('dd/MM/yyyy HH:mm').format(dateTime);
    });

    widget.onTimestampChanged(_selectedTimestamp!);
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: _controller,
      readOnly: true,
      decoration: InputDecoration(
        labelText: widget.label,
        suffixIcon: const Icon(Icons.access_time),
        border: const OutlineInputBorder(),
      ),
      onTap: _pickTimestamp,
      validator: (value) {
        if (_selectedTimestamp == null) {
          return 'Vui lòng chọn thời gian';
        }
        return null;
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
