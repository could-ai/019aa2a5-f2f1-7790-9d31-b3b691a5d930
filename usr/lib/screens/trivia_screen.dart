import 'package:flutter/material.dart';

class TriviaScreen extends StatefulWidget {
  const TriviaScreen({super.key});

  @override
  State<TriviaScreen> createState() => _TriviaScreenState();
}

class _TriviaScreenState extends State<TriviaScreen> {
  // Mock Data
  final List<Map<String, dynamic>> _categories = [
    {'name': 'Science', 'icon': Icons.science, 'color': Colors.blueAccent},
    {'name': 'History', 'icon': Icons.history_edu, 'color': Colors.orangeAccent},
    {'name': 'Tech', 'icon': Icons.computer, 'color': Colors.greenAccent},
    {'name': 'Art', 'icon': Icons.palette, 'color': Colors.purpleAccent},
  ];

  final Map<String, List<Map<String, dynamic>>> _questions = {
    'Science': [
      {
        'question': 'What is the chemical symbol for Gold?',
        'options': ['Au', 'Ag', 'Fe', 'Pb'],
        'answer': 0
      },
      {
        'question': 'What planet is known as the Red Planet?',
        'options': ['Venus', 'Mars', 'Jupiter', 'Saturn'],
        'answer': 1
      },
    ],
    'History': [
      {
        'question': 'Who wrote the Declaration of Independence?',
        'options': ['George Washington', 'Benjamin Franklin', 'Thomas Jefferson', 'John Adams'],
        'answer': 2
      },
    ],
    'Tech': [
      {
        'question': 'What does CPU stand for?',
        'options': ['Central Process Unit', 'Central Processing Unit', 'Computer Personal Unit', 'Central Processor Unit'],
        'answer': 1
      },
    ],
    'Art': [
      {
        'question': 'Who painted the Mona Lisa?',
        'options': ['Van Gogh', 'Da Vinci', 'Picasso', 'Michelangelo'],
        'answer': 1
      },
    ],
  };

  String? _selectedCategory;
  int _currentQuestionIndex = 0;
  int _score = 0;
  bool _quizFinished = false;

  void _selectCategory(String category) {
    setState(() {
      _selectedCategory = category;
      _currentQuestionIndex = 0;
      _score = 0;
      _quizFinished = false;
    });
  }

  void _answerQuestion(int selectedIndex) {
    final currentQuestions = _questions[_selectedCategory]!;
    if (selectedIndex == currentQuestions[_currentQuestionIndex]['answer']) {
      _score++;
    }

    if (_currentQuestionIndex < currentQuestions.length - 1) {
      setState(() {
        _currentQuestionIndex++;
      });
    } else {
      setState(() {
        _quizFinished = true;
      });
    }
  }

  void _resetQuiz() {
    setState(() {
      _selectedCategory = null;
      _quizFinished = false;
      _score = 0;
      _currentQuestionIndex = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_selectedCategory ?? 'Trivia Challenge'),
        leading: _selectedCategory != null
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: _resetQuiz,
              )
            : const BackButton(),
      ),
      body: _selectedCategory == null ? _buildCategoryList() : _buildQuizView(),
    );
  }

  Widget _buildCategoryList() {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1.1,
      ),
      itemCount: _categories.length,
      itemBuilder: (context, index) {
        final category = _categories[index];
        return InkWell(
          onTap: () => _selectCategory(category['name']),
          borderRadius: BorderRadius.circular(16),
          child: Container(
            decoration: BoxDecoration(
              color: (category['color'] as Color).withOpacity(0.2),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: (category['color'] as Color).withOpacity(0.5)),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(category['icon'], size: 48, color: category['color']),
                const SizedBox(height: 12),
                Text(
                  category['name'],
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildQuizView() {
    if (_quizFinished) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.emoji_events, size: 80, color: Colors.amber),
            const SizedBox(height: 24),
            Text(
              'Quiz Complete!',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 16),
            Text(
              'You scored $_score / ${_questions[_selectedCategory]!.length}',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                  ),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: _resetQuiz,
              child: const Text('Play Again'),
            ),
          ],
        ),
      );
    }

    final currentQuestion = _questions[_selectedCategory]![_currentQuestionIndex];

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          LinearProgressIndicator(
            value: (_currentQuestionIndex + 1) / _questions[_selectedCategory]!.length,
            backgroundColor: Colors.grey[800],
            valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).colorScheme.primary),
          ),
          const SizedBox(height: 32),
          Text(
            'Question ${_currentQuestionIndex + 1}',
            style: Theme.of(context).textTheme.labelLarge?.copyWith(color: Colors.grey),
          ),
          const SizedBox(height: 8),
          Text(
            currentQuestion['question'],
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 32),
          ...List.generate(
            (currentQuestion['options'] as List).length,
            (index) => Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: OutlinedButton(
                onPressed: () => _answerQuestion(index),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                  alignment: Alignment.centerLeft,
                  side: BorderSide(color: Colors.grey.shade700),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: Text(
                  currentQuestion['options'][index],
                  style: const TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
