import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../core/theme/app_colors.dart';
import '../../core/widgets/common.dart';
import '../../core/widgets/gradient_button.dart';
import '../../data/models/horoscope.dart';
import '../../viewmodels/horoscope_controller.dart';

class HoroscopeScreen extends StatefulWidget {
  const HoroscopeScreen({super.key});

  @override
  State<HoroscopeScreen> createState() => _HoroscopeScreenState();
}

class _HoroscopeScreenState extends State<HoroscopeScreen> {
  late final HoroscopeController _controller = Get.find<HoroscopeController>();

  static const Map<String, String> planetIcons = {
    'Ascendant': 'Asc',
    'Sun': '☉',
    'Moon': '☾',
    'Mercury': '☿',
    'Venus': '♀',
    'Mars': '♂',
    'Jupiter': '♃',
    'Saturn': '♄',
    'Rahu': '☊',
    'Ketu': '☋',
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Birth chart')),
      body: Obx(() {
        if (_controller.loading.value) {
          return const AstroLoading(message: 'Reading the stars…');
        }
        final hasChart =
            _controller.chart.value != null &&
            _controller.chart.value!.hasChart;
        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 400),
          switchInCurve: Curves.easeOutCubic,
          switchOutCurve: Curves.easeInCubic,
          transitionBuilder: (child, animation) => FadeTransition(
            opacity: animation,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, 0.03),
                end: Offset.zero,
              ).animate(animation),
              child: child,
            ),
          ),
          child: hasChart
              ? _chartView(context, _controller.chart.value!)
              : _form(context),
        );
      }),
    );
  }

  Widget _chartView(BuildContext context, Horoscope chart) {
    final theme = Theme.of(context);
    final planets = chart.vedicChart?['planets'];
    final ascendant = chart.vedicChart?['ascendant'];
    final precision = chart.vedicChart?['precision']?.toString() ?? '';
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
      children: [
        _heroCard(context, chart),
        const SizedBox(height: 18),
        Text('Your natal placements', style: theme.textTheme.titleMedium),
        const SizedBox(height: 6),
        Text(
          'Sidereal (Vedic) positions based on your birth details.',
          style: theme.textTheme.bodySmall,
        ),
        const SizedBox(height: 12),
        if (planets is Map && planets.isNotEmpty)
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  if (ascendant is Map)
                    _planetRow(
                      Map<String, dynamic>.from(ascendant),
                      'Ascendant',
                      isAscendant: true,
                    ),
                  for (final name in planets.keys)
                    if (planets[name] is Map)
                      _planetRow(
                        Map<String, dynamic>.from(planets[name] as Map),
                        name.toString(),
                      ),
                ],
              ),
            ),
          )
        else
          Card(
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Row(
                children: [
                  const Icon(Icons.info_outline_rounded, color: AppColors.info),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Calculated chart data is not available yet. Add an accurate birth time and place to see your full Vedic placements.',
                      style: theme.textTheme.bodySmall,
                    ),
                  ),
                ],
              ),
            ),
          ),
        const SizedBox(height: 18),
        if (precision.isNotEmpty) _precisionNote(context, precision),
        const SizedBox(height: 18),
        _birthInfoCard(context, chart),
        const SizedBox(height: 24),
        GradientButton(
          label: 'Update birth details',
          icon: Icons.edit_calendar_outlined,
          onPressed: () => setState(() => _editing = true),
        ),
        if (_editing) ...[const SizedBox(height: 16), _form(context)],
      ],
    );
  }

  Widget _heroCard(BuildContext context, Horoscope chart) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: AppColors.nightGradient,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.brandPink.withValues(alpha: 0.35),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              _heroItem('Sun', chart.sunSign ?? '—'),
              const SizedBox(width: 12),
              _heroItem(
                'Moon',
                chart.calculatedMoonSign ?? chart.moonSign ?? '—',
              ),
              const SizedBox(width: 12),
              _heroItem(
                'Nakshatra',
                chart.nakshatra ??
                    chart.vedicChart?['moonNakshatra']?.toString() ??
                    '—',
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              'Moon precision: ${chart.moonSignPrecision.replaceAll('-', ' ')}',
              style: theme.textTheme.labelSmall?.copyWith(
                color: Colors.white.withValues(alpha: 0.85),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _heroItem(String label, String value) {
    return Expanded(
      child: Column(
        children: [
          Icon(_heroIcon(label), color: AppColors.brandOrange, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w800,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: Colors.white.withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    );
  }

  IconData _heroIcon(String label) {
    switch (label) {
      case 'Sun':
        return Icons.wb_sunny_outlined;
      case 'Moon':
        return Icons.brightness_2_outlined;
      default:
        return Icons.star_outline_rounded;
    }
  }

  Widget _planetRow(
    Map<String, dynamic> planet,
    String name, {
    bool isAscendant = false,
  }) {
    final theme = Theme.of(context);
    final rashi = planet['rashi']?.toString() ?? '—';
    final degree = planet['degreeInSign'] is num
        ? (planet['degreeInSign'] as num).toStringAsFixed(1)
        : '';
    final house = planet['house'] is num
        ? (planet['house'] as num).toInt()
        : null;
    final flags = <String>[];
    if (planet['isExalted'] == true) flags.add('Exalted');
    if (planet['isDebilitated'] == true) flags.add('Debilitated');
    if (planet['isOwnSign'] == true) flags.add('Own sign');
    if (planet['isMoolatrikona'] == true) flags.add('Moolatrikona');

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              gradient: isAscendant
                  ? AppColors.brandGradient
                  : const LinearGradient(
                      colors: [Color(0xFFEFE6F3), Color(0xFFE4D5F0)],
                    ),
              borderRadius: BorderRadius.circular(12),
            ),
            alignment: Alignment.center,
            child: Text(
              isAscendant
                  ? planetIcons['Ascendant']!
                  : planetIcons[name] ?? name[0],
              style: theme.textTheme.titleMedium?.copyWith(
                color: isAscendant ? Colors.white : AppColors.night,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: theme.textTheme.titleSmall),
                const SizedBox(height: 2),
                Text(
                  '$rashi${degree.isEmpty ? '' : ' • $degree°'}${house != null ? ' • House $house' : ''}',
                  style: theme.textTheme.bodySmall,
                ),
              ],
            ),
          ),
          if (flags.isNotEmpty)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: AppColors.brandOrange.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                flags.first,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: AppColors.brandOrangeDark,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _precisionNote(BuildContext context, String precision) {
    final theme = Theme.of(context);
    if (precision == 'full') return const SizedBox.shrink();
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.warning.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.warning.withValues(alpha: 0.3)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.lightbulb_outline_rounded,
            color: AppColors.warning,
            size: 20,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'Add your exact birth time and birthplace to unlock your Ascendant and house placements (${precision.replaceAll('-', ' ')}).',
              style: theme.textTheme.bodySmall?.copyWith(
                height: 1.4,
                color: const Color(0xFF7A5B12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _birthInfoCard(BuildContext context, Horoscope chart) {
    final theme = Theme.of(context);
    final dob = chart.dateOfBirth;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Birth details', style: theme.textTheme.titleSmall),
            const SizedBox(height: 12),
            _birthRow(
              Icons.cake_outlined,
              'Date',
              dob == null ? '—' : DateFormat('d MMMM yyyy').format(dob),
            ),
            _birthRow(
              Icons.schedule_rounded,
              'Time',
              chart.timeOfBirth.isEmpty ? 'Not provided' : chart.timeOfBirth,
            ),
            _birthRow(
              Icons.place_outlined,
              'Place',
              chart.placeOfBirth.isEmpty ? 'Not provided' : chart.placeOfBirth,
            ),
          ],
        ),
      ),
    );
  }

  Widget _birthRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, color: AppColors.brandOrange, size: 18),
          const SizedBox(width: 10),
          Text(
            '$label: ',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
          ),
          Expanded(
            child: Text(
              value,
              style: Theme.of(context).textTheme.bodyMedium,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  bool _editing = false;

  Widget _form(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (_controller.chart.value == null) ...[
          Text('Create your birth chart', style: theme.textTheme.headlineSmall),
          const SizedBox(height: 6),
          Text(
            'Enter your birth details and Astro will compute your Vedic chart — Sun sign, Moon sign, Nakshatra and more.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 24),
        ] else ...[
          Text('Update birth details', style: theme.textTheme.titleMedium),
          const SizedBox(height: 16),
        ],
        Obx(
          () => _pickTile(
            context,
            icon: Icons.cake_outlined,
            label: 'Date of birth',
            value: _controller.dateOfBirth.value == null
                ? 'Choose date'
                : DateFormat(
                    'd MMMM yyyy',
                  ).format(_controller.dateOfBirth.value!),
            onTap: () => _controller.pickDate(context),
          ),
        ),
        const SizedBox(height: 12),
        Obx(
          () => _pickTile(
            context,
            icon: Icons.schedule_rounded,
            label: 'Time of birth',
            value: _controller.timeOfBirth.value.isEmpty
                ? 'Choose time'
                : _controller.timeOfBirth.value,
            onTap: () => _controller.pickTime(context),
          ),
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _controller.placeOfBirth,
          decoration: const InputDecoration(
            labelText: 'Place of birth',
            hintText: 'e.g. New Delhi',
            prefixIcon: Icon(
              Icons.place_outlined,
              color: AppColors.brandOrange,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Adding your birth time & place unlocks your Ascendant, houses and full Vedic analysis.',
          style: Theme.of(context).textTheme.bodySmall,
        ),
        const SizedBox(height: 16),
        Obx(() {
          final error = _controller.error.value;
          if (error == null) return const SizedBox.shrink();
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Text(
              error,
              style: theme.textTheme.bodySmall?.copyWith(
                color: const Color(0xFFB3261E),
              ),
            ),
          );
        }),
        Obx(
          () => GradientButton(
            label: _controller.chart.value == null
                ? 'Calculate my chart'
                : 'Save changes',
            icon: Icons.auto_awesome_rounded,
            loading: _controller.saving.value,
            onPressed: _controller.save,
          ),
        ),
      ],
    );
  }

  Widget _pickTile(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFEFE6F3)),
        ),
        child: Row(
          children: [
            Icon(icon, color: AppColors.brandOrange, size: 22),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: theme.textTheme.labelSmall),
                  const SizedBox(height: 2),
                  Text(value, style: theme.textTheme.bodyMedium),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded, color: AppColors.textHint),
          ],
        ),
      ),
    );
  }
}
