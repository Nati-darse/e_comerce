-- Enable necessary extensions
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Create users table (modified for Better Auth compatibility)
CREATE TABLE users (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  email VARCHAR(255) NOT NULL UNIQUE,
  email_verified BOOLEAN DEFAULT FALSE,
  name VARCHAR(255),
  image VARCHAR(255),
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  
  -- Additional fields from original schema
  first_name VARCHAR(255),
  last_name VARCHAR(255),
  username VARCHAR(255) UNIQUE,
  phone_number VARCHAR(255),
  birth_date DATE,
  avatar VARCHAR(255),
  status INTEGER DEFAULT 1
);

-- Create sessions table for Better Auth
CREATE TABLE sessions (
  id VARCHAR(255) PRIMARY KEY,
  expires_at TIMESTAMP WITH TIME ZONE NOT NULL,
  token VARCHAR(255) NOT NULL UNIQUE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  ip_address VARCHAR(255),
  user_agent TEXT,
  user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE
);

-- Create accounts table for Better Auth
CREATE TABLE accounts (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  account_id VARCHAR(255) NOT NULL,
  provider_id VARCHAR(255) NOT NULL,
  user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  access_token TEXT,
  refresh_token TEXT,
  id_token TEXT,
  access_token_expires_at TIMESTAMP WITH TIME ZONE,
  refresh_token_expires_at TIMESTAMP WITH TIME ZONE,
  scope VARCHAR(255),
  password VARCHAR(255),
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  UNIQUE(provider_id, account_id)
);

