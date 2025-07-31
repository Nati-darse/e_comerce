import { betterAuth } from "better-auth"
import { supabaseAdapter } from "better-auth/adapters/supabase"
import { supabase } from "./supabase"

export const auth = betterAuth({
  database: supabaseAdapter(supabase),
  emailAndPassword: {
    enabled: true,
    requireEmailVerification: true,
  },
  session: {
    expiresIn: 60 * 60 * 24 * 7, // 7 days
    updateAge: 60 * 60 * 24, // 1 day
  },
  user: {
    additionalFields: {
      firstName: {
        type: "string",
        required: true,
      },
      lastName: {
        type: "string", 
        required: true,
      },
      username: {
        type: "string",
        required: true,
        unique: true,
      },
      phoneNumber: {
        type: "string",
        required: true,
      },
      birthDate: {
        type: "string",
        required: true,
      },
      avatar: {
        type: "string",
        required: false,
      },
    },
  },
  plugins: [],
})

export type Session = typeof auth.$Infer.Session
export type User = typeof auth.$Infer.User
