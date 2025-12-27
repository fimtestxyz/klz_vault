# HappiBox Clone - Full Stack Specifications

## Project Overview

A complete e-commerce platform for blind box collectibles with mystery box mechanics, inventory management, and multi-variant product support.

**Tech Stack:**
- Frontend: Next.js 14 (App Router)
- Backend: Next.js API Routes
- Database: Supabase (PostgreSQL)
- Authentication: Supabase Auth
- Storage: Supabase Storage
- Payment: Stripe
- Deployment: Vercel

---

## Database Schema (Supabase)

### Tables

#### 1. `users` (extends Supabase auth.users)
```sql
CREATE TABLE public.profiles (
  id UUID REFERENCES auth.users PRIMARY KEY,
  email TEXT UNIQUE NOT NULL,
  full_name TEXT,
  phone TEXT,
  avatar_url TEXT,
  membership_tier TEXT DEFAULT 'basic', -- basic, silver, gold
  membership_points INTEGER DEFAULT 0,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);
```

#### 2. `addresses`
```sql
CREATE TABLE public.addresses (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES public.profiles(id) ON DELETE CASCADE,
  address_type TEXT NOT NULL, -- shipping, billing
  full_name TEXT NOT NULL,
  phone TEXT NOT NULL,
  address_line1 TEXT NOT NULL,
  address_line2 TEXT,
  city TEXT NOT NULL,
  state TEXT,
  postal_code TEXT NOT NULL,
  country TEXT NOT NULL DEFAULT 'SG',
  is_default BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMPTZ DEFAULT NOW()
);
```

#### 3. `categories`
```sql
CREATE TABLE public.categories (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name TEXT NOT NULL,
  slug TEXT UNIQUE NOT NULL,
  description TEXT,
  image_url TEXT,
  parent_id UUID REFERENCES public.categories(id),
  display_order INTEGER DEFAULT 0,
  is_active BOOLEAN DEFAULT TRUE,
  created_at TIMESTAMPTZ DEFAULT NOW()
);
```

#### 4. `brands`
```sql
CREATE TABLE public.brands (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name TEXT NOT NULL,
  slug TEXT UNIQUE NOT NULL,
  description TEXT,
  logo_url TEXT,
  is_featured BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMPTZ DEFAULT NOW()
);
```

#### 5. `products`
```sql
CREATE TABLE public.products (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name TEXT NOT NULL,
  slug TEXT UNIQUE NOT NULL,
  description TEXT,
  short_description TEXT,
  category_id UUID REFERENCES public.categories(id),
  brand_id UUID REFERENCES public.brands(id),
  
  -- Blind box specific
  is_blind_box BOOLEAN DEFAULT TRUE,
  total_designs INTEGER, -- e.g., 12 regular designs
  hidden_designs INTEGER DEFAULT 0, -- e.g., 2 secret designs
  regular_drop_rate DECIMAL(5,2), -- e.g., 8.33 (percentage)
  hidden_drop_rate DECIMAL(5,2), -- e.g., 0.83 (percentage)
  
  -- SEO
  meta_title TEXT,
  meta_description TEXT,
  
  -- Status
  is_active BOOLEAN DEFAULT TRUE,
  is_featured BOOLEAN DEFAULT FALSE,
  featured_order INTEGER,
  
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);
```

#### 6. `product_variants`
```sql
CREATE TABLE public.product_variants (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  product_id UUID REFERENCES public.products(id) ON DELETE CASCADE,
  variant_type TEXT NOT NULL, -- 'single', 'case_6', 'case_12', 'full_set'
  name TEXT NOT NULL, -- 'Single Random', 'Case of 6'
  sku TEXT UNIQUE NOT NULL,
  price DECIMAL(10,2) NOT NULL,
  compare_at_price DECIMAL(10,2), -- for showing discounts
  quantity_per_case INTEGER, -- 1 for single, 6 for case_6, etc.
  stock_quantity INTEGER DEFAULT 0,
  weight_grams INTEGER,
  is_active BOOLEAN DEFAULT TRUE,
  created_at TIMESTAMPTZ DEFAULT NOW()
);
```