-- Create verification table for Better Auth
CREATE TABLE verification (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  identifier VARCHAR(255) NOT NULL,
  value VARCHAR(255) NOT NULL,
  expires_at TIMESTAMP WITH TIME ZONE NOT NULL,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create country table
CREATE TABLE country (
  country_id SERIAL PRIMARY KEY,
  country_name VARCHAR(255) NOT NULL
);

-- Create shipping_cost table
CREATE TABLE shipping_cost (
  id SERIAL PRIMARY KEY,
  country_id INTEGER NOT NULL REFERENCES country(country_id),
  amount DECIMAL(10,2) NOT NULL
);

-- Create addresses table
CREATE TABLE addresses (
  id SERIAL PRIMARY KEY,
  user_id UUID REFERENCES users(id),
  title VARCHAR(255) NOT NULL,
  country_id INTEGER NOT NULL REFERENCES country(country_id),
  state VARCHAR(255) NOT NULL,
  city VARCHAR(255) NOT NULL,
  postal_code VARCHAR(255) NOT NULL,
  phone_number VARCHAR(255) NOT NULL,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create main_category table
CREATE TABLE main_category (
  mc_id SERIAL PRIMARY KEY,
  mc_name VARCHAR(255) NOT NULL,
  icon TEXT NOT NULL,
  is_showed INTEGER DEFAULT 1,
  is_new INTEGER DEFAULT 0
);

-- Create sub_category table
CREATE TABLE sub_category (
  sc_id SERIAL PRIMARY KEY,
  sc_name VARCHAR(255) NOT NULL,
  mc_id INTEGER NOT NULL REFERENCES main_category(mc_id)
);

-- Create end_category table
CREATE TABLE end_category (
  ec_id SERIAL PRIMARY KEY,
  ec_name VARCHAR(255) NOT NULL,
  sc_id INTEGER NOT NULL REFERENCES sub_category(sc_id)
);

-- Create slider table
CREATE TABLE slider (
  id SERIAL PRIMARY KEY,
  photo VARCHAR(255) NOT NULL,
  heading VARCHAR(255) NOT NULL,
  content1 TEXT NOT NULL,
  content2 TEXT NOT NULL,
  button_text VARCHAR(255) NOT NULL,
  button_url VARCHAR(255) NOT NULL
);

-- Create photo table
CREATE TABLE photo (
  id SERIAL PRIMARY KEY,
  pvalue VARCHAR(255) NOT NULL
);

-- Create size table
CREATE TABLE size (
  id SERIAL PRIMARY KEY,
  svalue VARCHAR(255) NOT NULL
);

-- Create color table
CREATE TABLE color (
  id SERIAL PRIMARY KEY,
  cvalue VARCHAR(255) NOT NULL
);

-- Create products table
CREATE TABLE products (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  description TEXT NOT NULL,
  summary TEXT NOT NULL,
  cover VARCHAR(255) NOT NULL,
  category_id INTEGER REFERENCES end_category(ec_id),
  is_featured INTEGER DEFAULT 0,
  is_active INTEGER DEFAULT 1,
  is_trending INTEGER DEFAULT 0,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create product_color table
CREATE TABLE product_color (
  id SERIAL PRIMARY KEY,
  color_id INTEGER REFERENCES color(id),
  p_id INTEGER REFERENCES products(id),
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create product_size table
CREATE TABLE product_size (
  id SERIAL PRIMARY KEY,
  size_id INTEGER REFERENCES size(id),
  p_id INTEGER REFERENCES products(id),
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create product_photos table
CREATE TABLE product_photos (
  id SERIAL PRIMARY KEY,
  product_id INTEGER REFERENCES products(id),
  color_id INTEGER REFERENCES product_color(id),
  pid INTEGER REFERENCES photo(id)
);

-- Create products_inventory table
CREATE TABLE products_inventory (
  id SERIAL PRIMARY KEY,
  product_id INTEGER NOT NULL REFERENCES products(id),
  color_id INTEGER NOT NULL REFERENCES product_color(id),
  size_id INTEGER NOT NULL REFERENCES product_size(id),
  sold INTEGER DEFAULT 0,
  current_price DECIMAL(10,2),
  normal_price DECIMAL(10,2),
  quantity INTEGER,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create review table
CREATE TABLE review (
  id SERIAL PRIMARY KEY,
  u_id UUID NOT NULL REFERENCES users(id),
  p_id INTEGER NOT NULL REFERENCES products(id),
  comment TEXT NOT NULL,
  rating INTEGER NOT NULL CHECK (rating >= 1 AND rating <= 5),
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create wishlist table
CREATE TABLE wishlist (
  id SERIAL PRIMARY KEY,
  user_id UUID REFERENCES users(id),
  product_id INTEGER REFERENCES products(id),
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  UNIQUE(user_id, product_id)
);

-- Create cart table
CREATE TABLE cart (
  id SERIAL PRIMARY KEY,
  user_id UUID REFERENCES users(id),
  total DECIMAL(10,2),
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create cart_item table
CREATE TABLE cart_item (
  id SERIAL PRIMARY KEY,
  cart_id INTEGER NOT NULL REFERENCES cart(id),
  product_id INTEGER NOT NULL REFERENCES products(id),
  color_id INTEGER NOT NULL REFERENCES product_color(id),
  size_id INTEGER NOT NULL REFERENCES product_size(id),
  quantity INTEGER DEFAULT 1,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create order_details table
CREATE TABLE order_details (
  id SERIAL PRIMARY KEY,
  user_id UUID REFERENCES users(id),
  payment_id INTEGER,
  total DECIMAL(10,2),
  status VARCHAR(50) DEFAULT 'pending',
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create order_item table
CREATE TABLE order_item (
  id SERIAL PRIMARY KEY,
  order_id INTEGER REFERENCES order_details(id),
  product_id INTEGER REFERENCES products(id),
  products_sku_id INTEGER REFERENCES products_inventory(id),
  quantity INTEGER,
  price DECIMAL(10,2),
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create payment_details table
CREATE TABLE payment_details (
  id SERIAL PRIMARY KEY,
  order_id INTEGER REFERENCES order_details(id),
  amount DECIMAL(10,2),
  provider VARCHAR(255),
  status VARCHAR(255),
  transaction_id VARCHAR(255),
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create indexes for better performance
CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_users_username ON users(username);
CREATE INDEX idx_sessions_user_id ON sessions(user_id);
CREATE INDEX idx_products_category ON products(category_id);
CREATE INDEX idx_products_featured ON products(is_featured);
CREATE INDEX idx_products_active ON products(is_active);
CREATE INDEX idx_cart_user_id ON cart(user_id);
CREATE INDEX idx_wishlist_user_id ON wishlist(user_id);
CREATE INDEX idx_orders_user_id ON order_details(user_id);
CREATE INDEX idx_reviews_product ON review(p_id);

-- Create updated_at trigger function
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Add updated_at triggers to relevant tables
CREATE TRIGGER update_users_updated_at BEFORE UPDATE ON users FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_sessions_updated_at BEFORE UPDATE ON sessions FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_accounts_updated_at BEFORE UPDATE ON accounts FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_addresses_updated_at BEFORE UPDATE ON addresses FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_products_updated_at BEFORE UPDATE ON products FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_cart_updated_at BEFORE UPDATE ON cart FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_order_details_updated_at BEFORE UPDATE ON order_details FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
