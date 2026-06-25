import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';
import '../../models/product.dart';
import '../../providers/cart_provider.dart';
import '../../theme/app_theme.dart';

class ProductDetailScreen extends StatefulWidget {
  final Product product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen>
    with TickerProviderStateMixin {
  int _selectedImageIndex = 0;
  late AnimationController _buttonController;
  late Animation<double> _buttonScale;
  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    _buttonController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    _buttonScale = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _buttonController, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _buttonController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cart = context.watch<CartProvider>();
    final inCart = cart.isInCart(widget.product.id);
    final qty = cart.quantityOf(widget.product.id);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 360,
            pinned: true,
            backgroundColor:
                isDark ? AppTheme.darkSurface : AppTheme.lightSurface,
            leading: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: isDark ? AppTheme.darkCard : AppTheme.lightCard,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isDark ? AppTheme.darkBorder : AppTheme.lightBorder,
                  ),
                ),
                child: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                children: [
                  PageView.builder(
                    controller: _pageController,
                    onPageChanged: (i) =>
                        setState(() => _selectedImageIndex = i),
                    itemCount: widget.product.images.length,
                    itemBuilder: (_, i) => CachedNetworkImage(
                      imageUrl: widget.product.images[i],
                      fit: BoxFit.cover,
                      placeholder: (_, __) => Container(
                        color: isDark
                            ? AppTheme.darkBorder
                            : AppTheme.lightBorder,
                        child: const Center(
                            child: CircularProgressIndicator(strokeWidth: 2)),
                      ),
                      errorWidget: (_, __, ___) => const Icon(
                          Icons.image_not_supported_outlined,
                          size: 48),
                    ),
                  ),
                  // Image indicators
                  if (widget.product.images.length > 1)
                    Positioned(
                      bottom: 16,
                      left: 0,
                      right: 0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          widget.product.images.length,
                          (i) => AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            margin: const EdgeInsets.symmetric(horizontal: 3),
                            width: i == _selectedImageIndex ? 20 : 6,
                            height: 6,
                            decoration: BoxDecoration(
                              color: i == _selectedImageIndex
                                  ? AppTheme.primary
                                  : Colors.white.withOpacity(0.6),
                              borderRadius: BorderRadius.circular(3),
                            ),
                          ),
                        ),
                      ),
                    ),
                  // Discount badge
                  if (widget.product.discountPercent > 0)
                    Positioned(
                      top: 80,
                      right: 16,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppTheme.error,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '-${widget.product.discountPercent.toInt()}%',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Container(
              decoration: BoxDecoration(
                color: isDark ? AppTheme.darkBg : AppTheme.lightBg,
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Category & Name
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppTheme.primary.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        widget.product.category,
                        style: const TextStyle(
                          color: AppTheme.primary,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      widget.product.name,
                      style:
                          Theme.of(context).textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.w800,
                              ),
                    ),
                    const SizedBox(height: 16),

                    // Rating row
                    Row(
                      children: [
                        RatingBarIndicator(
                          rating: widget.product.rating,
                          itemBuilder: (_, __) => const Icon(
                            Icons.star_rounded,
                            color: AppTheme.warning,
                          ),
                          itemCount: 5,
                          itemSize: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '${widget.product.rating}',
                          style:
                              Theme.of(context).textTheme.titleSmall?.copyWith(
                                    fontWeight: FontWeight.w700,
                                  ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '(${widget.product.reviewCount} reviews)',
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: isDark
                                        ? AppTheme.darkSubtext
                                        : AppTheme.lightSubtext,
                                  ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Price
                    Row(
                      children: [
                        Text(
                          '\$${widget.product.price.toStringAsFixed(2)}',
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium
                              ?.copyWith(
                                fontWeight: FontWeight.w900,
                                color: AppTheme.primary,
                              ),
                        ),
                        const SizedBox(width: 12),
                        if (widget.product.discountPercent > 0)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '\$${widget.product.originalPrice.toStringAsFixed(2)}',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(
                                      color: isDark
                                          ? AppTheme.darkSubtext
                                          : AppTheme.lightSubtext,
                                      decoration: TextDecoration.lineThrough,
                                    ),
                              ),
                              Text(
                                'Save \$${(widget.product.originalPrice - widget.product.price).toStringAsFixed(2)}',
                                style: const TextStyle(
                                  color: AppTheme.success,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Divider
                    Divider(
                        color: isDark
                            ? AppTheme.darkBorder
                            : AppTheme.lightBorder),
                    const SizedBox(height: 16),

                    // Description
                    Text(
                      'Description',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      widget.product.description,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: isDark
                                ? AppTheme.darkSubtext
                                : AppTheme.lightSubtext,
                            height: 1.6,
                          ),
                    ),
                    const SizedBox(height: 32),

                    // Availability
                    Row(
                      children: [
                        Icon(
                          widget.product.inStock
                              ? Icons.check_circle_rounded
                              : Icons.cancel_rounded,
                          color: widget.product.inStock
                              ? AppTheme.success
                              : AppTheme.error,
                          size: 18,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          widget.product.inStock
                              ? 'In Stock & Ready to Ship'
                              : 'Currently Out of Stock',
                          style: TextStyle(
                            color: widget.product.inStock
                                ? AppTheme.success
                                : AppTheme.error,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
        decoration: BoxDecoration(
          color: isDark ? AppTheme.darkSurface : AppTheme.lightSurface,
          border: Border(
            top: BorderSide(
                color: isDark ? AppTheme.darkBorder : AppTheme.lightBorder),
          ),
        ),
        child: Row(
          children: [
            // Qty controls if in cart
            if (inCart) ...[
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                      color: isDark
                          ? AppTheme.darkBorder
                          : AppTheme.lightBorder),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove_rounded),
                      onPressed: () => context
                          .read<CartProvider>()
                          .decreaseQuantity(widget.product.id),
                    ),
                    Text(
                      '$qty',
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(fontWeight: FontWeight.w700),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add_rounded),
                      onPressed: () => context
                          .read<CartProvider>()
                          .increaseQuantity(widget.product.id),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
            ],
            Expanded(
              child: AnimatedBuilder(
                animation: _buttonScale,
                builder: (_, child) => Transform.scale(
                  scale: _buttonScale.value,
                  child: child,
                ),
                child: GestureDetector(
                  onTapDown: (_) => _buttonController.forward(),
                  onTapUp: (_) => _buttonController.reverse(),
                  onTapCancel: () => _buttonController.reverse(),
                  child: ElevatedButton.icon(
                    onPressed: widget.product.inStock
                        ? () {
                            context
                                .read<CartProvider>()
                                .addToCart(widget.product);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                    inCart
                                        ? 'Quantity updated!'
                                        : '${widget.product.name} added to cart!'),
                                backgroundColor: AppTheme.success,
                                behavior: SnackBarBehavior.floating,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8)),
                                duration: const Duration(seconds: 2),
                              ),
                            );
                          }
                        : null,
                    icon: Icon(
                      inCart
                          ? Icons.shopping_cart_rounded
                          : Icons.add_shopping_cart_rounded,
                    ),
                    label: Text(
                      widget.product.inStock
                          ? (inCart ? 'Add More' : 'Add to Cart')
                          : 'Out of Stock',
                    ),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: widget.product.inStock
                          ? AppTheme.primary
                          : Colors.grey,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
