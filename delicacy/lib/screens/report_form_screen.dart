import 'package:flutter/material.dart';

import '../widgets/app_button.dart';
import '../widgets/app_text_field.dart';

const _ube = Color(0xFF4B2A6B);
const _pandan = Color(0xFF5E8C4A);
const _background = Color(0xFFF8F5FB);

/// UI states demonstrated by the report form. The initial Empty state refers
/// to the in-memory report list; it is not a form-validation error.
enum ReportUiState { idle, loading, success, empty, error }

class ReportFormScreen extends StatefulWidget {
  const ReportFormScreen({super.key});

  @override
  State<ReportFormScreen> createState() => _ReportFormScreenState();
}

class _ReportFormScreenState extends State<ReportFormScreen> {
  static const _categories = <String>[
    'Allergen information',
    'Ingredients',
    'Origin or location',
    'Other delicacy information',
  ];

  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _detailsController = TextEditingController();
  final _locationController = TextEditingController();
  final _nameFocusNode = FocusNode();
  final List<_ReportSummary> _submittedReports = [];

  String _selectedCategory = _categories.first;
  ReportUiState _uiState = ReportUiState.empty;
  bool _simulateNextFailure = false;
  bool _lastFailureWasSimulated = false;
  String? _errorMessage;

  bool get _isLoading => _uiState == ReportUiState.loading;

  @override
  void dispose() {
    _nameController.dispose();
    _detailsController.dispose();
    _locationController.dispose();
    _nameFocusNode.dispose();
    super.dispose();
  }

  Future<void> _submitReport() async {
    if (_isLoading) return;
    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) return;

    final shouldSimulateFailure = _simulateNextFailure;
    setState(() {
      _uiState = ReportUiState.loading;
      _errorMessage = null;
    });

