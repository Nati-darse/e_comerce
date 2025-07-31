import { supabase } from './supabase'
import type { 
  Product, 
  ProductWithDetails, 
  CartItemWithDetails, 
  OrderWithDetails,
  User,
  MainCategory,
  SubCategory,
  EndCategory
} from '@/types/database'

// Product functions
export async function getProducts(filters?: {
  category?: number
  featured?: boolean
  trending?: boolean
  search?: string
  limit?: number
  offset?: number
}) {
  let query = supabase
    .from('products')
    .select(`
      *,
      category:end_category(
        *,
        sub_category:sub_category(
          *,
          main_category:main_category(*)
        )
      ),
      inventory:products_inventory(*),
      colors:product_color(
        *,
        color:color(*)
      ),
      sizes:product_size(
        *,
        size:size(*)
      )
    `)
    .eq('is_active', 1)

  if (filters?.category) {
    query = query.eq('category_id', filters.category)
  }

  if (filters?.featured) {
    query = query.eq('is_featured', 1)
  }

  if (filters?.trending) {
    query = query.eq('is_trending', 1)
  }

  if (filters?.search) {
    query = query.ilike('name', `%${filters.search}%`)
  }

  if (filters?.limit) {
    query = query.limit(filters.limit)
  }

  if (filters?.offset) {
    query = query.range(filters.offset, filters.offset + (filters.limit || 10) - 1)
  }

  const { data, error } = await query.order('created_at', { ascending: false })

  if (error) throw error
  return data as ProductWithDetails[]
}

export async function getProduct(id: number) {
  const { data, error } = await supabase
    .from('products')
    .select(`
      *,
      category:end_category(
        *,
        sub_category:sub_category(
          *,
          main_category:main_category(*)
        )
      ),
      inventory:products_inventory(*),
      colors:product_color(
        *,
        color:color(*)
      ),
      sizes:product_size(
        *,
        size:size(*)
      ),
      reviews:review(
        *,
        user:users(first_name, last_name, avatar)
      )
    `)
    .eq('id', id)
    .eq('is_active', 1)
    .single()

  if (error) throw error
  return data as ProductWithDetails
}

// Category functions
export async function getMainCategories() {
  const { data, error } = await supabase
    .from('main_category')
    .select('*')
    .eq('is_showed', 1)
    .order('mc_name')

  if (error) throw error
  return data as MainCategory[]
}

export async function getSubCategories(mainCategoryId: number) {
  const { data, error } = await supabase
    .from('sub_category')
    .select('*')
    .eq('mc_id', mainCategoryId)
    .order('sc_name')

  if (error) throw error
  return data as SubCategory[]
}

export async function getEndCategories(subCategoryId: number) {
  const { data, error } = await supabase
    .from('end_category')
    .select('*')
    .eq('sc_id', subCategoryId)
    .order('ec_name')

  if (error) throw error
  return data as EndCategory[]
}

// Cart functions
export async function getOrCreateCart(userId: string) {
  // First try to get existing cart
  let { data: cart, error } = await supabase
    .from('cart')
    .select('*')
    .eq('user_id', userId)
    .single()

  if (error && error.code === 'PGRST116') {
    // Cart doesn't exist, create one
    const { data: newCart, error: createError } = await supabase
      .from('cart')
      .insert({ user_id: userId, total: 0 })
      .select()
      .single()

    if (createError) throw createError
    cart = newCart
  } else if (error) {
    throw error
  }

  return cart
}

export async function getCartItems(userId: string) {
  const cart = await getOrCreateCart(userId)

  const { data, error } = await supabase
    .from('cart_item')
    .select(`
      *,
      product:products(*),
      color:product_color(
        *,
        color:color(*)
      ),
      size:product_size(
        *,
        size:size(*)
      ),
      inventory:products_inventory(*)
    `)
    .eq('cart_id', cart.id)

  if (error) throw error
  return data as CartItemWithDetails[]
}

export async function addToCart(userId: string, productId: number, colorId: number, sizeId: number, quantity: number = 1) {
  const cart = await getOrCreateCart(userId)

  // Check if item already exists in cart
  const { data: existingItem, error: checkError } = await supabase
    .from('cart_item')
    .select('*')
    .eq('cart_id', cart.id)
    .eq('product_id', productId)
    .eq('color_id', colorId)
    .eq('size_id', sizeId)
    .single()

  if (checkError && checkError.code !== 'PGRST116') {
    throw checkError
  }

  if (existingItem) {
    // Update quantity
    const { data, error } = await supabase
      .from('cart_item')
      .update({ quantity: existingItem.quantity + quantity })
      .eq('id', existingItem.id)
      .select()
      .single()

    if (error) throw error
    return data
  } else {
    // Add new item
    const { data, error } = await supabase
      .from('cart_item')
      .insert({
        cart_id: cart.id,
        product_id: productId,
        color_id: colorId,
        size_id: sizeId,
        quantity
      })
      .select()
      .single()

    if (error) throw error
    return data
  }
}

export async function updateCartItemQuantity(cartItemId: number, quantity: number) {
  if (quantity <= 0) {
    return removeFromCart(cartItemId)
  }

  const { data, error } = await supabase
    .from('cart_item')
    .update({ quantity })
    .eq('id', cartItemId)
    .select()
    .single()

  if (error) throw error
  return data
}

export async function removeFromCart(cartItemId: number) {
  const { error } = await supabase
    .from('cart_item')
    .delete()
    .eq('id', cartItemId)

  if (error) throw error
}

// Wishlist functions
export async function getWishlist(userId: string) {
  const { data, error } = await supabase
    .from('wishlist')
    .select(`
      *,
      product:products(*)
    `)
    .eq('user_id', userId)

  if (error) throw error
  return data
}

export async function addToWishlist(userId: string, productId: number) {
  const { data, error } = await supabase
    .from('wishlist')
    .insert({ user_id: userId, product_id: productId })
    .select()
    .single()

  if (error) throw error
  return data
}

export async function removeFromWishlist(userId: string, productId: number) {
  const { error } = await supabase
    .from('wishlist')
    .delete()
    .eq('user_id', userId)
    .eq('product_id', productId)

  if (error) throw error
}

// Order functions
export async function getUserOrders(userId: string) {
  const { data, error } = await supabase
    .from('order_details')
    .select(`
      *,
      items:order_item(
        *,
        product:products(*),
        inventory:products_inventory(*)
      ),
      payment:payment_details(*)
    `)
    .eq('user_id', userId)
    .order('created_at', { ascending: false })

  if (error) throw error
  return data as OrderWithDetails[]
}

export async function createOrder(userId: string, total: number) {
  const { data, error } = await supabase
    .from('order_details')
    .insert({
      user_id: userId,
      total,
      status: 'pending'
    })
    .select()
    .single()

  if (error) throw error
  return data
}
