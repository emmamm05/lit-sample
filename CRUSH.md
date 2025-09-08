# CRUSH.md

## Build Commands

*   **Build:** `yarn install && yarn build`
*   **Lint:** (No explicit linting commands found, consider adding one)
*   **Test:** `bundle exec rake test`

## Running a Single Test

To run a single test, you can use the `--name` flag with `bundle exec rake test`:

```bash
bundle exec rake test -- --name="test_user_creation"
```

(Replace `"test_user_creation"` with the specific test name you want to run.)

## Code Style Guidelines

*   **Imports:** Organize imports alphabetically and group them by type (standard library, third-party, local). (Add specific rules if conventions are observed.)
*   **Formatting:** Use a consistent indentation (e.g., 2 spaces) and brace style. (Consider using a formatter like Prettier or RuboCop.)
*   **Types:** Use type annotations where appropriate for clarity and safety. (Elaborate based on project needs, e.g., TypeScript/Sorbet.)
*   **Naming Conventions:**
    *   **Variables and Methods:** Use `snake_case`.
    *   **Classes and Modules:** Use `CamelCase`.
    *   **Constants:** Use `SCREAMING_SNAKE_CASE`.
*   **Error Handling:** Implement consistent error handling, possibly using custom error classes or a centralized error-handling mechanism. (Add specific examples if found.)
*   **Comments:** Write clear and concise comments for complex logic or non-obvious code.

## Cursor/Copilot Rules

*   (No specific Cursor or Copilot rules found in provided information.)

## Environment Variables

*   Refer to `config/database.yml` and `config/credentials.yml.enc` for database and credential management.

## Additional Notes

*   The project uses `esbuild` for JavaScript bundling, as indicated by `package.json`.
*   Consider adding linting commands to `package.json` for automated code quality checks.
*   Pay attention to deprecation warnings, such as the one for `WebAuthn.origin`.`