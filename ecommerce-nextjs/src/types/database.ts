export interface User {
  id: number
  avatar?: string
  first_name: string
  last_name: string
  username: string
  email: string
  password: string
  token: string
  status: number
  birth_of_date: string
  phone_number: string
  created_at: string
  updated_at: string
}

export interface Country {
  country_id: number
  country_name: string
}

export interface ShippingCost {
  id: number
  country_id: number
  amount: string
}

export interface Address {
  id: number
  user_id?: number
  title: string
  country_id: number
  state: string
  city: string
  postal_code: string
  phone_number: string
  created_at: string
  updated_at: string
}

export interface MainCategory {
  mc_id: number
  mc_name: string
  icon: string
  is_showed: number
  is_new: number
}

export interface SubCategory {
  sc_id: number
  sc_name: string
  mc_id: number
}

export interface EndCategory {
  ec_id: number
  ec_name: string
  sc_id: number
}

export interface Product {
  id: number
  name: string
  description: string
  summary: string
  cover: string
  category_id?: number
  is_featured: number
  is_active: number
  is_trending: number
  created_at: string
  updated_at: string
}

export interface Color {
  id: number
  cvalue: string
}

export interface Size {
  id: number
  svalue: string
}

export interface ProductColor {
  id: number
  color_id?: number
  p_id?: number
  created_at: string
  updated_at: string
}

export interface ProductSize {
  id: number
  size_id?: number
  p_id?: number
  created_at: string
  updated_at: string
}

export interface ProductInventory {
  id: number
  product_id: number
  color_id: number
  size_id: number
  sold: number
  current_price: string
  normal_price: string
  quantity: number
  created_at: string
  updated_at: string
}

export interface Review {
  id: number
  u_id: number
  p_id: number
  comment: string
  rating: number
  created_at: string
  updated_at: string
}

export interface Wishlist {
  id: number
  user_id?: number
  product_id?: number
  created_at: string
  updated_at: string
}

export interface Cart {
  id: number
  user_id?: number
  total?: number
  created_at: string
  updated_at: string
}

export interface CartItem {
  id: number
  cart_id: number
  product_id: number
  color_id: number
  size_id: number
  quantity?: number
  created_at: string
  updated_at: string
}

export interface OrderDetails {
  id: number
  user_id?: number
  payment_id?: number
  total?: number
  created_at: string
  updated_at: string
}

export interface OrderItem {
  id: number
  order_id?: number
  product_id?: number
  products_sku_id?: number
  quantity?: number
  created_at: string
  updated_at: string
}

export interface PaymentDetails {
  id: number
  order_id?: number
  amount?: number
  provider: string
  status: string
  created_at: string
  updated_at: string
}

// Extended types for frontend use
export interface ProductWithDetails extends Product {
  colors?: Color[]
  sizes?: Size[]
  inventory?: ProductInventory[]
  category?: EndCategory & {
    sub_category?: SubCategory & {
      main_category?: MainCategory
    }
  }
  reviews?: (Review & { user?: User })[]
  average_rating?: number
  total_reviews?: number
}

export interface CartItemWithDetails extends CartItem {
  product?: Product
  color?: Color
  size?: Size
  inventory?: ProductInventory
}

export interface OrderWithDetails extends OrderDetails {
  items?: (OrderItem & {
    product?: Product
    inventory?: ProductInventory
  })[]
  payment?: PaymentDetails
  user?: User
}
