import 'package:flutter/material.dart';
import 'experience_model.dart';
import 'experience_service.dart';

class ExperienceDetailsPage extends StatefulWidget {
  final Experience experience;

  const ExperienceDetailsPage({super.key, required this.experience});

  @override
  State<ExperienceDetailsPage> createState() => _ExperienceDetailsPageState();
}

class _ExperienceDetailsPageState extends State<ExperienceDetailsPage> {
  final _reviewController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  int _rating = 3;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _reviewController.dispose();
    super.dispose();
  }

  Future<void> _submitReview() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);
    
    try {
      final review = Review(
        userId: 'current_user_id', // Replace with actual auth user ID
        text: _reviewController.text.trim(),
        rating: _rating,
        timestamp: DateTime.now(),
      );

      await ExperienceService().addReview(widget.experience.id, review);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Review submitted successfully!'),
            behavior: SnackBarBehavior.floating,
          ),
        );
        _reviewController.clear();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error submitting review: ${e.toString()}'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.experience.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              // Implement share functionality
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Experience Header Section
            _buildExperienceHeader(theme),
            const SizedBox(height: 24),
            
            // Location Information
            _buildLocationInfo(theme),
            const SizedBox(height: 24),
            
            // Description Section
            _buildDescriptionSection(theme),
            const SizedBox(height: 32),
            
            // Reviews Section
            _buildReviewsSection(theme, colorScheme),
            const SizedBox(height: 32),
            
            // Add Review Section
            _buildAddReviewSection(theme, colorScheme),
          ],
        ),
      ),
    );
  }

  Widget _buildExperienceHeader(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.experience.title,
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Chip(
          label: Text(
            widget.experience.category,
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.onPrimaryContainer,
            ),
          ),
          backgroundColor: theme.colorScheme.primaryContainer,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ],
    );
  }

  Widget _buildLocationInfo(ThemeData theme) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: theme.dividerColor,
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(
              Icons.location_on,
              color: theme.colorScheme.primary,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Location',
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: theme.colorScheme.onSurface.withOpacity(0.6),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${widget.experience.latitude.toStringAsFixed(4)}, '
                    '${widget.experience.longitude.toStringAsFixed(4)}',
                    style: theme.textTheme.bodyLarge,
                  ),
                ],
              ),
            ),
            IconButton(
              icon: Icon(
                Icons.map,
                color: theme.colorScheme.primary,
              ),
              onPressed: () {
                // Open in maps
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDescriptionSection(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'About',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          widget.experience.description,
          style: theme.textTheme.bodyLarge?.copyWith(
            height: 1.5,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Icon(
              Icons.calendar_today,
              size: 16,
              color: theme.colorScheme.onSurface.withOpacity(0.6),
            ),
            const SizedBox(width: 8),
            Text(
              'Added ${_formatDate(widget.experience.timestamp)}',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.6),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildReviewsSection(ThemeData theme, ColorScheme colorScheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Reviews',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 8),
            if (widget.experience.reviews.isNotEmpty)
              Chip(
                label: Text(
                  widget.experience.reviews.length.toString(),
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: colorScheme.onPrimary,
                  ),
                ),
                backgroundColor: colorScheme.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
          ],
        ),
        const SizedBox(height: 16),
        
        if (widget.experience.reviews.isEmpty)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: colorScheme.surfaceVariant.withOpacity(0.3),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(
                'No reviews yet. Be the first to share your experience!',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurface.withOpacity(0.6),
                ),
              ),
            ),
          )
        else
          ListView.separated(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: widget.experience.reviews.length,
            separatorBuilder: (_, __) => const SizedBox(height: 16),
            itemBuilder: (context, index) {
              final review = widget.experience.reviews[index];
              return _buildReviewCard(theme, colorScheme, review);
            },
          ),
      ],
    );
  }

  Widget _buildReviewCard(ThemeData theme, ColorScheme colorScheme, Review review) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: theme.dividerColor,
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: colorScheme.primaryContainer,
                  child: Text(
                    review.userId[0].toUpperCase(),
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onPrimaryContainer,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'User ${review.userId.substring(0, 6)}',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        _formatDate(review.timestamp),
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurface.withOpacity(0.6),
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    Text(
                      review.rating.toString(),
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Icon(
                      Icons.star,
                      color: colorScheme.primary,
                      size: 16,
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              review.text,
              style: theme.textTheme.bodyMedium?.copyWith(
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddReviewSection(ThemeData theme, ColorScheme colorScheme) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Share your experience',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _reviewController,
            decoration: InputDecoration(
              labelText: 'Your review',
              hintText: 'Tell others about your experience...',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              filled: true,
              fillColor: colorScheme.surfaceVariant.withOpacity(0.3),
            ),
            maxLines: 4,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Please enter your review';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Text(
                'Rating:',
                style: theme.textTheme.bodyMedium,
              ),
              const SizedBox(width: 12),
              DropdownButton<int>(
                value: _rating,
                icon: Icon(
                  Icons.arrow_drop_down,
                  color: colorScheme.onSurface,
                ),
                elevation: 2,
                style: theme.textTheme.bodyMedium,
                underline: Container(
                  height: 1,
                  color: colorScheme.outline,
                ),
                items: List.generate(5, (index) {
                  final rating = index + 1;
                  return DropdownMenuItem<int>(
                    value: rating,
                    child: Row(
                      children: [
                        Text(rating.toString()),
                        const SizedBox(width: 4),
                        Icon(
                          Icons.star,
                          color: colorScheme.primary,
                          size: 16,
                        ),
                      ],
                    ),
                  );
                }),
                onChanged: (value) {
                  setState(() => _rating = value!);
                },
              ),
            ],
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _isSubmitting ? null : _submitReview,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: _isSubmitting
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                      ),
                    )
                  : const Text('Submit Review'),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}