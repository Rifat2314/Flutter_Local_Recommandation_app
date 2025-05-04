import 'package:flutter/material.dart';
import 'experience_model.dart';
import 'experience_service.dart';

class AddExperiencePage extends StatefulWidget {
  const AddExperiencePage({super.key});

  @override
  State<AddExperiencePage> createState() => _AddExperiencePageState();
}

class _AddExperiencePageState extends State<AddExperiencePage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _latController = TextEditingController();
  final _longController = TextEditingController();
  final List<String> _categories = ['Food', 'Nature', 'Culture', 'Event', 'Other'];
  String _selectedCategory = 'Food';

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _latController.dispose();
    _longController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Experience')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Title'),
                validator: (val) => val!.isEmpty ? 'Enter title' : null,
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
                validator: (val) => val!.isEmpty ? 'Enter description' : null,
              ),
              TextFormField(
                controller: _latController,
                decoration: const InputDecoration(labelText: 'Latitude'),
                keyboardType: TextInputType.number,
                validator: (val) {
                  final lat = double.tryParse(val ?? '');
                  if (lat == null || lat < -90 || lat > 90) {
                    return 'Enter valid latitude (-90 to 90)';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _longController,
                decoration: const InputDecoration(labelText: 'Longitude'),
                keyboardType: TextInputType.number,
                validator: (val) {
                  final long = double.tryParse(val ?? '');
                  if (long == null || long < -180 || long > 180) {
                    return 'Enter valid longitude (-180 to 180)';
                  }
                  return null;
                },
              ),
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                items: _categories.map((category) {
                  return DropdownMenuItem<String>(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                onChanged: (val) => setState(() => _selectedCategory = val!),
                decoration: const InputDecoration(labelText: 'Category'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final newExp = Experience(
                      id: '',
                      title: _titleController.text,
                      description: _descriptionController.text,
                      latitude: double.parse(_latController.text),
                      longitude: double.parse(_longController.text),
                      timestamp: DateTime.now(),
                      category: _selectedCategory,
                    );
                    ExperienceService().addExperience(newExp);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Experience added!')),
                    );
                    Navigator.pop(context);
                  }
                },
                child: const Text('Submit'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
