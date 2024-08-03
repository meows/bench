/**
 * For hashing and comparing documents.
 * - Only works in JS environments that support the `crypto` module.
 * @example
 * ```ts
 * const hash = await sha256("Hello, World!")
 * ```
 */
export default async function sha256(message:string): Promise<string> {
  const msgBuffer = await new TextEncoder().encode(message)
  const hashBuffer = await crypto.subtle.digest("SHA-256", msgBuffer)
  return Array.from(new Uint8Array(hashBuffer))
    .map(b => b.toString(16).padStart(2, "0"))
    .join("")
}
