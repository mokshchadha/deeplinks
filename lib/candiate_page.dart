import 'package:flutter/material.dart';

class CandidatePage extends StatelessWidget {
  final String candidateId;

  const CandidatePage({super.key, required this.candidateId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Candidate Page'),
      ),
      body: Center(
        child: Text('Candidate ID: $candidateId'),
      ),
    );
  }
}
