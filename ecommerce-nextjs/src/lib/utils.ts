import { type ClassValue, clsx } from "clsx"
import { twMerge } from "tailwind-merge"

export function cn(...inputs: ClassValue[]) {
  return twMerge(clsx(inputs))
}

export function formatPrice(price: number | string): string {
  const numPrice = typeof price === 'string' ? parseFloat(price) : price
  return new Intl.NumberFormat('en-US', {
    style: 'currency',
    currency: 'ETB', // Ethiopian Birr
    minimumFractionDigits: 2,
  }).format(numPrice)
}

export function formatDate(date: string | Date): string {
  const dateObj = typeof date === 'string' ? new Date(date) : date
  return new Intl.DateTimeFormat('en-US', {
    year: 'numeric',
    month: 'long',
    day: 'numeric',
  }).format(dateObj)
}

export function generateSlug(text: string): string {
  return text
    .toLowerCase()
    .replace(/[^\w\s-]/g, '')
    .replace(/[\s_-]+/g, '-')
    .replace(/^-+|-+$/g, '')
}

export function calculateDiscountPercentage(originalPrice: number | string, currentPrice: number | string): number {
  const original = typeof originalPrice === 'string' ? parseFloat(originalPrice) : originalPrice
  const current = typeof currentPrice === 'string' ? parseFloat(currentPrice) : currentPrice
  
  if (original <= current) return 0
  
  return Math.round(((original - current) / original) * 100)
}

export function truncateText(text: string, maxLength: number): string {
  if (text.length <= maxLength) return text
  return text.substring(0, maxLength).trim() + '...'
}

export function debounce<T extends (...args: any[]) => any>(
  func: T,
  wait: number
): (...args: Parameters<T>) => void {
  let timeout: NodeJS.Timeout | null = null
  
  return (...args: Parameters<T>) => {
    if (timeout) clearTimeout(timeout)
    timeout = setTimeout(() => func(...args), wait)
  }
}

export function isValidEmail(email: string): boolean {
  const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/
  return emailRegex.test(email)
}

export function isValidPhone(phone: string): boolean {
  // Ethiopian phone number format
  const phoneRegex = /^(\+251|0)?[79]\d{8}$/
  return phoneRegex.test(phone.replace(/\s/g, ''))
}

export function generateOrderId(): string {
  const timestamp = Date.now().toString(36)
  const randomStr = Math.random().toString(36).substring(2, 8)
  return `ORD-${timestamp}-${randomStr}`.toUpperCase()
}

export function getImageUrl(imagePath: string): string {
  if (!imagePath) return '/placeholder-product.jpg'
  if (imagePath.startsWith('http')) return imagePath
  return `/images/products/${imagePath}`
}

export function calculateCartTotal(items: Array<{ quantity: number; price: number }>): number {
  return items.reduce((total, item) => total + (item.quantity * item.price), 0)
}

export function getInitials(firstName: string, lastName: string): string {
  return `${firstName.charAt(0)}${lastName.charAt(0)}`.toUpperCase()
}
