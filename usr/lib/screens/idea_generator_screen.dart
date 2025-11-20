import 'package:flutter/material.dart';
import 'dart:math';

class IdeaGeneratorScreen extends StatefulWidget {
  const IdeaGeneratorScreen({super.key});

  @override
  State<IdeaGeneratorScreen> createState() => _IdeaGeneratorScreenState();
}

class _IdeaGeneratorScreenState extends State<IdeaGeneratorScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  
  String? _generatedIdea;
  bool _isGenerating = false;
  
  // Local history of generated ideas
  final List<String> _savedIdeas = [];

  // Mock AI responses for demo purposes
  final List<String> _prefixes = [
    "A revolutionary",
    "An eco-friendly",
    "A minimal",
    "A futuristic",
    "A user-centric",
    "An AI-powered",
    "A blockchain-based",
    "A community-driven"
  ];

  final List<String> _actions = [
    "platform that optimizes",
    "device that enhances",
    "app that gamifies",
    "system that automates",
    "tool that simplifies",
    "network that connects",
    "assistant that manages"
  ];
  
  final List<String> _features = [
    "featuring a modular design.",
    "with an intuitive voice interface.",
    "using advanced machine learning.",
    "built for the metaverse.",
    "designed for remote work.",
    "focused on sustainability."
  ];

  void _generateIdea() async {
    if (_controller.text.isEmpty) return;
    
    // Dismiss keyboard
    FocusScope.of(context).unfocus();

    setState(() {
      _isGenerating = true;
      _generatedIdea = null;
    });

    // Simulate network delay
    await Future.delayed(const Duration(seconds: 2));

    final random = Random();
    final prefix = _prefixes[random.nextInt(_prefixes.length)];
    final action = _actions[random.nextInt(_actions.length)];
    final feature = _features[random.nextInt(_features.length)];
    final input = _controller.text.trim();

    final newIdea = "$prefix $input $action daily life, $feature";

    setState(() {
      _isGenerating = false;
      _generatedIdea = newIdea;
      _savedIdeas.insert(0, newIdea); // Add to history
    });
    
    // Scroll to top of history if needed
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Idea Generator'),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              controller: _scrollController,
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
                      hintText: 'e.g., Coffee Machine, Social Network',
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.05),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      prefixIcon: const Icon(Icons.edit),
                    ),
                    onSubmitted: (_) => _isGenerating ? null : _generateIdea(),
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
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                              ),
                              const SizedBox(width: 12),
                              const Text('Designing...'),
                            ],
                          )
                        : const Text('Generate Concept'),
                  ),
                  const SizedBox(height: 40),
                  
                  // Current Result
                  if (_generatedIdea != null)
                    _buildResultCard(context, _generatedIdea!, isLatest: true),
                    
                  // History Section
                  if (_savedIdeas.length > 1) ...[
                    const SizedBox(height: 32),
                    Row(
                      children: [
                        const Icon(Icons.history, size: 20, color: Colors.grey),
                        const SizedBox(width: 8),
                        Text(
                          'Recent Concepts',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                color: Colors.grey,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    ..._savedIdeas.skip(1).map((idea) => Padding(
                      padding: const EdgeInsets.only(bottom: 12.0),
                      child: _buildResultCard(context, idea, isLatest: false),
                    )),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultCard(BuildContext context, String idea, {required bool isLatest}) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isLatest 
            ? Theme.of(context).colorScheme.secondaryContainer.withOpacity(0.2)
            : Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isLatest 
              ? Theme.of(context).colorScheme.primary.withOpacity(0.3)
              : Colors.white.withOpacity(0.1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                isLatest ? Icons.auto_awesome : Icons.lightbulb_outline, 
                color: isLatest ? Theme.of(context).colorScheme.primary : Colors.grey,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                isLatest ? 'Generated Concept' : 'Saved Concept',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: isLatest ? Theme.of(context).colorScheme.primary : Colors.grey,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            idea,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  height: 1.5,
                  fontSize: isLatest ? 18 : 16,
                  color: isLatest ? Colors.white : Colors.white70,
                ),
          ),
        ],
      ),
    );
  }
}