#### 7. `product_images`
```sql
CREATE TABLE public.product_images (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  product_id UUID REFERENCES public.products(id) ON DELETE CASCADE,
  image_url TEXT NOT NULL,
  alt_text TEXT,
  display_order INTEGER DEFAULT 0,
  is_primary BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMPTZ DEFAULT NOW()
);
```

#### 8. `product_designs`
```sql
CREATE TABLE public.product_designs (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  product_id UUID REFERENCES public.products(id) ON DELETE CASCADE,
  design_name TEXT NOT NULL, -- 'Happy Panda', 'Secret Gold Edition'
  design_number TEXT, -- 'A01', 'SECRET-01'
  image_url TEXT,
  is_secret BOOLEAN DEFAULT FALSE,
  rarity TEXT, -- 'regular', 'special', 'secret', 'chase'
  created_at TIMESTAMPTZ DEFAULT NOW()
);
```

#### 9. `carts`
```sql
CREATE TABLE public.carts (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES public.profiles(id) ON DELETE CASCADE,
  session_id TEXT, -- for guest carts
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(user_id),
  UNIQUE(session_id)
);
```

#### 10. `cart_items`
```sql
CREATE TABLE public.cart_items (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  cart_id UUID REFERENCES public.carts(id) ON DELETE CASCADE,
  product_id UUID REFERENCES public.products(id),
  variant_id UUID REFERENCES public.product_variants(id),
  quantity INTEGER NOT NULL DEFAULT 1,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(cart_id, variant_id)
);
```

#### 11. `orders`
```sql
CREATE TABLE public.orders (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  order_number TEXT UNIQUE NOT NULL, -- HB-2024-0001
  user_id UUID REFERENCES public.profiles(id),
  
  -- Contact info (for guest checkout)
  email TEXT NOT NULL,
  phone TEXT,
  
  -- Pricing
  subtotal DECIMAL(10,2) NOT NULL,
  discount_amount DECIMAL(10,2) DEFAULT 0,
  shipping_fee DECIMAL(10,2) DEFAULT 0,
  tax_amount DECIMAL(10,2) DEFAULT 0,
  total_amount DECIMAL(10,2) NOT NULL,
  
  -- Shipping
  shipping_address JSONB NOT NULL,
  billing_address JSONB,
  shipping_method TEXT,
  tracking_number TEXT,
  
  -- Payment
  payment_method TEXT, -- 'stripe', 'paynow', 'card'
  payment_status TEXT DEFAULT 'pending', -- pending, paid, failed, refunded
  payment_intent_id TEXT,
  
  -- Order status
  status TEXT DEFAULT 'pending', -- pending, confirmed, processing, shipped, delivered, cancelled
  
  -- Notes
  customer_notes TEXT,
  admin_notes TEXT,
  
  -- Timestamps
  paid_at TIMESTAMPTZ,
  shipped_at TIMESTAMPTZ,
  delivered_at TIMESTAMPTZ,
  cancelled_at TIMESTAMPTZ,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);
```

#### 12. `order_items`
```sql
CREATE TABLE public.order_items (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  order_id UUID REFERENCES public.orders(id) ON DELETE CASCADE,
  product_id UUID REFERENCES public.products(id),
  variant_id UUID REFERENCES public.product_variants(id),
  
  -- Snapshot data (in case product changes)
  product_name TEXT NOT NULL,
  variant_name TEXT NOT NULL,
  sku TEXT NOT NULL,
  price DECIMAL(10,2) NOT NULL,
  quantity INTEGER NOT NULL,
  
  -- Blind box fulfillment
  designs_received JSONB, -- array of design IDs received
  
  created_at TIMESTAMPTZ DEFAULT NOW()
);
```

