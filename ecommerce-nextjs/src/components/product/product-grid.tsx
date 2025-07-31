'use client'

import { ProductCard } from './product-card'
import type { ProductWithDetails } from '@/types/database'

interface ProductGridProps {
  products: ProductWithDetails[]
  onAddToCart?: (productId: number) => void
  onAddToWishlist?: (productId: number) => void
  wishlistItems?: number[]
  isLoading?: boolean
}

export function ProductGrid({ 
  products, 
  onAddToCart, 
  onAddToWishlist, 
  wishlistItems = [],
  isLoading = false 
}: ProductGridProps) {
  if (isLoading) {
    return (
      <div className="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 lg:grid-cols-4 gap-6">
        {[...Array(8)].map((_, i) => (
          <div key={i} className="animate-pulse">
            <div className="aspect-square bg-gray-200 rounded-lg mb-4"></div>
            <div className="h-4 bg-gray-200 rounded mb-2"></div>
            <div className="h-4 bg-gray-200 rounded w-3/4 mb-2"></div>
            <div className="h-6 bg-gray-200 rounded w-1/2"></div>
          </div>
        ))}
      </div>
    )
  }

  if (products.length === 0) {
    return (
      <div className="text-center py-12">
        <div className="text-gray-500 text-lg mb-2">No products found</div>
        <p className="text-gray-400">Try adjusting your search or filter criteria</p>
      </div>
    )
  }

  return (
    <div className="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 lg:grid-cols-4 gap-6">
      {products.map((product) => (
        <ProductCard
          key={product.id}
          product={product}
          onAddToCart={onAddToCart}
          onAddToWishlist={onAddToWishlist}
          isInWishlist={wishlistItems.includes(product.id)}
        />
      ))}
    </div>
  )
}
