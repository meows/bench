import type { Config } from "drizzle-kit"
import * as env from "~/env"

// —————————————————————————————————————————————————————————————————————————————
// Drizzle Configuration

export default {
  schema: "./src/db/schema.ts",
  dialect: "sqlite",
  dbCredentials: {
    url: env.DATABASE_URL,
  },
} satisfies Config
