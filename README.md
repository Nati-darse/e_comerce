# ECommerce Next.js Store

A modern, full-featured e-commerce application built with Next.js, Supabase, Better Auth, and Chapa payment integration.

## Features

- 🛍️ **Product Catalog**: Browse products with categories, search, and filtering
- 🔐 **Authentication**: Secure user authentication with Better Auth
- 🛒 **Shopping Cart**: Add/remove items, quantity management
- ❤️ **Wishlist**: Save favorite products
- 💳 **Payment Processing**: Secure payments with Chapa integration
- 📱 **Responsive Design**: Mobile-first responsive UI
- 🎨 **Modern UI**: Built with Tailwind CSS and Radix UI components
- 🔒 **Row Level Security**: Secure data access with Supabase RLS

## Tech Stack

- **Frontend**: Next.js 15, React, TypeScript
- **Styling**: Tailwind CSS, Radix UI
- **Database**: Supabase (PostgreSQL)
- **Authentication**: Better Auth
- **Payment**: Chapa Payment Gateway
- **Icons**: Lucide React

## Prerequisites

Before you begin, ensure you have:

- Node.js 18+ installed
- A Supabase account and project
- A Chapa merchant account (for payment processing)

## Getting Started

### 1. Clone the Repository

```bash
git clone <your-repo-url>
cd ecommerce-nextjs
```

### 2. Install Dependencies

```bash
npm install
```

### 3. Environment Setup

Create a `.env.local` file in the root directory:

```env
# Supabase Configuration
NEXT_PUBLIC_SUPABASE_URL=your_supabase_project_url
NEXT_PUBLIC_SUPABASE_ANON_KEY=your_supabase_anon_key
SUPABASE_SERVICE_ROLE_KEY=your_supabase_service_role_key

# Better Auth Configuration
BETTER_AUTH_SECRET=your_random_secret_key_here
BETTER_AUTH_URL=http://localhost:3000

# Chapa Payment Configuration
CHAPA_SECRET_KEY=your_chapa_secret_key
CHAPA_PUBLIC_KEY=your_chapa_public_key
NEXT_PUBLIC_CHAPA_PUBLIC_KEY=your_chapa_public_key

# Application Configuration
NEXT_PUBLIC_APP_URL=http://localhost:3000
```

### 4. Database Setup

1. **Create Supabase Project**: Go to [Supabase](https://supabase.com) and create a new project

2. **Run Migrations**: Execute the SQL files in the `supabase/migrations/` directory in order:
   - `001_initial_schema.sql` - Creates all tables and relationships
   - `002_rls_policies.sql` - Sets up Row Level Security policies
   - `003_sample_data.sql` - Adds sample data for testing

3. **Enable RLS**: Make sure Row Level Security is enabled on all tables

### 5. Authentication Setup

The app uses Better Auth which is already configured. The authentication tables will be created automatically when you run the migrations.

### 6. Payment Setup

1. **Chapa Account**: Sign up for a Chapa merchant account
2. **Get API Keys**: Obtain your secret and public keys from the Chapa dashboard
3. **Configure Webhooks**: Set up webhook URL: `your-domain.com/api/payment/callback`

### 7. Run the Development Server

```bash
npm run dev
```

Open [http://localhost:3000](http://localhost:3000) to see the application.

## Project Structure

```
ecommerce-nextjs/
├── src/
│   ├── app/                 # Next.js app router pages
│   │   ├── api/            # API routes
│   │   ├── auth/           # Authentication pages
│   │   └── payment/        # Payment pages
│   ├── components/         # React components
│   │   ├── auth/          # Authentication components
│   │   ├── cart/          # Shopping cart components
│   │   ├── layout/        # Layout components
│   │   ├── product/       # Product components
│   │   └── ui/            # UI components
│   ├── hooks/             # Custom React hooks
│   ├── lib/               # Utility libraries
│   └── types/             # TypeScript type definitions
├── supabase/
│   └── migrations/        # Database migration files
└── public/               # Static assets
```

## Key Features Explained

### Authentication
- User registration and login
- Email verification
- Protected routes
- Session management

### Product Management
- Hierarchical categories (Main → Sub → End categories)
- Product variants (colors, sizes)
- Inventory management
- Product reviews and ratings

### Shopping Cart
- Add/remove items
- Quantity management
- Persistent cart (saved to database)
- Real-time total calculation

### Payment Processing
- Chapa payment gateway integration
- Secure payment initialization
- Payment verification
- Order status tracking

### Database Schema
- Users and authentication tables
- Product catalog with categories
- Shopping cart and wishlist
- Orders and payment tracking
- Reviews and ratings

## API Endpoints

### Authentication
- `POST /api/auth/[...all]` - Better Auth endpoints

### Payment
- `POST /api/payment/initialize` - Initialize payment
- `POST /api/payment/callback` - Payment webhook
- `GET /api/payment/verify` - Verify payment status

## Deployment

### Vercel (Recommended)

1. Push your code to GitHub
2. Connect your repository to Vercel
3. Add environment variables in Vercel dashboard
4. Deploy

### Other Platforms

The app can be deployed to any platform that supports Next.js:
- Netlify
- Railway
- DigitalOcean App Platform
- AWS Amplify

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests if applicable
5. Submit a pull request

## License

This project is licensed under the MIT License.

## Support

For support, please open an issue in the GitHub repository or contact the development team.
