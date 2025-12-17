import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../../../core/app_export.dart';

class PredictionCardWidget extends StatelessWidget {
  final String predictedClass;
  final double confidence;
  final List<dynamic> allPredictions;

  const PredictionCardWidget({
    Key? key,
    required this.predictedClass,
    required this.confidence,
    required this.allPredictions,
  }) : super(key: key);

  Color _getConfidenceColor() {
    if (confidence >= 0.8) return Colors.green.shade700;
    if (confidence >= 0.6) return Colors.orange.shade700;
    return Colors.red.shade700;
  }

  IconData _getConfidenceIcon() {
    if (confidence >= 0.8) return Icons.check_circle_outline;
    if (confidence >= 0.6) return Icons.info_outline;
    return Icons.warning_amber_rounded;
  }

  Widget _buildFormattedDescription(String condition) {
    final description = _getConditionDescription(condition);
    final parts = description.split('\n');
    
    List<TextSpan> spans = [];
    
    for (int i = 0; i < parts.length; i++) {
      final part = parts[i];
      if (part == 'DESCRIPTION' || part == 'CAN IT INFECT OTHER PEOPLE?') {
        spans.add(TextSpan(
          text: part + '\n',
          style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
            color: Colors.grey.shade700,
            height: 1.4,
            fontWeight: FontWeight.bold,
          ),
        ));
      } else if (part.isNotEmpty) {
        spans.add(TextSpan(
          text: part + (i < parts.length - 1 ? '\n' : ''),
          style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
            color: Colors.grey.shade700,
            height: 1.4,
          ),
        ));
      } else {
        spans.add(TextSpan(text: '\n'));
      }
    }
    
    return RichText(
      text: TextSpan(children: spans),
    );
  }

  String _getConditionDescription(String condition) {
    switch (condition.toLowerCase()) {
      case 'healthy':
        return 'DESCRIPTION\nHealthy cat skin is smooth, soft, and clear, with no redness, sores, or excessive flaking, and the coat looks shiny, full, and not patchy. Cats with healthy skin groom normally and do not constantly scratch, lick, or bite at one spot.\n\nCAN IT INFECT OTHER PEOPLE?\nHealthy cat skin is not an infection and cannot infect people.';
      case 'mange':
        return 'DESCRIPTION\nMange is a mite infestation that causes intense itching, hair loss, crusts, and thickened, inflamed skin, often starting on the face, ears, or legs and sometimes spreading to other animals or people.\n\nCAN IT INFECT OTHER PEOPLE?\nSome types of mange in cats (such as sarcoptic or notoedric mange, sometimes called feline scabies) can temporarily infest people and cause itchy skin, so this condition can be zoonotic.';
      case 'ringworm':
        return 'DESCRIPTION\nRingworm is a contagious fungal infection that creates circular or irregular areas of hair loss with red, scaly, or crusty skin, commonly on the head, ears, and paws, and it can spread to other pets and humans.\n\nCAN IT INFECT OTHER PEOPLE?\nRingworm is definitely zoonotic; the fungus can spread from cats to humans through direct contact or contaminated objects.';
      case 'feline acne':
        return 'DESCRIPTION\nFeline acne usually appears on the chin and lips as blackheads and small pimples that can become red, swollen, or crusty when infected, sometimes causing discomfort or pain.\n\nCAN IT INFECT OTHER PEOPLE?\nFeline acne is not considered contagious to people; it is a local skin problem of the cat\'s chin and lips.';
      case 'dermatitis':
        return 'DESCRIPTION\nDermatitis is inflammation of the skin, often caused by allergies, parasites, or irritants, leading to itchy, red skin with scabs and hair loss, and cats may overgroom or scratch especially around the head, neck, or back.\n\nCAN IT INFECT OTHER PEOPLE?\nMost feline dermatitis (for example allergic or flea-allergy dermatitis) is not directly contagious to humans, though the underlying cause like fleas can bite humans and some infectious causes of skin inflammation may have zoonotic potential.';
      default:
        return 'Please consult with a veterinarian for proper diagnosis and treatment recommendations.';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Text(
            'Detected Condition',
            style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 1.h),

          // Condition Name
          Text(
            predictedClass,
            style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppTheme.lightTheme.colorScheme.onSurface,
            ),
          ),
          SizedBox(height: 2.h),

          // Confidence
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              color: _getConfidenceColor().withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      _getConfidenceIcon(),
                      size: 20,
                      color: _getConfidenceColor(),
                    ),
                    SizedBox(width: 2.w),
                    Text(
                      'Confidence Level',
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 0.5.h),
                Text(
                  '${(confidence * 100).toStringAsFixed(1)}%',
                  style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: _getConfidenceColor(),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 2.h),

          // Condition Description
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.blue.shade200, width: 1),
            ),
            child: _buildFormattedDescription(predictedClass),
          ),
          SizedBox(height: 2.h),

          // All predictions
          Text(
            'All Predictions',
            style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 1.h),
          ...allPredictions.take(3).map((prediction) => Container(
            margin: EdgeInsets.only(bottom: 1.h),
            padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 2.w),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  prediction['class'],
                  style: AppTheme.lightTheme.textTheme.bodyMedium,
                ),
                Text(
                  '${(prediction['confidence'] * 100).toStringAsFixed(1)}%',
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          )).toList(),
        ],
      ),
    );
  }
}
