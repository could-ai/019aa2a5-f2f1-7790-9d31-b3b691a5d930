import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

class TriviaScreen extends StatefulWidget {
  const TriviaScreen({super.key});

  @override
  State<TriviaScreen> createState() => _TriviaScreenState();
}

// Enum for different game modes
enum GameMode { multipleChoice, trueFalse }

class _TriviaScreenState extends State<TriviaScreen> {
  // Mock Data
  final List<Map<String, dynamic>> _categories = [
    {'name': 'Science', 'icon': Icons.science, 'color': Colors.blueAccent},
    {'name': 'History', 'icon': Icons.history_edu, 'color': Colors.orangeAccent},
    {'name': 'Tech', 'icon': Icons.computer, 'color': Colors.greenAccent},
    {'name': 'Art', 'icon': Icons.palette, 'color': Colors.purpleAccent},
    {'name': 'Literature', 'icon': Icons.book, 'color': Colors.redAccent},
    {'name': 'Math', 'icon': Icons.calculate, 'color': Colors.tealAccent},
  ];

  final Map<String, List<Map<String, dynamic>>> _questions = {
    'Science': [
      {
        'question': 'What is the chemical symbol for Gold?',
        'options': ['Au', 'Ag', 'Fe', 'Pb'],
        'answer': 0,
        'type': GameMode.multipleChoice,
      },
      {
        'question': 'The Earth is flat.',
        'options': ['True', 'False'],
        'answer': 1,
        'type': GameMode.trueFalse,
      },
      {
        'question': 'What planet is known as the Red Planet?',
        'options': ['Venus', 'Mars', 'Jupiter', 'Saturn'],
        'answer': 1,
        'type': GameMode.multipleChoice,
      },
    ],
    'History': [
      {
        'question': 'Who wrote the Declaration of Independence?',
        'options': ['George Washington', 'Benjamin Franklin', 'Thomas Jefferson', 'John Adams'],
        'answer': 2,
        'type': GameMode.multipleChoice,
      },
      {
        'question': 'World War II ended in 1945.',
        'options': ['True', 'False'],
        'answer': 0,
        'type': GameMode.trueFalse,
      },
    ],
    'Tech': [
      {
        'question': 'What does CPU stand for?',
        'options': ['Central Process Unit', 'Central Processing Unit', 'Computer Personal Unit', 'Central Processor Unit'],
        'answer': 1,
        'type': GameMode.multipleChoice,
      },
      {
        'question': 'The first computer mouse was made of wood.',
        'options': ['True', 'False'],
        'answer': 0,
        'type': GameMode.trueFalse,
      },
    ],
    'Art': [
      {
        'question': 'Who painted the Mona Lisa?',
        'options': ['Van Gogh', 'Da Vinci', 'Picasso', 'Michelangelo'],
        'answer': 1,
        'type': GameMode.multipleChoice,
      },
    ],
    'Literature': [
      {
        'question': 'Who wrote "To Kill a Mockingbird"?',
        'options': ['Harper Lee', 'J.K. Rowling', 'Ernest Hemingway', 'Mark Twain'],
        'answer': 0,
        'type': GameMode.multipleChoice,
      },
      {
        'question': 'Sherlock Holmes was a real detective.',
        'options': ['True', 'False'],
        'answer': 1,
        'type': GameMode.trueFalse,
      },
    ],
    'Math': [
      {
        'question': 'What is 12 * 12?',
        'options': ['144', '124', '168', '132'],
        'answer': 0,
        'type': GameMode.multipleChoice,
      },
      {
        'question': 'Pi (π) is a rational number.',
        'options': ['True', 'False'],
        'answer': 1,
        'type': GameMode.trueFalse,
      },
    ],
  };

  String? _selectedCategory;
  GameMode? _selectedGameMode;
  List<Map<String, dynamic>> _shuffledQuestions = [];
  int _currentQuestionIndex = 0;
  int _score = 0;
  int _streak = 0;
  bool _quizFinished = false;
  
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
    });
  }

  void _selectGameMode(GameMode mode) {
    final allQuestions = _questions[_selectedCategory]!;
    final filteredQuestions = allQuestions.where((q) => q['type'] == mode).toList();
    
    // Shuffle questions for variety
    filteredQuestions.shuffle(Random());

    setState(() {
      _selectedGameMode = mode;
      _shuffledQuestions = filteredQuestions;
      _currentQuestionIndex = 0;
      _score = 0;
      _streak = 0;
      _quizFinished = false;
    });
    _startTimer();
  }

  void _answerQuestion(int selectedIndex) {
    _timer?.cancel();
    
    final correctIndex = _shuffledQuestions[_currentQuestionIndex]['answer'];
    
    bool isCorrect = selectedIndex == correctIndex;

    if (isCorrect) {
      _score += 10 + (_streak * 2);
      _streak++;
    } else {
      _streak = 0;
    }
    
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        if (_currentQuestionIndex < _shuffledQuestions.length - 1) {
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
      _selectedGameMode = null;
      _quizFinished = false;
      _score = 0;
      _streak = 0;
      _currentQuestionIndex = 0;
      _shuffledQuestions = [];
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
          if (_selectedGameMode != null && !_quizFinished)
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
      body: _buildContent(),
    );
  }

  Widget _buildContent() {
    if (_selectedCategory == null) {
      return _buildCategoryList();
    } else if (_selectedGameMode == null) {
      return _buildGameModeSelection();
    } else {
      return _buildQuizView();
    }
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

  Widget _buildGameModeSelection() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Select a Game Mode',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            icon: const Icon(Icons.list_alt),
            label: const Text('Multiple Choice'),
            onPressed: () => _selectGameMode(GameMode.multipleChoice),
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(200, 50),
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            icon: const Icon(Icons.check_circle_outline),
            label: const Text('True / False'),
            onPressed: () => _selectGameMode(GameMode.trueFalse),
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(200, 50),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuizView() {
    if (_quizFinished) {
      return _buildQuizFinishedView();
    }
    
    if (_shuffledQuestions.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.search_off, size: 60, color: Colors.grey),
            const SizedBox(height: 16),
            Text(
              'No questions available for this mode.',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _resetQuiz,
              child: const Text('Choose Another Category'),
            ),
          ],
        ),
      );
    }

    final currentQuestion = _shuffledQuestions[_currentQuestionIndex];

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: (_currentQuestionIndex + 1) / _shuffledQuestions.length,
              backgroundColor: Colors.grey[800],
              valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).colorScheme.primary),
              minHeight: 8,
            ),
          ),
          const SizedBox(height: 24),
          
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildTimerChip(),
              if (_streak > 1) _buildStreakChip(),
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
          ..._buildOptions(currentQuestion),
        ],
      ),
    );
  }

  Widget _buildQuizFinishedView() {
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
            'Questions: ${_shuffledQuestions.length}',
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

  List<Widget> _buildOptions(Map<String, dynamic> question) {
    final options = question['options'] as List;
    return List.generate(
      options.length,
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
            options[index],
            style: const TextStyle(fontSize: 16, color: Colors.white),
          ),
        ),
      ),
    );
  }

  Widget _buildTimerChip() {
    final color = _timeLeft < 5 ? Colors.red : Colors.white;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.5)),
      ),
      child: Row(
        children: [
          Icon(Icons.timer, size: 16, color: color),
          const SizedBox(width: 6),
          Text(
            '$_timeLeft s',
            style: TextStyle(fontWeight: FontWeight.bold, color: color),
          ),
        ],
      ),
    );
  }

  Widget _buildStreakChip() {
    return Container(
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
    );
  }
}
