import type { ExtractTablesWithRelations } from "drizzle-orm"
import type { SQLiteTransaction } from "drizzle-orm/sqlite-core"
import type { ResultSet } from "@libsql/client"

import { generateId } from "lucia"
import { hash as argon2 } from "@node-rs/argon2"

import { throwError } from "~/lib/lambda"
import { randomNat } from "~/lib/random"
import { green } from "~/lib/console"

import { db } from "~/db/client"
import { Chat, Room, User } from "~/db/schema"
import * as schema from "~/db/schema"

// —————————————————————————————————————————————————————————————————————————————
// Mock Data

const raw_users = [
  { email: "joe@gmail.com", password: "secret password" },
  { email: "bob@gmail.com", password: "secret password" },
]

const raw_chats = [
  "Hello, world!",
  "How are you?",
  "What's up?",
  "Good morning!",
  "Good night!",
]

const users = await Promise.all(raw_users.map(async ({ email, password }) => ({
  email,
  hash: await argon2(password),
  id: generateId(15),
  username: email,
})))

const rooms = [
  { name: "General", owner: users[0].id, id:1 },
  { name: "Random", owner: users[1].id, id:2 },
]

const chats = raw_chats.map((message, id) => ({
  id,
  author: users[randomNat(users.length)].id,
  message,
  posted: new Date(),
  room: rooms[randomNat(rooms.length)].id,
}))

type Schema = typeof schema
type Transaction = SQLiteTransaction<"async", ResultSet, Schema, ExtractTablesWithRelations<Schema>>

// —————————————————————————————————————————————————————————————————————————————
// Insert Data

async function query(t:Transaction) {
  await t.delete(User).execute().catch(throwError)
  await t.delete(Room).execute().catch(throwError)
  await t.delete(Chat).execute().catch(throwError)

  const rows_user = await t.insert(User)
    .values(users)
    .returning()
    .onConflictDoNothing()
    .execute()
    .catch(throwError)

  const rows_room = await t.insert(Room)
    .values(rooms)
    .returning()
    .onConflictDoNothing()
    .execute()
    .catch(throwError)

  const rows_chat = await t.insert(Chat)
    .values(chats)
    .returning()
    .onConflictDoNothing()
    .execute()
    .catch(throwError)

  console.log(`${green("+")} inserted ${rows_user?.length} users`)
  console.log(`${green("+")} inserted ${rows_room?.length} rooms`)
  console.log(`${green("+")} inserted ${rows_chat?.length} messages`)
}

await db.transaction(query)
  .catch(throwError)
  .finally(() => console.log(`${green("✓")} database reset & seeded`))
