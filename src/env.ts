import { pipe, parse, string, url } from "valibot"

// —————————————————————————————————————————————————————————————————————————————
// Validation

const is_url = pipe(string("Oops, not a string."), url("Oops, not a URL."))

// —————————————————————————————————————————————————————————————————————————————
// Environment Variables

/** Database endpoint. */
export const DATABASE_URL = parse(string(), process.env.DATABASE_URL)

/** Event stream endpoint. */
export const STREAM_URL   = parse(is_url, process.env.STREAM_URL)

/** API server endpoint. */
export const SERVER_URL   = parse(is_url, process.env.SERVER_URL)