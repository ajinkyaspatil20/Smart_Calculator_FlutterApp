import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import '../providers/favorites_provider.dart';
import '../providers/user_provider.dart';
import 'dart:math';

class FormulasScreen extends StatefulWidget {
  const FormulasScreen({super.key});

  @override
  State<FormulasScreen> createState() => _FormulasScreenState();
}

class _FormulasScreenState extends State<FormulasScreen> {
  String searchQuery = '';

  final List<FormulaCategory> categories = [
    FormulaCategory(
      'Tables',
      FontAwesomeIcons.table,
      List.generate(50, (index) {
        final number = index + 1;
        return Formula(
          'Table of $number',
          List.generate(10, (i) {
            final multiplier = i + 1;
            return '$number × $multiplier = ${number * multiplier}';
          }).join('\n'),
        );
      }),
    ),
    FormulaCategory(
      'Roots',
      FontAwesomeIcons.squareRootVariable,
      [
        Formula(
            'Square Roots (1-30)',
            List.generate(30, (index) {
              final number = index + 1;
              return '√$number = ${sqrt(number).toStringAsFixed(4)}';
            }).join('\n')),
        Formula(
            'Cube Roots (1-30)',
            List.generate(30, (index) {
              final number = index + 1;
              return '∛$number = ${pow(number, 1 / 3).toStringAsFixed(4)}';
            }).join('\n')),
      ],
    ),
    FormulaCategory(
      'Algebra',
      FontAwesomeIcons.squareRootVariable,
      [
        Formula('Basic Equations',
            '• Linear: ax + b = 0\n• Quadratic: ax² + bx + c = 0'),
        Formula('Quadratic Formula',
            'x = (-b ± √(b² - 4ac)) / 2a\nDiscriminant Δ = b² - 4ac'),
        Formula('Polynomial Basics',
            '• Degree n polynomial: anxⁿ + ... + a₁x + a₀\n• Roots: Values where P(x) = 0'),
        Formula('Binomial Expansion',
            '(x + y)ⁿ = Σᵢ(ⁿCᵢ)xⁿ⁻ⁱyⁱ\nPascal Triangle: 1, 1 1, 1 2 1, 1 3 3 1'),
        Formula('Cubic Formula',
            'x = -b/(3a) + (S + T)\nwhere S = ∛(-q/2 + √(q²/4 + p³/27))\np = -b²/(3a²) + c/a\nq = 2b³/(27a³) - bc/(3a²) + d/a'),
        Formula('Logarithm Rules',
            '• log(xy) = log(x) + log(y)\n• log(x/y) = log(x) - log(y)\n• log(xⁿ) = n·log(x)\n• log₍ₐ₎(x) = ln(x)/ln(a)'),
        Formula('Complex Numbers',
            '• z = a + bi, |z| = √(a² + b²)\n• (a + bi)(c + di) = (ac - bd) + (ad + bc)i\n• eⁱᶿ = cos(θ) + i·sin(θ)'),
        Formula('Matrix Operations',
            '• Addition: [A]ᵢⱼ + [B]ᵢⱼ = [C]ᵢⱼ\n• Multiplication: [AB]ᵢⱼ = Σₖ[A]ᵢₖ[B]ₖⱼ\n• Determinant: |A| = Σ(±a₁ᵢ₁a₂ᵢ₂...aₙᵢₙ)'),
        Formula('Number Theory',
            '• GCD: gcd(a,b) = gcd(b, a mod b)\n• LCM: lcm(a,b) = |ab|/gcd(a,b)\n• Euler Function: φ(n) = n∏(1-1/p)'),
      ],
    ),
    FormulaCategory(
      'Geometry',
      FontAwesomeIcons.shapes,
      [
        Formula('2D Shapes',
            '• Square: A = s², P = 4s\n• Rectangle: A = l·w, P = 2(l + w)\n• Circle: A = πr², C = 2πr'),
        Formula('Triangle Properties',
            '• Area: A = ½bh\n• Heron\'s: A = √s(s-a)(s-b)(s-c)\n• Angles: A + B + C = 180°'),
        Formula('3D Shapes',
            '• Cube: V = s³, SA = 6s²\n• Cuboid: V = l·w·h, SA = 2(lw + lh + wh)'),
        Formula('Sphere',
            '• Volume: V = (4/3)πr³\n• Surface Area: A = 4πr²\n• Great Circle: C = 2πr'),
        Formula('Cylinder',
            '• Volume: V = πr²h\n• Surface Area: A = 2πr² + 2πrh\n• Lateral Area: AL = 2πrh'),
        Formula('Cone',
            '• Volume: V = (1/3)πr²h\n• Surface Area: A = πr² + πrs\n• s = √(r² + h²)'),
        Formula('Regular Polygon',
            '• Area: A = (n·s²)/(4·tan(π/n))\n• Interior Angle: θ = (n-2)180°/n\n• Exterior Angle: φ = 360°/n'),
        Formula('Trigonometry Identities',
            '• sin²θ + cos²θ = 1\n• tan²θ + 1 = sec²θ\n• cot²θ + 1 = csc²θ'),
        Formula('Conic Sections',
            '• Parabola: y = ax² + bx + c\n• Circle: (x-h)² + (y-k)² = r²\n• Ellipse: (x²/a²) + (y²/b²) = 1'),
      ],
    ),
    FormulaCategory(
      'Data Science',
      FontAwesomeIcons.chartBar,
      [
        Formula('Correlation Coefficient', 'r = Σ((x-μₓ)(y-μᵧ))/(σₓσᵧ)'),
        Formula('Linear Regression', 'y = mx + b, m = Σ((x-x̄)(y-ȳ))/Σ(x-x̄)²'),
        Formula('Probability', 'P(A∩B) = P(A)P(B|A)'),
        Formula('Bayes Theorem', 'P(A|B) = P(B|A)P(A)/P(B)'),
        Formula('Z-Score', 'z = (x - μ)/σ'),
        Formula('Probability Distributions',
            '• Normal: f(x) = (1/(σ√(2π)))e^(-(x-μ)²/(2σ²))\n• Binomial: P(X=k) = (ⁿCₖ)pᵏ(1-p)ⁿ⁻ᵏ'),
        Formula('Hypothesis Testing',
            '• t-test: t = (x̄ - μ₀)/(s/√n)\n• Chi-square: χ² = Σ((O-E)²/E)'),
      ],
    ),
    FormulaCategory(
      'Integration-Derivation',
      FontAwesomeIcons.superscript,
      [
        Formula('Power Rule Integration', '∫xⁿdx = (xⁿ⁺¹)/(n+1) + C'),
        Formula('Chain Rule', 'd/dx[f(g(x))] = f′(g(x))g′(x)'),
        Formula('Product Integration', '∫udv = uv - ∫vdu'),
        Formula('Quotient Rule', 'd/dx(u/v) = (v·du/dx - u·dv/dx)/v²'),
        Formula('Fundamental Theorem', '∫ᵃᵇf′(x)dx = f(b) - f(a)'),
        Formula('Differential Equations',
            '• First Order: dy/dx + P(x)y = Q(x)\n• Second Order: y″ + ay′ + by = f(x)'),
        Formula('Multiple Integrals',
            '• Double: ∫∫f(x,y)dxdy\n• Triple: ∫∫∫f(x,y,z)dxdydz'),
      ],
    ),
    FormulaCategory(
      'Geometric Functions',
      FontAwesomeIcons.angleRight,
      [
        Formula('Sine Series', 'sin x = x - x³/3! + x⁵/5! - x⁷/7! + ...'),
        Formula('Cosine Series', 'cos x = 1 - x²/2! + x⁴/4! - x⁶/6! + ...'),
        Formula('Double Angle', 'sin(2x) = 2sin(x)cos(x)'),
        Formula('Half Angle', 'sin(x/2) = ±√((1-cos(x))/2)'),
        Formula('Inverse Functions', 'sin⁻¹(sin x) = x, for -π/2 ≤ x ≤ π/2'),
        Formula('Vector Operations',
            '• Dot Product: a·b = |a||b|cos(θ)\n• Cross Product: |a×b| = |a||b|sin(θ)'),
        Formula('Complex Analysis',
            '• Cauchy Formula: f(z₀) = (1/2πi)∮(f(z)/(z-z₀))dz\n• Residue: Res(f,a) = lim(z→a)(z-a)f(z)'),
      ],
    ),
  ];

