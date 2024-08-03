import { sql } from "drizzle-orm"
import { sqliteTable, text, integer } from "drizzle-orm/sqlite-core"

// —————————————————————————————————————————————————————————————————————————————
// Environment

const cascade = { onDelete: "cascade" } as const
const nullify = { onDelete: "set null" } as const

const time = (name:string) => integer(name, {mode:"timestamp"}).default(sql`CURRENT_TIMESTAMP`)

// —————————————————————————————————————————————————————————————————————————————
// Account

export const User = sqliteTable("user", {
  id:        text("id").primaryKey(),
  email:     text("email").unique().notNull(),
  hash:      text("hash").notNull(),
  github_id: integer("github_id").unique(),
  username:  text("username").unique().notNull(),
})

export const Session = sqliteTable("session", {
  id:        text("id").primaryKey(),
  userId:    text("user_id").notNull().references(() => User.id, cascade),
  expiresAt: integer("expires_at").notNull(),
})

// —————————————————————————————————————————————————————————————————————————————
// Chat

export const Room = sqliteTable("room", {
  id:    integer("id").primaryKey(),
  name:  text("name").notNull(),
  owner: text("owner").references(() => User.id, cascade),
})

export const Chat = sqliteTable("chat", {
  id:      integer("id").primaryKey(),
  room:    integer("room").notNull().references(() => Room.id, cascade),
  author:  text("author").references(() => User.id, nullify),
  message: text("message").notNull(),
  posted:  time("posted").notNull(),
})

// https://lucia-auth.com/database/drizzle