#### 13. `promotions`
```sql
CREATE TABLE public.promotions (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  code TEXT UNIQUE NOT NULL,
  name TEXT NOT NULL,
  description TEXT,
  discount_type TEXT NOT NULL, -- 'percentage', 'fixed_amount', 'buy_x_get_y'
  discount_value DECIMAL(10,2), -- 10 for 10% or $10
  
  -- Buy X Get Y
  buy_quantity INTEGER,
  get_quantity INTEGER,
  
  -- Conditions
  min_purchase_amount DECIMAL(10,2),
  max_uses INTEGER, -- null for unlimited
  uses_per_customer INTEGER DEFAULT 1,
  current_uses INTEGER DEFAULT 0,
  
  -- Applicability
  applies_to TEXT, -- 'all', 'specific_products', 'specific_categories'
  applicable_product_ids JSONB,
  applicable_category_ids JSONB,
  
  -- Dates
  start_date TIMESTAMPTZ NOT NULL,
  end_date TIMESTAMPTZ,
  is_active BOOLEAN DEFAULT TRUE,
  
  created_at TIMESTAMPTZ DEFAULT NOW()
);
```

#### 14. `reviews`
```sql
CREATE TABLE public.reviews (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  product_id UUID REFERENCES public.products(id) ON DELETE CASCADE,
  user_id UUID REFERENCES public.profiles(id),
  order_id UUID REFERENCES public.orders(id),
  rating INTEGER NOT NULL CHECK (rating >= 1 AND rating <= 5),
  title TEXT,
  comment TEXT,
  images JSONB, -- array of image URLs
  is_verified_purchase BOOLEAN DEFAULT FALSE,
  is_approved BOOLEAN DEFAULT FALSE,
  admin_reply TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW()
);
```

#### 15. `wishlist`
```sql
CREATE TABLE public.wishlist (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES public.profiles(id) ON DELETE CASCADE,
  product_id UUID REFERENCES public.products(id) ON DELETE CASCADE,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(user_id, product_id)
);
```

#### 16. `inventory_logs`
```sql
CREATE TABLE public.inventory_logs (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  variant_id UUID REFERENCES public.product_variants(id),
  change_type TEXT NOT NULL, -- 'restock', 'sale', 'adjustment', 'return'
  quantity_change INTEGER NOT NULL, -- positive or negative
  quantity_after INTEGER NOT NULL,
  reason TEXT,
  order_id UUID REFERENCES public.orders(id),
  admin_id UUID REFERENCES public.profiles(id),
  created_at TIMESTAMPTZ DEFAULT NOW()
);
```

---

## Row Level Security (RLS) Policies

```sql
-- Profiles: users can read all, update only their own
ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Public profiles are viewable by everyone"
  ON public.profiles FOR SELECT
  USING (true);

CREATE POLICY "Users can update own profile"
  ON public.profiles FOR UPDATE
  USING (auth.uid() = id);

-- Addresses: users can only access their own
ALTER TABLE public.addresses ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can view own addresses"
  ON public.addresses FOR SELECT
  USING (auth.uid() = user_id);

CREATE POLICY "Users can insert own addresses"
  ON public.addresses FOR INSERT
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update own addresses"
  ON public.addresses FOR UPDATE
  USING (auth.uid() = user_id);

CREATE POLICY "Users can delete own addresses"
  ON public.addresses FOR DELETE
  USING (auth.uid() = user_id);

-- Products: public read, admin write
ALTER TABLE public.products ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Products are viewable by everyone"
  ON public.products FOR SELECT
  USING (is_active = true);

-- Carts: users can only access their own
ALTER TABLE public.carts ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can view own cart"
  ON public.carts FOR SELECT
  USING (auth.uid() = user_id);

CREATE POLICY "Users can manage own cart"
  ON public.carts FOR ALL
  USING (auth.uid() = user_id);

-- Orders: users can only see their own
ALTER TABLE public.orders ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can view own orders"
  ON public.orders FOR SELECT
  USING (auth.uid() = user_id);

-- Wishlist: users can only access their own
ALTER TABLE public.wishlist ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can manage own wishlist"
  ON public.wishlist FOR ALL
  USING (auth.uid() = user_id);
```

---

