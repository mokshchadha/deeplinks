import 'package:flutter/material.dart';

class CandidatePage extends StatelessWidget {
  final String candidateId;

  const CandidatePage({Key? key, required this.candidateId}) : super(key: key);

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
