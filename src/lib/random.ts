/**
 * Randomly choose an element from array `arr`.
 * @example
 * randomChoice([1, 2, 3]) // => 2
 * randomChoice([1, 2, 3]) // => 1
 */
export function randomChoice<T>(arr: T[]): T {
  return arr[Math.floor(Math.random() * arr.length)]
}

/**
 * Generate a random number from `[0, max)`.
 * @example
 * const arr = [0, 1, 2, 3, 4]
 * const randomChoice = arr[randomNat(arr.length)]
 */
export function randomNat(max: number) {
  return Math.floor(Math.random() * max)
}