    try {
      // Simulates a pending REST API call until the backend is connected.
      await Future<void>.delayed(const Duration(seconds: 3));
      if (shouldSimulateFailure) {
        throw StateError('Demo-only simulated server failure.');
      }
      if (!mounted) return;

      setState(() {
        _submittedReports.insert(
          0,
          _ReportSummary(
            name: _nameController.text.trim(),
            category: _selectedCategory,
          ),
        );
        _uiState = ReportUiState.success;
        _lastFailureWasSimulated = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _simulateNextFailure = false;
        _lastFailureWasSimulated = shouldSimulateFailure;
        _errorMessage = shouldSimulateFailure
            ? 'Demo-only simulated server error. No report was saved.'
            : 'The report could not be submitted. Please check the details and retry.';
        _uiState = ReportUiState.error;
      });
    }
  }

  void _retryReport() {
    // A simulated failure is one-shot, so Retry performs the next attempt
    // normally. The form is revalidated before another request is started.
    _submitReport();
  }

  void _editReport() {
    setState(() {
      _uiState = _submittedReports.isEmpty
          ? ReportUiState.empty
          : ReportUiState.idle;
      _errorMessage = null;
    });
    FocusScope.of(context).requestFocus(_nameFocusNode);
  }

  @override
  Widget build(BuildContext context) {
    final stateMessage = _buildStateMessage();
    return Scaffold(
      backgroundColor: _background,
      appBar: AppBar(
        backgroundColor: _ube,
        foregroundColor: Colors.white,
        title: const Text('Report a delicacy'),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 760),
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              const Icon(Icons.fact_check_outlined, color: _pandan, size: 42),
              const SizedBox(height: 8),
              const Text(
                'Help keep delicacy information accurate',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: _ube,
                  fontSize: 23,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Use this form to flag missing or incorrect ingredients, allergen details, or origin information.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 14),
              if (stateMessage != null) ...[
                stateMessage,
                const SizedBox(height: 12),
              ],
              _buildFormCard(),
              const SizedBox(height: 18),
              _buildReportsCard(),
              const SizedBox(height: 12),
              const Text(
                "Activity 9 demo: submissions stay in this screen's memory and disappear when you leave or reload it. No REST API or database is connected.",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.black54, fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget? _buildStateMessage() {
    switch (_uiState) {
      case ReportUiState.loading:
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(strokeWidth: 3),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Loading — submitting your report…',
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                      SizedBox(height: 3),
                      Text('Please wait; the submit button is disabled.'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      case ReportUiState.success:
        return Card(
          color: const Color(0xFFEAF4E7),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.check_circle, color: _pandan),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Success — report received for this demo.',
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                const Text(
                  'This confirmation is simulated. Nothing was saved to a real database.',
                ),
                TextButton.icon(
                  onPressed: () => Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/',
                    (route) => false,
                  ),
                  icon: const Icon(Icons.home_outlined),
                  label: const Text('Return to delicacies'),
                ),
              ],
            ),
          ),
        );
      case ReportUiState.error:
        return Card(
          color: const Color(0xFFFFEEEE),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: const [
                    Icon(Icons.error_outline, color: Colors.red),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Error — report was not submitted.',
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(_errorMessage ?? 'Please try again.'),
                if (_lastFailureWasSimulated)
                  const Text(
                    'The one-time demo failure has been reset; Retry will run normally.',
                  ),
                const SizedBox(height: 10),
                AppButton(
                  label: 'Retry submission',
                  icon: Icons.refresh,
                  onPressed: _retryReport,
                ),
                Center(
                  child: TextButton.icon(
                    onPressed: _editReport,
                    icon: const Icon(Icons.edit_outlined),
                    label: const Text('Edit report details'),
                  ),
                ),
              ],
            ),
          ),
        );
      case ReportUiState.idle:
      case ReportUiState.empty:
        return null;
    }
  }

  Widget _buildFormCard() => Card(
        elevation: 0,
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: _ube.withOpacity(0.15)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Delicacy report form',
                  style: TextStyle(
                    color: _ube,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 16),
                AppTextField(
                  controller: _nameController,
                  focusNode: _nameFocusNode,
                  label: 'Delicacy name',
                  icon: Icons.cake_outlined,
                  enabled: !_isLoading,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Enter the delicacy name';
                    }
                    if (value.trim().length < 2) {
                      return 'Name must contain at least 2 characters';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 14),
                DropdownButtonFormField<String>(
                  value: _selectedCategory,
                  decoration: InputDecoration(
                    labelText: 'Information to correct',
                    prefixIcon: const Icon(Icons.category_outlined, color: _ube),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: _ube.withOpacity(0.20)),
                    ),
                  ),
                  items: _categories
                      .map(
                        (category) => DropdownMenuItem<String>(
                          value: category,
                          child: Text(category),
                        ),
                      )
                      .toList(),
                  onChanged: _isLoading
                      ? null
                      : (value) {
                          if (value != null) {
                            setState(() => _selectedCategory = value);
                          }
                        },
                ),
                const SizedBox(height: 14),
                AppTextField(
                  controller: _detailsController,
                  label: 'Describe the issue',
                  icon: Icons.notes_outlined,
                  maxLines: 4,
                  maxLength: 500,
                  keyboardType: TextInputType.multiline,
                  textInputAction: TextInputAction.newline,
                  helperText: 'For example, mention a missing allergen warning.',
                  enabled: !_isLoading,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Describe what information is missing or incorrect';
                    }
                    if (value.trim().length < 10) {
                      return 'Add at least 10 characters so we can understand the issue';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 14),
                AppTextField(
                  controller: _locationController,
                  label: 'Origin or location (optional)',
                  icon: Icons.place_outlined,
                  enabled: !_isLoading,
                  keyboardType: TextInputType.streetAddress,
                  textInputAction: TextInputAction.done,
                ),
                const SizedBox(height: 4),
                SwitchListTile.adaptive(
                  contentPadding: EdgeInsets.zero,
                  activeColor: _pandan,
                  value: _simulateNextFailure,
                  onChanged: _isLoading
                      ? null
                      : (value) => setState(() => _simulateNextFailure = value),
                  title: const Text('Simulate one server error'),
                  subtitle: const Text(
                    'Demo only: the next valid submission fails once so you can show Error and Retry.',
                  ),
                ),
                const SizedBox(height: 8),
                AppButton(
                  label: _isLoading ? 'Submitting report…' : 'Submit report',
                  icon: _isLoading ? null : Icons.send_outlined,
                  isLoading: _isLoading,
                  onPressed: _submitReport,
                  backgroundColor: _pandan,
                  foregroundColor: Colors.white,
                ),
              ],
            ),
          ),
        ),
      );

  Widget _buildReportsCard() => Card(
        elevation: 0,
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: _ube.withOpacity(0.15)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Report submissions on this page',
                style: TextStyle(
                  color: _ube,
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 10),
              if (_submittedReports.isEmpty)
                _buildEmptyState()
              else
                ..._submittedReports.map(_buildReportTile),
            ],
          ),
        ),
      );

  Widget _buildEmptyState() {
    assert(_submittedReports.isEmpty);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _background,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          const Icon(Icons.inbox_outlined, size: 34, color: _ube),
          const SizedBox(height: 6),
          const Text(
            'No reports yet',
            style: TextStyle(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 3),
          const Text(
            'There are no report records on this page yet. Submit a valid report to see it listed here.',
            textAlign: TextAlign.center,
          ),
          TextButton.icon(
            onPressed: () => FocusScope.of(context).requestFocus(_nameFocusNode),
            icon: const Icon(Icons.edit_note),
            label: const Text('Start a report'),
          ),
        ],
      ),
    );
  }

  Widget _buildReportTile(_ReportSummary report) => ListTile(
        contentPadding: EdgeInsets.zero,
        leading: const CircleAvatar(
          backgroundColor: _pandan,
          child: Icon(Icons.flag_outlined, color: Colors.white),
        ),
        title: Text(report.name),
        subtitle: Text('${report.category} · demo only, not saved to a database'),
      );
}

class _ReportSummary {
  const _ReportSummary({required this.name, required this.category});

  final String name;
  final String category;
}
