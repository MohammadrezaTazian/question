import 'package:flutter/material.dart';
import '../widgets/drawing_canvas.dart';
import '../widgets/question_card.dart';
import '../widgets/math_formula_input.dart';

class QuestionDesignerPage extends StatefulWidget {
  const QuestionDesignerPage({Key? key}) : super(key: key);

  @override
  State<QuestionDesignerPage> createState() => _QuestionDesignerPageState();
}

class _QuestionDesignerPageState extends State<QuestionDesignerPage> {
  final TextEditingController _questionController = TextEditingController();
  final List<Map<String, dynamic>> _questions = [];
  List<Map<String, dynamic>>? _currentDrawing;
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('طراحی سوال ریاضی'),
        centerTitle: true,
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Container(
                  height: 200,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: TextField(
                    controller: _questionController,
                    scrollController: _scrollController,
                    decoration: const InputDecoration(
                      hintText: 'متن سوال را وارد کنید...',
                      contentPadding: EdgeInsets.all(8),
                      border: InputBorder.none,
                    ),
                    maxLines: null,
                    textDirection: TextDirection.rtl,
                    textAlign: TextAlign.right,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    ElevatedButton.icon(
                      onPressed: _showDrawingDialog,
                      icon: const Icon(Icons.draw),
                      label: const Text('افزودن شکل'),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton.icon(
                      onPressed: _showFormulaDialog,
                      icon: const Icon(Icons.functions),
                      label: const Text('افزودن فرمول'),
                    ),
                    if (_currentDrawing != null) ...[
                      const SizedBox(width: 8),
                      const Icon(Icons.check_circle, color: Colors.green),
                      const SizedBox(width: 4),
                      const Text('(شکل آماده است)'),
                    ],
                  ],
                ),
                const SizedBox(height: 16),
                Container(
                  constraints: const BoxConstraints(maxHeight: double.infinity),
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _questions.length,
                    itemBuilder: (context, index) {
                      return QuestionCard(
                        question: _questions[index]['text'],
                        drawing: _questions[index]['drawing'],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _saveQuestion,
        child: const Icon(Icons.save),
      ),
    );
  }

  void _showDrawingDialog() async {
    final result = await showDialog<List<Map<String, dynamic>>>(
      context: context,
      builder: (context) => Dialog(
        child: SizedBox(
          width: 300,
          height: 400,
          child: DrawingCanvas(
            onSave: (drawingData) {
              Navigator.pop(context, drawingData);
            },
          ),
        ),
      ),
    );

    if (result != null) {
      setState(() {
        _currentDrawing = result;
        final cursorPosition = _questionController.selection.baseOffset;
        final currentText = _questionController.text;

        if (cursorPosition >= 0) {
          final newText =
              '${currentText.substring(0, cursorPosition)} [شکل] ${currentText.substring(cursorPosition)}';
          _questionController.text = newText;
          _questionController.selection = TextSelection.fromPosition(
            TextPosition(offset: cursorPosition + 7),
          );
        } else {
          _questionController.text += ' [شکل] ';
        }
      });
    }
  }

  void _showFormulaDialog() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: MathFormulaInput(
          onFormulaInsert: (formula) {
            final cursorPosition = _questionController.selection.baseOffset;
            final currentText = _questionController.text;

            if (cursorPosition >= 0) {
              final newText = currentText.substring(0, cursorPosition) +
                  r'$' +
                  formula +
                  r'$' +
                  currentText.substring(cursorPosition);
              _questionController.text = newText;
              _questionController.selection = TextSelection.fromPosition(
                TextPosition(offset: cursorPosition + formula.length + 2),
              );
            } else {
              _questionController.text += r'$' + formula + r'$';
            }
          },
        ),
      ),
    );
  }

  void _saveQuestion() {
    if (_questionController.text.isNotEmpty) {
      setState(() {
        _questions.add({
          'text': _questionController.text,
          'drawing': _currentDrawing,
        });
        _questionController.clear();
        _currentDrawing = null;
      });
    }
  }

  @override
  void dispose() {
    _questionController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}
