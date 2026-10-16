import 'package:flutter/material.dart';

const _ube = Color(0xFF4B2A6B);
const _pandan = Color(0xFF5E8C4A);
const _background = Color(0xFFF8F5FB);

class _Category {
  final String name;
  final IconData icon;
  const _Category(this.name, this.icon);
}

class _Delicacy {
  final String name;
  final String origin;
  final String price;
  const _Delicacy(this.name, this.origin, this.price);
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const _categories = [
    _Category('Kakanin', Icons.rice_bowl),
    _Category('Pastries', Icons.bakery_dining),
    _Category('Sweets', Icons.cookie),
    _Category('Dried goods', Icons.set_meal),
  ];

  static const _featured = [
    _Delicacy('Budbud Kabog', 'Misamis Oriental', '₱60'),
    _Delicacy('Pastel', 'Camiguin', '₱45'),
    _Delicacy('Durian Candy', 'Davao', '₱120'),
    _Delicacy('Ube Halaya', 'Bohol', '₱150'),
  ];

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: _background,
        appBar: AppBar(
          backgroundColor: _ube,
          foregroundColor: Colors.white,
          title: const Text(
            'Delicacy System',
            style: TextStyle(fontWeight: FontWeight.w700),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pushNamed(context, '/login'),
              child: const Text('Log in', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildHero(context),
            const SizedBox(height: 24),
            const Text(
              'Categories',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 88,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: _categories.length,
                separatorBuilder: (_, __) => const SizedBox(width: 12),
                itemBuilder: (_, i) => _buildCategory(_categories[i]),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Popular delicacies',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 12),
            ..._featured.map(_buildDelicacyTile),
          ],
        ),
      );

  Widget _buildHero(BuildContext context) => Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: _ube,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Local delicacies, made fresh.',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Browse, order, and track kakanin, pastries, and sweets from Mindanao.',
              style: TextStyle(color: Colors.white70, fontSize: 14),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/login'),
              style: ElevatedButton.styleFrom(
                backgroundColor: _pandan,
                foregroundColor: Colors.white,
              ),
              child: const Text('Log in to order'),
            ),
          ],
        ),
      );

  Widget _buildCategory(_Category c) => Container(
        width: 88,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: _ube.withOpacity(0.15)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(c.icon, color: _pandan, size: 28),
            const SizedBox(height: 6),
            Text(c.name, style: const TextStyle(fontSize: 12)),
          ],
        ),
      );

  Widget _buildDelicacyTile(_Delicacy d) => Card(
        elevation: 0,
        color: Colors.white,
        margin: const EdgeInsets.only(bottom: 10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: _ube.withOpacity(0.15)),
        ),
        child: ListTile(
          leading: const CircleAvatar(
            backgroundColor: _pandan,
            child: Icon(Icons.cake, color: Colors.white),
          ),
          title: Text(d.name, style: const TextStyle(fontWeight: FontWeight.w600)),
          subtitle: Text(d.origin),
          trailing: Text(
            d.price,
            style: const TextStyle(color: _ube, fontWeight: FontWeight.w700),
          ),
        ),
      );
}