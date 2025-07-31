-- Enable RLS on all tables
ALTER TABLE users ENABLE ROW LEVEL SECURITY;
ALTER TABLE sessions ENABLE ROW LEVEL SECURITY;
ALTER TABLE accounts ENABLE ROW LEVEL SECURITY;
ALTER TABLE verification ENABLE ROW LEVEL SECURITY;
ALTER TABLE addresses ENABLE ROW LEVEL SECURITY;
ALTER TABLE wishlist ENABLE ROW LEVEL SECURITY;
ALTER TABLE cart ENABLE ROW LEVEL SECURITY;
ALTER TABLE cart_item ENABLE ROW LEVEL SECURITY;
ALTER TABLE order_details ENABLE ROW LEVEL SECURITY;
ALTER TABLE order_item ENABLE ROW LEVEL SECURITY;
ALTER TABLE payment_details ENABLE ROW LEVEL SECURITY;
ALTER TABLE review ENABLE ROW LEVEL SECURITY;

-- Users policies
CREATE POLICY "Users can view their own profile" ON users
  FOR SELECT USING (auth.uid() = id);

CREATE POLICY "Users can update their own profile" ON users
  FOR UPDATE USING (auth.uid() = id);

-- Sessions policies (for Better Auth)
CREATE POLICY "Users can view their own sessions" ON sessions
  FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Users can insert their own sessions" ON sessions
  FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update their own sessions" ON sessions
  FOR UPDATE USING (auth.uid() = user_id);

CREATE POLICY "Users can delete their own sessions" ON sessions
  FOR DELETE USING (auth.uid() = user_id);

-- Accounts policies (for Better Auth)
CREATE POLICY "Users can view their own accounts" ON accounts
  FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Users can insert their own accounts" ON accounts
  FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update their own accounts" ON accounts
  FOR UPDATE USING (auth.uid() = user_id);

CREATE POLICY "Users can delete their own accounts" ON accounts
  FOR DELETE USING (auth.uid() = user_id);

-- Verification policies (for Better Auth)
CREATE POLICY "Allow verification operations" ON verification
  FOR ALL USING (true);

-- Addresses policies
CREATE POLICY "Users can view their own addresses" ON addresses
  FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Users can insert their own addresses" ON addresses
  FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update their own addresses" ON addresses
  FOR UPDATE USING (auth.uid() = user_id);

CREATE POLICY "Users can delete their own addresses" ON addresses
  FOR DELETE USING (auth.uid() = user_id);

-- Wishlist policies
CREATE POLICY "Users can view their own wishlist" ON wishlist
  FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Users can add to their wishlist" ON wishlist
  FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can remove from their wishlist" ON wishlist
  FOR DELETE USING (auth.uid() = user_id);

-- Cart policies
CREATE POLICY "Users can view their own cart" ON cart
  FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Users can create their own cart" ON cart
  FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update their own cart" ON cart
  FOR UPDATE USING (auth.uid() = user_id);

CREATE POLICY "Users can delete their own cart" ON cart
  FOR DELETE USING (auth.uid() = user_id);

-- Cart item policies
CREATE POLICY "Users can view their own cart items" ON cart_item
  FOR SELECT USING (
    EXISTS (
      SELECT 1 FROM cart 
      WHERE cart.id = cart_item.cart_id 
      AND cart.user_id = auth.uid()
    )
  );

CREATE POLICY "Users can add items to their cart" ON cart_item
  FOR INSERT WITH CHECK (
    EXISTS (
      SELECT 1 FROM cart 
      WHERE cart.id = cart_item.cart_id 
      AND cart.user_id = auth.uid()
    )
  );

CREATE POLICY "Users can update their cart items" ON cart_item
  FOR UPDATE USING (
    EXISTS (
      SELECT 1 FROM cart 
      WHERE cart.id = cart_item.cart_id 
      AND cart.user_id = auth.uid()
    )
  );

CREATE POLICY "Users can delete their cart items" ON cart_item
  FOR DELETE USING (
    EXISTS (
      SELECT 1 FROM cart 
      WHERE cart.id = cart_item.cart_id 
      AND cart.user_id = auth.uid()
    )
  );

