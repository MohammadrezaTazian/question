import 'package:flutter/material.dart';
import 'package:flutter_math_fork/flutter_math.dart';

class MathFormulaInput extends StatefulWidget {
  final Function(String) onFormulaInsert;

  const MathFormulaInput({Key? key, required this.onFormulaInsert})
      : super(key: key);

  @override
  State<MathFormulaInput> createState() => _MathFormulaInputState();
}

class _MathFormulaInputState extends State<MathFormulaInput> {
  final TextEditingController _formulaController = TextEditingController();
  String _preview = '';

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'فرمول ریاضی',
              style: TextStyle(fontSize: 18),
              textAlign: TextAlign.right,
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _formulaController,
              decoration: const InputDecoration(
                hintText: r'مثال: \frac{x}{y} یا \sqrt{x}',
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.all(12),
              ),
              textDirection: TextDirection.ltr,
              textAlign: TextAlign.right,
              onChanged: (value) {
                setState(() {
                  _preview = value;
                });
              },
            ),
            const SizedBox(height: 16),
            const Text(
              'پیش‌نمایش:',
              textAlign: TextAlign.right,
            ),
            Container(
              height: 100,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Math.tex(
                _preview,
                textStyle: const TextStyle(fontSize: 20),
                onErrorFallback: (error) => const Text('خطا در فرمول'),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('انصراف'),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    widget.onFormulaInsert(_formulaController.text);
                    Navigator.pop(context);
                  },
                  child: const Text('درج فرمول'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text(
              'فرمول‌های پرکاربرد:',
              textAlign: TextAlign.right,
            ),
            const SizedBox(height: 8),
            _buildQuickFormulas(),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickFormulas() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      alignment: WrapAlignment.end,
      children: [
        _quickFormulaButton(r'\frac{a}{b}', 'کسر'),
        _quickFormulaButton(r'\sqrt{x}', 'رادیکال'),
        _quickFormulaButton(r'\sum_{i=1}^{n}', 'سیگما'),
        _quickFormulaButton(r'\int_{a}^{b}', 'انتگرال'),
        _quickFormulaButton(r'x^2', 'توان'),
        _quickFormulaButton(r'\pi', 'پی'),
        _quickFormulaButton(r'\infty', 'بی‌نهایت'),
        _quickFormulaButton(r'\pm', 'علامت ±'),
      ],
    );
  }

  Widget _quickFormulaButton(String formula, String label) {
    return ElevatedButton(
      onPressed: () {
        final currentText = _formulaController.text;
        final cursorPosition = _formulaController.selection.baseOffset;

        if (cursorPosition >= 0) {
          final newText = currentText.substring(0, cursorPosition) +
              formula +
              currentText.substring(cursorPosition);
          _formulaController.text = newText;
          _formulaController.selection = TextSelection.fromPosition(
            TextPosition(offset: cursorPosition + formula.length),
          );
        } else {
          _formulaController.text += formula;
        }

        setState(() {
          _preview = _formulaController.text;
        });
      },
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
      child: Text(label),
    );
  }

  @override
  void dispose() {
    _formulaController.dispose();
    super.dispose();
  }
}
