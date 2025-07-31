'use client'

import Image from 'next/image'
import Link from 'next/link'
import { useState } from 'react'
import { Heart, ShoppingCart, Star } from 'lucide-react'
import { Button } from '@/components/ui/button'
import { Card, CardContent } from '@/components/ui/card'
import { formatPrice, calculateDiscountPercentage, getImageUrl } from '@/lib/utils'
import type { ProductWithDetails } from '@/types/database'

interface ProductCardProps {
  product: ProductWithDetails
  onAddToCart?: (productId: number) => void
  onAddToWishlist?: (productId: number) => void
  isInWishlist?: boolean
}

export function ProductCard({ 
  product, 
  onAddToCart, 
  onAddToWishlist, 
  isInWishlist = false 
}: ProductCardProps) {
  const [isLoading, setIsLoading] = useState(false)
  const [wishlistLoading, setWishlistLoading] = useState(false)

  // Get the first available inventory item for pricing
  const firstInventory = product.inventory?.[0]
  const currentPrice = firstInventory?.current_price ? parseFloat(firstInventory.current_price) : 0
  const normalPrice = firstInventory?.normal_price ? parseFloat(firstInventory.normal_price) : 0
  const discountPercentage = calculateDiscountPercentage(normalPrice, currentPrice)

  // Calculate average rating (placeholder for now)
  const averageRating = product.average_rating || 4.5
  const totalReviews = product.total_reviews || 0

  const handleAddToCart = async () => {
    if (!onAddToCart) return
    setIsLoading(true)
    try {
      await onAddToCart(product.id)
    } finally {
      setIsLoading(false)
    }
  }

  const handleWishlistToggle = async () => {
    if (!onAddToWishlist) return
    setWishlistLoading(true)
    try {
      await onAddToWishlist(product.id)
    } finally {
      setWishlistLoading(false)
    }
  }

  return (
    <Card className="group hover:shadow-lg transition-shadow duration-300">
      <CardContent className="p-0">
        <div className="relative">
          <Link href={`/products/${product.id}`}>
            <div className="aspect-square relative overflow-hidden rounded-t-lg">
              <Image
                src={getImageUrl(product.cover)}
                alt={product.name}
                fill
                className="object-cover group-hover:scale-105 transition-transform duration-300"
                sizes="(max-width: 768px) 100vw, (max-width: 1200px) 50vw, 33vw"
              />
              {discountPercentage > 0 && (
                <div className="absolute top-2 left-2 bg-red-500 text-white px-2 py-1 rounded-md text-xs font-semibold">
                  -{discountPercentage}%
                </div>
              )}
              {product.is_featured === 1 && (
                <div className="absolute top-2 right-2 bg-blue-500 text-white px-2 py-1 rounded-md text-xs font-semibold">
                  Featured
                </div>
              )}
            </div>
          </Link>
          
          <button
            onClick={handleWishlistToggle}
            disabled={wishlistLoading}
            className="absolute top-2 right-2 p-2 bg-white rounded-full shadow-md hover:bg-gray-50 transition-colors"
          >
            <Heart 
              className={`h-4 w-4 ${isInWishlist ? 'fill-red-500 text-red-500' : 'text-gray-400'}`} 
            />
          </button>
        </div>

        <div className="p-4">
          <Link href={`/products/${product.id}`}>
            <h3 className="font-semibold text-sm mb-2 line-clamp-2 hover:text-blue-600 transition-colors">
              {product.name}
            </h3>
          </Link>

          {/* Rating */}
          <div className="flex items-center gap-1 mb-2">
            <div className="flex">
              {[...Array(5)].map((_, i) => (
                <Star
                  key={i}
                  className={`h-3 w-3 ${
                    i < Math.floor(averageRating)
                      ? 'fill-yellow-400 text-yellow-400'
                      : 'text-gray-300'
                  }`}
                />
              ))}
            </div>
            <span className="text-xs text-gray-500">({totalReviews})</span>
          </div>

          {/* Price */}
          <div className="flex items-center gap-2 mb-3">
            <span className="font-bold text-lg">
              {formatPrice(currentPrice)}
            </span>
            {normalPrice > currentPrice && (
              <span className="text-sm text-gray-500 line-through">
                {formatPrice(normalPrice)}
              </span>
            )}
          </div>

          {/* Category */}
          {product.category && (
            <p className="text-xs text-gray-500 mb-3">
              {product.category.ec_name}
            </p>
          )}

          {/* Add to Cart Button */}
          <Button
            onClick={handleAddToCart}
            disabled={isLoading || !firstInventory || firstInventory.quantity === 0}
            className="w-full"
            size="sm"
          >
            {isLoading ? (
              'Adding...'
            ) : !firstInventory || firstInventory.quantity === 0 ? (
              'Out of Stock'
            ) : (
              <>
                <ShoppingCart className="h-4 w-4 mr-2" />
                Add to Cart
              </>
            )}
          </Button>
        </div>
      </CardContent>
    </Card>
  )
}
