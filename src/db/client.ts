// import Database from "bun:sqlite"
// import type { Client } from "@libsql/client"
import { createClient } from "@libsql/client"
import { drizzle } from "drizzle-orm/libsql"

import * as schema from "~/db/schema"
import * as env from "~/env"

// —————————————————————————————————————————————————————————————————————————————
// Database Client

export const sqlite = createClient({
  url: env.DATABASE_URL,
})

/** Drizzle database client */
export const db = drizzle(sqlite, { schema })

// import { drizzle } from "drizzle-orm/bun-sqlite"
/** raw Bun database client */
// export const sqlite = new Database("db.sqlite", { strict: true })
