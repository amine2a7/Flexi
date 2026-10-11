/** kebab-case token name to camelCase Dart/JS identifier ("body-lg" -> "bodyLg"). */
export function camel(name: string): string {
  return name.replace(/-([a-z0-9])/g, (_m, ch: string) => ch.toUpperCase());
}
