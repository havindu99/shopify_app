import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import '../../providers/cart_provider.dart';
import '../../theme/app_theme.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cart = context.watch<CartProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Cart'),
        actions: [
          if (cart.items.isNotEmpty)
            TextButton.icon(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: const Text('Clear Cart'),
                    content:
                        const Text('Remove all items from your cart?'),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Cancel'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          cart.clearCart();
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.error,
                        ),
                        child: const Text('Clear'),
                      ),
                    ],
                  ),
                );
              },
              icon: const Icon(Icons.delete_outline_rounded,
                  color: AppTheme.error, size: 18),
              label: const Text('Clear',
                  style: TextStyle(color: AppTheme.error)),
            ),
          const SizedBox(width: 8),
        ],
      ),
      body: cart.items.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: AppTheme.primary.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.shopping_cart_outlined,
                      size: 56,
                      color: AppTheme.primary,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Your cart is empty',
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Add items to get started',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: isDark
                              ? AppTheme.darkSubtext
                              : AppTheme.lightSubtext,
                        ),
                  ),
                ],
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: cart.items.length,
                    separatorBuilder: (_, __) =>
                        const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final item = cart.items[index];
                      return Dismissible(
                        key: Key(item.product.id),
                        direction: DismissDirection.endToStart,
                        background: Container(
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 20),
                          decoration: BoxDecoration(
                            color: AppTheme.error,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Icon(Icons.delete_rounded,
                              color: Colors.white, size: 28),
                        ),
                        onDismissed: (_) {
                          cart.removeFromCart(item.product.id);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                  '${item.product.name} removed from cart'),
                              backgroundColor: AppTheme.error,
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8)),
                            ),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: isDark
                                ? AppTheme.darkCard
                                : AppTheme.lightCard,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: isDark
                                  ? AppTheme.darkBorder
                                  : AppTheme.lightBorder,
                            ),
                          ),
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: CachedNetworkImage(
                                  imageUrl: item.product.image,
                                  width: 80,
                                  height: 80,
                                  fit: BoxFit.cover,
                                  placeholder: (_, __) => Container(
                                    width: 80,
                                    height: 80,
                                    color: isDark
                                        ? AppTheme.darkBorder
                                        : AppTheme.lightBorder,
                                  ),
                                  errorWidget: (_, __, ___) =>
                                      const Icon(Icons.image_not_supported_outlined),
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item.product.name,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(
                                              fontWeight: FontWeight.w600),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      '\$${item.product.price.toStringAsFixed(2)}',
                                      style: const TextStyle(
                                        color: AppTheme.primary,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Row(
                                      children: [
                                        _QtyButton(
                                          icon: Icons.remove_rounded,
                                          onPressed: () => cart
                                              .decreaseQuantity(
                                                  item.product.id),
                                        ),
                                        const SizedBox(width: 12),
                                        Text(
                                          '${item.quantity}',
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium
                                              ?.copyWith(
                                                  fontWeight:
                                                      FontWeight.w700),
                                        ),
                                        const SizedBox(width: 12),
                                        _QtyButton(
                                          icon: Icons.add_rounded,
                                          onPressed: () => cart
                                              .increaseQuantity(
                                                  item.product.id),
                                        ),
                                        const Spacer(),
                                        Text(
                                          '\$${item.totalPrice.toStringAsFixed(2)}',
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleSmall
                                              ?.copyWith(
                                                fontWeight: FontWeight.w800,
                                              ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),

                // Order summary
                Container(
                  padding: const EdgeInsets.fromLTRB(24, 20, 24, 32),
                  decoration: BoxDecoration(
                    color: isDark
                        ? AppTheme.darkSurface
                        : AppTheme.lightSurface,
                    borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(24)),
                    border: Border(
                      top: BorderSide(
                          color: isDark
                              ? AppTheme.darkBorder
                              : AppTheme.lightBorder),
                    ),
                  ),
                  child: Column(
                    children: [
                      _PriceLine(
                          label: 'Subtotal',
                          value: '\$${cart.subtotal.toStringAsFixed(2)}'),
                      const SizedBox(height: 8),
                      _PriceLine(
                        label: 'Shipping',
                        value: cart.shipping == 0
                            ? 'Free'
                            : '\$${cart.shipping.toStringAsFixed(2)}',
                        valueColor: cart.shipping == 0
                            ? AppTheme.success
                            : null,
                      ),
                      const SizedBox(height: 8),
                      _PriceLine(
                          label: 'Tax (8%)',
                          value: '\$${cart.tax.toStringAsFixed(2)}'),
                      const SizedBox(height: 12),
                      Divider(
                          color: isDark
                              ? AppTheme.darkBorder
                              : AppTheme.lightBorder),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Total',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(fontWeight: FontWeight.w800),
                          ),
                          Text(
                            '\$${cart.grandTotal.toStringAsFixed(2)}',
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(
                                  fontWeight: FontWeight.w900,
                                  color: AppTheme.primary,
                                ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      if (cart.shipping == 0)
                        Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 12),
                          margin: const EdgeInsets.only(bottom: 12),
                          decoration: BoxDecoration(
                            color: AppTheme.success.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.local_shipping_rounded,
                                  color: AppTheme.success, size: 16),
                              const SizedBox(width: 6),
                              const Text(
                                'You\'ve got free shipping!',
                                style: TextStyle(
                                    color: AppTheme.success,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 13),
                              ),
                            ],
                          ),
                        ),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (_) => AlertDialog(
                                title: const Text('Order Placed! 🎉'),
                                content: const Text(
                                    'Your order has been placed successfully. Thank you for shopping with ShopNest!'),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16)),
                                actions: [
                                  ElevatedButton(
                                    onPressed: () {
                                      cart.clearCart();
                                      Navigator.pop(context);
                                    },
                                    child: const Text('Continue Shopping'),
                                  ),
                                ],
                              ),
                            );
                          },
                          icon: const Icon(Icons.payment_rounded),
                          label: Text(
                              'Checkout · \$${cart.grandTotal.toStringAsFixed(2)}'),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}

class _QtyButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;

  const _QtyButton({required this.icon, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          color: isDark ? AppTheme.darkBorder : AppTheme.lightBorder,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, size: 16),
      ),
    );
  }
}

class _PriceLine extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;

  const _PriceLine({
    required this.label,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color:
                    isDark ? AppTheme.darkSubtext : AppTheme.lightSubtext,
              ),
        ),
        Text(
          value,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: valueColor,
              ),
        ),
      ],
    );
  }
}
