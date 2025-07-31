-- Insert sample countries
INSERT INTO country (country_id, country_name) VALUES
(1, 'Afghanistan'),
(2, 'Albania'),
(3, 'Algeria'),
(67, 'Ethiopia'),
(230, 'United States');

-- Insert sample shipping costs
INSERT INTO shipping_cost (id, country_id, amount) VALUES
(1, 67, 15.00),
(2, 230, 25.00);

-- Insert main categories
INSERT INTO main_category (mc_id, mc_name, icon, is_showed, is_new) VALUES
(1, 'Men', 'ri-shirt-line', 1, 0),
(2, 'Women', 'ri-user-5-line', 1, 0),
(3, 'Kids', 'ri-bear-smile-fill', 1, 0),
(4, 'Electronics', 'ri-computer-line', 1, 0),
(5, 'Sports', 'ri-run-line', 1, 1);

-- Insert sub categories
INSERT INTO sub_category (sc_id, sc_name, mc_id) VALUES
(1, 'Men Accessories', 1),
(2, 'Men''s Shoes', 1),
(3, 'Beauty Products', 2),
(4, 'Accessories', 2),
(6, 'Shoes', 2),
(7, 'Clothing', 2),
(8, 'Bottoms', 1),
(9, 'T-shirts & Shirts', 1),
(10, 'Clothing', 3),
(11, 'Shoes', 3),
(12, 'Accessories', 3),
(14, 'Electronic Items', 4),
(15, 'Computers', 4);

-- Insert end categories
INSERT INTO end_category (ec_id, ec_name, sc_id) VALUES
(1, 'Headwear', 1),
(2, 'Sunglasses', 1),
(3, 'Watches', 1),
(4, 'Sandals', 2),
(5, 'Boots', 2),
(20, 'T-shirts', 9),
(21, 'Casual Shirts', 9),
(22, 'Formal Shirts', 9),
(32, 'Dresses', 7),
(33, 'Tops', 7),
(61, 'Cell Phone and Accessories', 14),
(62, 'Headphones', 14),
(67, 'Computer Components', 15),
(68, 'Computers and Tablets', 15);

-- Insert colors
INSERT INTO color (id, cvalue) VALUES
(1, '#676F7F'),
(2, '#0A7249'),
(3, '#ADC5D6'),
(4, '#000000'),
(5, '#FFFFFF'),
(6, '#FF0000'),
(7, '#0000FF');

-- Insert sizes
INSERT INTO size (id, svalue) VALUES
(1, 'XS'),
(2, 'S'),
(3, 'M'),
(4, 'L'),
(5, 'XL'),
(6, 'XXL'),
(26, 'Free Size'),
(27, 'One Size for All');

-- Insert sample products
INSERT INTO products (id, name, description, summary, cover, category_id, is_featured, is_active, is_trending) VALUES
(1, 'Men''s Ultra Cotton T-Shirt, Multipack', 
 '<p>Solids: 100% Cotton; Sport Grey And Antique Heather: 90% Cotton, 10% Polyester; Safety Colors And Heather: 50% Cotton, 50% Polyester.</p><p>Available in 2 packs and a wide array of colors so you can stock up on your favorite.</p>',
 'Style 20020-Multipack; Solids: 100% Cotton.',
 'product-featured-83.jpg',
 20, 0, 1, 1),
(2, 'Loose-fit One-Shoulder Cutout Rib Knit Maxi Dress',
 'Source for must-have style inspiration from global influencers. Shop limited-edition collections and discover chic wardrobe essentials.',
 '86% Tencel, 14% Elastane',
 'product-featured-84.jpg',
 32, 1, 1, 1),
(3, 'Wireless Bluetooth Headphones',
 'Premium quality wireless headphones with noise cancellation and long battery life.',
 'High-quality audio with 30-hour battery life',
 'headphones-1.jpg',
 62, 1, 1, 0),
(4, 'Smart Watch Series 5',
 'Advanced smartwatch with health monitoring, GPS, and water resistance.',
 'Track your fitness and stay connected',
 'smartwatch-1.jpg',
 3, 1, 1, 1);

-- Insert product colors
INSERT INTO product_color (id, color_id, p_id) VALUES
(1, 1, 1),
(2, 2, 1),
(3, 3, 1),
(4, 4, 2),
(5, 5, 2),
(6, 4, 3),
(7, 5, 3),
(8, 4, 4),
(9, 6, 4);

-- Insert product sizes
INSERT INTO product_size (id, size_id, p_id) VALUES
(1, 1, 1),
(2, 2, 1),
(3, 3, 1),
(4, 4, 1),
(5, 5, 1),
(6, 2, 2),
(7, 3, 2),
(8, 4, 2),
(9, 26, 3),
(10, 26, 4);

-- Insert product inventory
INSERT INTO products_inventory (id, product_id, color_id, size_id, sold, current_price, normal_price, quantity) VALUES
(1, 1, 1, 1, 0, 19.99, 26.99, 15),
(2, 1, 1, 2, 0, 19.99, 26.99, 20),
(3, 1, 1, 3, 0, 19.99, 26.99, 25),
(4, 1, 2, 1, 0, 19.99, 26.99, 10),
(5, 2, 4, 6, 0, 45.99, 65.99, 8),
(6, 2, 5, 7, 0, 45.99, 65.99, 12),
(7, 3, 6, 9, 0, 89.99, 129.99, 15),
(8, 3, 7, 9, 0, 89.99, 129.99, 10),
(9, 4, 8, 10, 0, 299.99, 399.99, 5),
(10, 4, 9, 10, 0, 299.99, 399.99, 3);

-- Insert slider data
INSERT INTO slider (id, photo, heading, content1, content2, button_text, button_url) VALUES
(1, 'slider0.jpg', 'Shoes Fashion', 'Come and Get it', 'Brand New Shoes', 'Shop Now', '/products?category=shoes'),
(2, 'slider1.jpg', 'Quick Fashion', 'Fit Your Wardrobe', 'WITH LUXURY ITEMS', 'Shop Now', '/products'),
(3, 'slider2.jpg', 'Electronics Sale', 'Latest Technology', 'Extra 30% off', 'Shop Now', '/products?category=electronics'),
(4, 'slider3.jpg', 'Best Deals', 'Premium Quality', 'Unbeatable Prices', 'Shop Now', '/products?featured=true');