  List<FormulaCategory> get filteredCategories {
    if (searchQuery.isEmpty) return categories;
    return categories
        .map((category) {
          final filteredFormulas = category.formulas.where((formula) {
            return formula.name
                    .toLowerCase()
                    .contains(searchQuery.toLowerCase()) ||
                formula.expression
                    .toLowerCase()
                    .contains(searchQuery.toLowerCase());
          }).toList();
          return FormulaCategory(
            category.name,
            category.icon,
            filteredFormulas,
          );
        })
        .where((category) => category.formulas.isNotEmpty)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Formulas'),
        backgroundColor: theme.appBarTheme.backgroundColor,
      ),
      body: Column(
        children: [
          Consumer<UserProvider>(
            builder: (context, userProvider, child) {
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Hello ${userProvider.username}, let\'s do some maths revision by formulas',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.primaryColor,
                  ),
                  textAlign: TextAlign.center,
                ),
              );
            },
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              onChanged: (value) => setState(() => searchQuery = value),
              decoration: InputDecoration(
                hintText: 'Search formulas...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                filled: true,
                fillColor: theme.cardColor,
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredCategories.length,
              padding: EdgeInsets.symmetric(horizontal: 16),
              itemBuilder: (context, index) {
                final category = filteredCategories[index];
                return Card(
                  margin: EdgeInsets.only(bottom: 16),
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  child: Theme(
                    data: Theme.of(context).copyWith(
                      dividerColor: Colors.transparent,
                    ),
                    child: ExpansionTile(
                      leading: Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: theme.primaryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: FaIcon(category.icon,
                            color: theme.primaryColor, size: 20),
                      ),
                      title: Text(
                        category.name,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      children: category.formulas.map((formula) {
                        return Container(
                          margin:
                              EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: theme.cardColor,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: theme.dividerColor),
                          ),
                          child: ExpansionTile(
                            title: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    formula.name,
                                    style: theme.textTheme.titleSmall?.copyWith(
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                Consumer<FavoritesProvider>(
                                  builder: (context, favoritesProvider, child) {
                                    return IconButton(
                                      icon: Icon(
                                        favoritesProvider
                                                .isFavorite(formula.name)
                                            ? Icons.favorite
                                            : Icons.favorite_border,
                                        color: favoritesProvider
                                                .isFavorite(formula.name)
                                            ? Colors.red
                                            : null,
                                      ),
                                      onPressed: () => favoritesProvider
                                          .toggleFavorite(formula.name),
                                    );
                                  },
                                ),
                              ],
                            ),
                            children: [
                              Padding(
                                padding: EdgeInsets.all(16),
                                child: Text(
                                  formula.expression,
                                  style: TextStyle(
                                    fontFamily: 'monospace',
                                    fontSize: 14,
                                    height: 1.5,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class FormulaCategory {
  final String name;
  final IconData icon;
  final List<Formula> formulas;

  FormulaCategory(this.name, this.icon, this.formulas);
}

class Formula {
  final String name;
  final String expression;

  Formula(this.name, this.expression);
}