## API Endpoints Structure

### Authentication (`/api/auth/*`)
- `POST /api/auth/signup` - Register new user
- `POST /api/auth/login` - Login user
- `POST /api/auth/logout` - Logout user
- `POST /api/auth/reset-password` - Request password reset
- `GET /api/auth/session` - Get current session

### Products (`/api/products/*`)
- `GET /api/products` - List products (with filters, pagination)
- `GET /api/products/[slug]` - Get single product with variants
- `GET /api/products/[slug]/reviews` - Get product reviews
- `GET /api/products/featured` - Get featured products
- `GET /api/products/categories/[slug]` - Get products by category

### Cart (`/api/cart/*`)
- `GET /api/cart` - Get current cart
- `POST /api/cart/items` - Add item to cart
- `PUT /api/cart/items/[id]` - Update cart item quantity
- `DELETE /api/cart/items/[id]` - Remove item from cart
- `DELETE /api/cart` - Clear cart
- `POST /api/cart/apply-promo` - Apply promotion code

### Checkout (`/api/checkout/*`)
- `POST /api/checkout/validate` - Validate cart and calculate totals
- `POST /api/checkout/create-payment-intent` - Create Stripe payment intent
- `POST /api/checkout/complete` - Complete order after payment

### Orders (`/api/orders/*`)
- `GET /api/orders` - List user's orders
- `GET /api/orders/[id]` - Get order details
- `POST /api/orders/[id]/cancel` - Cancel order

### User (`/api/user/*`)
- `GET /api/user/profile` - Get user profile
- `PUT /api/user/profile` - Update user profile
- `GET /api/user/addresses` - Get user addresses
- `POST /api/user/addresses` - Create address
- `PUT /api/user/addresses/[id]` - Update address
- `DELETE /api/user/addresses/[id]` - Delete address
- `GET /api/user/wishlist` - Get wishlist
- `POST /api/user/wishlist` - Add to wishlist
- `DELETE /api/user/wishlist/[productId]` - Remove from wishlist

### Reviews (`/api/reviews/*`)
- `POST /api/reviews` - Create review
- `PUT /api/reviews/[id]` - Update review
- `DELETE /api/reviews/[id]` - Delete review

### Admin (`/api/admin/*`)
- `GET /api/admin/products` - List all products (with inactive)
- `POST /api/admin/products` - Create product
- `PUT /api/admin/products/[id]` - Update product
- `DELETE /api/admin/products/[id]` - Delete product
- `POST /api/admin/inventory/adjust` - Adjust inventory
- `GET /api/admin/orders` - List all orders
- `PUT /api/admin/orders/[id]/status` - Update order status

---

## Frontend Structure

```
src/
鈹溾攢鈹€ app/
鈹�   鈹溾攢鈹€ (auth)/
鈹�   鈹�   鈹溾攢鈹€ login/
鈹�   鈹�   鈹溾攢鈹€ signup/
鈹�   鈹�   鈹斺攢鈹€ reset-password/
鈹�   鈹溾攢鈹€ (shop)/
鈹�   鈹�   鈹溾攢鈹€ page.tsx                    # Homepage
鈹�   鈹�   鈹溾攢鈹€ products/
鈹�   鈹�   鈹�   鈹溾攢鈹€ page.tsx                # Products listing
鈹�   鈹�   鈹�   鈹斺攢鈹€ [slug]/
鈹�   鈹�   鈹�       鈹斺攢鈹€ page.tsx            # Product detail
鈹�   鈹�   鈹溾攢鈹€ categories/
鈹�   鈹�   鈹�   鈹斺攢鈹€ [slug]/
鈹�   鈹�   鈹�       鈹斺攢鈹€ page.tsx            # Category page
鈹�   鈹�   鈹溾攢鈹€ brands/
鈹�   鈹�   鈹�   鈹斺攢鈹€ [slug]/
鈹�   鈹�   鈹�       鈹斺攢鈹€ page.tsx            # Brand page
鈹�   鈹�   鈹溾攢鈹€ cart/