-- Order policies
CREATE POLICY "Users can view their own orders" ON order_details
  FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Users can create their own orders" ON order_details
  FOR INSERT WITH CHECK (auth.uid() = user_id);

-- Order item policies
CREATE POLICY "Users can view their own order items" ON order_item
  FOR SELECT USING (
    EXISTS (
      SELECT 1 FROM order_details 
      WHERE order_details.id = order_item.order_id 
      AND order_details.user_id = auth.uid()
    )
  );

CREATE POLICY "Users can create their own order items" ON order_item
  FOR INSERT WITH CHECK (
    EXISTS (
      SELECT 1 FROM order_details 
      WHERE order_details.id = order_item.order_id 
      AND order_details.user_id = auth.uid()
    )
  );

-- Payment policies
CREATE POLICY "Users can view their own payments" ON payment_details
  FOR SELECT USING (
    EXISTS (
      SELECT 1 FROM order_details 
      WHERE order_details.id = payment_details.order_id 
      AND order_details.user_id = auth.uid()
    )
  );

CREATE POLICY "Users can create payments for their orders" ON payment_details
  FOR INSERT WITH CHECK (
    EXISTS (
      SELECT 1 FROM order_details 
      WHERE order_details.id = payment_details.order_id 
      AND order_details.user_id = auth.uid()
    )
  );

-- Review policies
CREATE POLICY "Anyone can view reviews" ON review
  FOR SELECT USING (true);

CREATE POLICY "Authenticated users can create reviews" ON review
  FOR INSERT WITH CHECK (auth.uid() = u_id);

CREATE POLICY "Users can update their own reviews" ON review
  FOR UPDATE USING (auth.uid() = u_id);

CREATE POLICY "Users can delete their own reviews" ON review
  FOR DELETE USING (auth.uid() = u_id);

-- Public read access for catalog tables
ALTER TABLE country ENABLE ROW LEVEL SECURITY;
ALTER TABLE shipping_cost ENABLE ROW LEVEL SECURITY;
ALTER TABLE main_category ENABLE ROW LEVEL SECURITY;
ALTER TABLE sub_category ENABLE ROW LEVEL SECURITY;
ALTER TABLE end_category ENABLE ROW LEVEL SECURITY;
ALTER TABLE products ENABLE ROW LEVEL SECURITY;
ALTER TABLE product_color ENABLE ROW LEVEL SECURITY;
ALTER TABLE product_size ENABLE ROW LEVEL SECURITY;
ALTER TABLE product_photos ENABLE ROW LEVEL SECURITY;
ALTER TABLE products_inventory ENABLE ROW LEVEL SECURITY;
ALTER TABLE color ENABLE ROW LEVEL SECURITY;
ALTER TABLE size ENABLE ROW LEVEL SECURITY;
ALTER TABLE photo ENABLE ROW LEVEL SECURITY;
ALTER TABLE slider ENABLE ROW LEVEL SECURITY;

-- Allow public read access to catalog data
CREATE POLICY "Allow public read access" ON country FOR SELECT USING (true);
CREATE POLICY "Allow public read access" ON shipping_cost FOR SELECT USING (true);
CREATE POLICY "Allow public read access" ON main_category FOR SELECT USING (true);
CREATE POLICY "Allow public read access" ON sub_category FOR SELECT USING (true);
CREATE POLICY "Allow public read access" ON end_category FOR SELECT USING (true);
CREATE POLICY "Allow public read access" ON products FOR SELECT USING (is_active = 1);
CREATE POLICY "Allow public read access" ON product_color FOR SELECT USING (true);
CREATE POLICY "Allow public read access" ON product_size FOR SELECT USING (true);
CREATE POLICY "Allow public read access" ON product_photos FOR SELECT USING (true);
CREATE POLICY "Allow public read access" ON products_inventory FOR SELECT USING (true);
CREATE POLICY "Allow public read access" ON color FOR SELECT USING (true);
CREATE POLICY "Allow public read access" ON size FOR SELECT USING (true);
CREATE POLICY "Allow public read access" ON photo FOR SELECT USING (true);
CREATE POLICY "Allow public read access" ON slider FOR SELECT USING (true);
