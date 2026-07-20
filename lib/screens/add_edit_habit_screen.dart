import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import '../models/habit.dart';

class AddEditHabitScreen extends StatefulWidget {
  final Habit? habit;

  const AddEditHabitScreen({super.key, this.habit});

  @override
  State<AddEditHabitScreen> createState() => _AddEditHabitScreenState();
}

class _AddEditHabitScreenState extends State<AddEditHabitScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  String _frequency = 'daily';
  int _selectedColor = 0xFF6750A4;
  String? _selectedIcon;

  static const List<Color> _colorOptions = [
    Color(0xFF6750A4),
    Color(0xFF625B71),
    Color(0xFF7D5260),
    Color(0xFFB3261E),
    Color(0xFFE8710A),
    Color(0xFF386A20),
    Color(0xFF0061A4),
  ];

  static const Map<String, IconData> _iconOptions = {
    'fitness': Icons.fitness_center,
    'book': Icons.menu_book,
    'water': Icons.water_drop,
    'sleep': Icons.bedtime,
    'meditate': Icons.self_improvement,
    'run': Icons.directions_run,
    'code': Icons.code,
    'music': Icons.music_note,
    'food': Icons.restaurant,
    'health': Icons.favorite,
    'work': Icons.work,
    'study': Icons.school,
  };

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.habit?.name ?? '');
    if (widget.habit != null) {
      _frequency = widget.habit!.frequency;
      _selectedColor = widget.habit!.color;
      _selectedIcon = widget.habit!.icon;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    final habit = Habit(
      id: widget.habit?.id,
      name: _nameController.text.trim(),
      icon: _selectedIcon,
      color: _selectedColor,
      frequency: _frequency,
      createdAt: widget.habit?.createdAt,
    );

    if (widget.habit == null) {
      await DatabaseHelper.instance.insertHabit(habit);
    } else {
      await DatabaseHelper.instance.updateHabit(habit);
    }

    if (mounted) Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.habit != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Habit' : 'Add Habit'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Habit Name',
                hintText: 'e.g., Exercise, Read, Meditate',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter a habit name';
                }
                return null;
              },
              autofocus: true,
            ),
            const SizedBox(height: 24),
            const Text('Color', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: _colorOptions.map((color) {
                final isSelected = _selectedColor == color.toARGB32();
                return GestureDetector(
                  onTap: () => setState(() => _selectedColor = color.toARGB32()),
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                      border: isSelected
                          ? Border.all(color: Colors.white, width: 3)
                          : null,
                    ),
                    child: isSelected
                        ? const Icon(Icons.check, color: Colors.white, size: 20)
                        : null,
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),
            const Text('Icon', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _iconOptions.entries.map((entry) {
                final isSelected = _selectedIcon == entry.key;
                return GestureDetector(
                  onTap: () => setState(() {
                    _selectedIcon = isSelected ? null : entry.key;
                  }),
                  child: Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: isSelected
                          ? Color(_selectedColor).withValues(alpha: 0.3)
                          : Theme.of(context).colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(12),
                      border: isSelected
                          ? Border.all(color: Color(_selectedColor), width: 2)
                          : null,
                    ),
                    child: Icon(entry.value, color: Color(_selectedColor)),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),
            const Text('Frequency', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            SegmentedButton<String>(
              segments: const [
                ButtonSegment(value: 'daily', label: Text('Daily')),
                ButtonSegment(value: 'weekly', label: Text('Weekly')),
                ButtonSegment(value: 'custom', label: Text('Custom')),
              ],
              selected: {_frequency},
              onSelectionChanged: (selected) {
                setState(() => _frequency = selected.first);
              },
            ),
            const SizedBox(height: 32),
            FilledButton(
              onPressed: _save,
              child: Text(isEditing ? 'Save Changes' : 'Add Habit'),
            ),
          ],
        ),
      ),
    );
  }
}
