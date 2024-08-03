import type { Session, User, Chat } from "~/db/schema"

// —————————————————————————————————————————————————————————————————————————————
// Type

/** The type for a row of the Session table. */
export type Session = typeof Session["$inferSelect"]

/** The type for a row of the User table. */
export type User = typeof User["$inferSelect"]

/** The type for a row of the Chat table. */
export type Chat = typeof Chat["$inferSelect"]