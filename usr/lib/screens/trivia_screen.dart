import 'package:flutter/material.dart';
import 'dart:async';

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
      {
        'question': 'What is the hardest natural substance on Earth?',
        'options': ['Gold', 'Iron', 'Diamond', 'Platinum'],
        'answer': 2
      },
    ],
    'History': [
      {
        'question': 'Who wrote the Declaration of Independence?',
        'options': ['George Washington', 'Benjamin Franklin', 'Thomas Jefferson', 'John Adams'],
        'answer': 2
      },
      {
        'question': 'In which year did World War II end?',
        'options': ['1945', '1939', '1918', '1950'],
        'answer': 0
      },
    ],
    'Tech': [
      {
        'question': 'What does CPU stand for?',
        'options': ['Central Process Unit', 'Central Processing Unit', 'Computer Personal Unit', 'Central Processor Unit'],
        'answer': 1
      },
      {
        'question': 'Which company created the iPhone?',
        'options': ['Microsoft', 'Google', 'Apple', 'Samsung'],
        'answer': 2
      },
    ],
    'Art': [
      {
        'question': 'Who painted the Mona Lisa?',
        'options': ['Van Gogh', 'Da Vinci', 'Picasso', 'Michelangelo'],
        'answer': 1
      },
      {
        'question': 'What art movement is Salvador Dali associated with?',
        'options': ['Impressionism', 'Surrealism', 'Cubism', 'Realism'],
        'answer': 1
      },
    ],
  };

  String? _selectedCategory;
  int _currentQuestionIndex = 0;
  int _score = 0;
  int _streak = 0;
  bool _quizFinished = false;
  
  // Timer logic
  Timer? _timer;
  int _timeLeft = 15;
  static const int _maxTime = 15;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer?.cancel();
    setState(() {
      _timeLeft = _maxTime;
    });
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timeLeft > 0) {
        setState(() {
          _timeLeft--;
        });
      } else {
        _answerQuestion(-1); // Time out
      }
    });
  }

  void _selectCategory(String category) {
    setState(() {
      _selectedCategory = category;
      _currentQuestionIndex = 0;
      _score = 0;
      _streak = 0;
      _quizFinished = false;
    });
    _startTimer();
  }

  void _answerQuestion(int selectedIndex) {
    _timer?.cancel();
    
    final currentQuestions = _questions[_selectedCategory]!;
    final correctIndex = currentQuestions[_currentQuestionIndex]['answer'];
    
    bool isCorrect = selectedIndex == correctIndex;

    if (isCorrect) {
      _score += 10 + (_streak * 2); // Bonus for streaks
      _streak++;
    } else {
      _streak = 0;
    }

    // Show feedback dialog or delay before next question could be added here
    // For now, we proceed immediately or after a short delay
    
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        if (_currentQuestionIndex < currentQuestions.length - 1) {
          setState(() {
            _currentQuestionIndex++;
          });
          _startTimer();
        } else {
          setState(() {
            _quizFinished = true;
          });
        }
      }
    });
  }

  void _resetQuiz() {
    _timer?.cancel();
    setState(() {
      _selectedCategory = null;
      _quizFinished = false;
      _score = 0;
      _streak = 0;
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
        actions: [
          if (_selectedCategory != null && !_quizFinished)
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Center(
                child: Text(
                  'Score: $_score',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
            )
        ],
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
              'Final Score: $_score',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
            ),
             const SizedBox(height: 8),
            Text(
              'Questions: ${_questions[_selectedCategory]!.length}',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: _resetQuiz,
              icon: const Icon(Icons.replay),
              label: const Text('Play Again'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              ),
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
          // Progress Bar
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: (_currentQuestionIndex + 1) / _questions[_selectedCategory]!.length,
              backgroundColor: Colors.grey[800],
              valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).colorScheme.primary),
              minHeight: 8,
            ),
          ),
          const SizedBox(height: 24),
          
          // Timer and Streak Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: _timeLeft < 5 ? Colors.red.withOpacity(0.2) : Colors.grey.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: _timeLeft < 5 ? Colors.red : Colors.grey,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(Icons.timer, size: 16, color: _timeLeft < 5 ? Colors.red : Colors.white),
                    const SizedBox(width: 6),
                    Text(
                      '$_timeLeft s',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: _timeLeft < 5 ? Colors.red : Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              if (_streak > 1)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.orange.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.orange),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.local_fire_department, size: 16, color: Colors.orange),
                      const SizedBox(width: 6),
                      Text(
                        'Streak: $_streak',
                        style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.orange),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          
          const SizedBox(height: 24),
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
                  backgroundColor: Colors.white.withOpacity(0.05),
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
