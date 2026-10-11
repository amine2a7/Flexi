export type CleanupStep = () => Promise<void>;

/**
 * Releases test resources in reverse order of creation (clients before their container).
 * A failing step never stops the next ones: with Ryuk disabled, a skipped `stop()` would leave
 * an orphan container running. Every failure is reported at the end in an AggregateError.
 */
export async function releaseAll(steps: readonly CleanupStep[]): Promise<void> {
  const errors: unknown[] = [];
  for (const step of [...steps].reverse()) {
    try {
      await step();
    } catch (error) {
      errors.push(error);
    }
  }
  if (errors.length > 0) throw new AggregateError(errors, 'test resource cleanup failed');
}
