import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class QuizScreen extends StatefulWidget {
  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  List<dynamic> _questions = [];
  bool _isLoading = true;
  String? _errorMessage;
  int _currentQuestionIndex = 0;
  bool _isAnswered = false;
  String? _selectedAnswer;
  String? _correctAnswer;
  int _score = 0;  // Punteggio

  @override
  void initState() {
    super.initState();
    _loadQuestions();
  }

  // Carica le domande dal file JSON
  Future<void> _loadQuestions() async {
    try {
      String jsonString = await rootBundle.loadString('assets/questions.json');
      final Map<String, dynamic> jsonData = json.decode(jsonString);
      setState(() {
        _questions = jsonData['questions'];
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Errore nel caricamento del file JSON: $e';
      });
    }
  }

  // Funzione per passare alla domanda successiva
  void _nextQuestion() {
    setState(() {
      _isAnswered = false;
      _selectedAnswer = null;
      _correctAnswer = null;
      _currentQuestionIndex++;
    });
  }

  // Funzione per terminare il quiz e mostrare il punteggio
  void _finishQuiz() {
    int passingScore = 18; // Punteggio minimo per passare
    String resultMessage = _score >= passingScore
        ? 'Complimenti, hai superato il quiz con $_score punti su ${_questions.length}!'
        : 'Mi dispiace, non hai superato il quiz. Hai totalizzato $_score punti su ${_questions.length}.';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Punteggio finale'),
          content: Text(resultMessage),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                setState(() {
                  _currentQuestionIndex = 0;
                  _score = 0;  // Reset punteggio per una nuova sessione
                  _isAnswered = false;
                  _selectedAnswer = null;
                  _correctAnswer = null;
                });
              },
              child: Text('Ricomincia'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Chiudi'),
            ),
          ],
        );
      },
    );
  }

  // Verifica se la risposta selezionata è corretta
  void _checkAnswer(String selectedAnswer, String correctAnswer) {
    setState(() {
      _isAnswered = true;
      _selectedAnswer = selectedAnswer;
      _correctAnswer = correctAnswer;
      if (selectedAnswer == correctAnswer) {
        _score++;  // Incrementa il punteggio per risposta corretta
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Quiz', style: TextStyle(fontWeight: FontWeight.bold))),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _errorMessage != null
              ? Center(child: Text(_errorMessage!))
              : _currentQuestionIndex < _questions.length
                  ? _buildQuestionScreen()
                  : Center(child: Text('Hai completato il quiz!')),
    );
  }

  // Funzione per costruire la schermata della domanda
  Widget _buildQuestionScreen() {
    var question = _questions[_currentQuestionIndex];
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Visualizzazione del numero della domanda
          Text(
            'Domanda ${_currentQuestionIndex + 1}/${_questions.length}',
            style: TextStyle(fontSize: 18, color: Colors.grey),
          ),
          SizedBox(height: 20),
          Text(
            question['question'],
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          // Mostra le risposte come pulsanti
          ...question['answers'].map<Widget>((answer) {
            return ElevatedButton(
              onPressed: _isAnswered
                  ? null
                  : () {
                      _checkAnswer(answer, question['correct_answer']);
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: _isAnswered
                    ? (answer == _correctAnswer ? Colors.green : Colors.red)
                    : Colors.white,
              ),
              child: Text(answer),
            );
          }).toList(),
          SizedBox(height: 20),
          // Mostra un messaggio con il risultato della risposta
          if (_isAnswered)
            Text(
              _selectedAnswer == _correctAnswer
                  ? 'Risposta corretta!'
                  : 'Risposta errata. La risposta corretta è: $_correctAnswer',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: _selectedAnswer == _correctAnswer
                      ? Colors.green
                      : Colors.red),
            ),
          SizedBox(height: 20),
          // Pulsante per la domanda successiva o per terminare il quiz
          ElevatedButton(
            onPressed: _currentQuestionIndex < _questions.length - 1
                ? _nextQuestion
                : _finishQuiz,
            child: Text(_currentQuestionIndex < _questions.length - 1
                ? 'Domanda successiva'
                : 'Termina il quiz'),
          ),
        ],
      ),
    );
  }
}
