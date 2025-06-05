import 'package:flutter/material.dart';

class StudentProfileCard extends StatefulWidget {
  final Map<String, dynamic> studentData;

  const StudentProfileCard({super.key, required this.studentData});



  @override
  State<StudentProfileCard> createState() => _StudentProfileCardState();
}

class _StudentProfileCardState extends State<StudentProfileCard> {
  bool showError = false;


  @override
  Widget build(BuildContext context) {
      final fullName = widget.studentData['fullName'] ?? {
        'firstName': 'N/A',
        'middleName': 'N/A',
        'lastName': 'N/A'
      };
    final parent = widget.studentData['parentGuardian'] ?? {
      'name': 'N/A',
      'relationship': 'N/A',
      'contactPhone': 'N/A'
    };

    final location = widget.studentData['location'] ?? {
      'village': 'N/A',
      'ward': 'N/A',
      'subCounty': 'N/A',
      'county': 'N/A'
    };


    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Student Profile', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const Divider(),
            Row(children: [
              const Icon(Icons.person, color: Colors.green),
              const SizedBox(width: 8),
              Expanded(
                child: Text('${fullName['firstName']} ${fullName['middleName']} ${fullName['lastName']}',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
              ),
            ]),
            const SizedBox(height: 8),
            Row(children: [
              const Icon(Icons.badge, color: Colors.green),
              const SizedBox(width: 8),
              Text('UPI: ${widget.studentData['upi']}'),
            ]),
            const SizedBox(height: 8),
            Row(children: [
              const Icon(Icons.cake, color: Colors.green),
              const SizedBox(width: 8),
              Text('DOB: ${widget.studentData['dateOfBirth']}'),
            ]),
            const SizedBox(height: 8),
            Row(children: [
              const Icon(Icons.flag, color: Colors.green),
              const SizedBox(width: 8),
              Text('Nationality: ${widget.studentData['nationality']}'),
            ]),
            const SizedBox(height: 8),
            Row(children: [
              const Icon(Icons.family_restroom, color: Colors.green),
              const SizedBox(width: 8),
              Text('Guardian: ${parent['name']} (${parent['relationship']})'),
            ]),
            const SizedBox(height: 8),
            Row(children: [
              const Icon(Icons.phone, color: Colors.green),
              const SizedBox(width: 8),
              Text('Phone: ${parent['contactPhone']}'),
            ]),
            const SizedBox(height: 8),
            Row(children: [
              const Icon(Icons.location_on, color: Colors.green),
              const SizedBox(width: 8),
              Expanded(
                child: Text('Location: ${location['village']}, ${location['ward']}, ${location['subCounty']}, ${location['county']}'),
              ),
            ]),
          ],
        ),
      ),
    );
  }
}
