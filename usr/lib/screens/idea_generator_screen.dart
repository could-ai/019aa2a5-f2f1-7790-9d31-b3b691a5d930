import 'package:flutter/material.dart';
import 'dart:math';

class IdeaGeneratorScreen extends StatefulWidget {
  const IdeaGeneratorScreen({super.key});

  @override
  State<IdeaGeneratorScreen> createState() => _IdeaGeneratorScreenState();
}

class _IdeaGeneratorScreenState extends State<IdeaGeneratorScreen> {
  final TextEditingController _controller = TextEditingController();
  String? _generatedIdea;
  bool _isGenerating = false;

  // Mock AI responses for demo purposes
  final List<String> _prefixes = [
    "A revolutionary",
    "An eco-friendly",
    "A minimal",
    "A futuristic",
    "A user-centric",
    "An AI-powered"
  ];

  final List<String> _actions = [
    "platform that optimizes",
    "device that enhances",
    "app that gamifies",
    "system that automates",
    "tool that simplifies"
  ];

  void _generateIdea() async {
    if (_controller.text.isEmpty) return;

    setState(() {
      _isGenerating = true;
      _generatedIdea = null;
    });

    // Simulate network delay
    await Future.delayed(const Duration(seconds: 2));

    final random = Random();
    final prefix = _prefixes[random.nextInt(_prefixes.length)];
    final action = _actions[random.nextInt(_actions.length)];
    final input = _controller.text.trim();

    setState(() {
      _isGenerating = false;
      _generatedIdea = "$prefix $input $action daily life, featuring a modular design and intuitive interface.";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Idea Generator'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'What do you want to create?',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              'Enter a subject or object, and we will design a concept for you.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey),
            ),
            const SizedBox(height: 24),
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: 'e.g., Coffee Machine, Social Network, Flying Car',
                filled: true,
                fillColor: Colors.white.withOpacity(0.05),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                prefixIcon: const Icon(Icons.edit),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _isGenerating ? null : _generateIdea,
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: _isGenerating
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                    )
                  : const Text('Generate Concept'),
            ),
            const SizedBox(height: 40),
            if (_generatedIdea != null)
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondaryContainer.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.auto_awesome, color: Theme.of(context).colorScheme.primary),
                        const SizedBox(width: 8),
                        Text(
                          'Generated Concept',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                color: Theme.of(context).colorScheme.primary,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      _generatedIdea!,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            height: 1.5,
                            fontSize: 18,
                          ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
