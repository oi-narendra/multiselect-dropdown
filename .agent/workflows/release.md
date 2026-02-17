---
description: Release a new version of the Flutter package to pub.dev.
---

# Workflow: Release to pub.dev

Follow this workflow when publishing a new version.

## Pre-Release Checklist

1. **Verify all changes are committed and pushed**

   ```bash
   git status
   ```

2. **Run full quality checks**

   // turbo

   ```bash
   dart format --set-exit-if-changed .
   ```

   // turbo

   ```bash
   dart analyze
   ```

   // turbo

   ```bash
   flutter test
   ```

   All must pass with zero issues.

3. **Verify example app compiles**

   // turbo

   ```bash
   cd example && flutter build apk --debug
   ```

## Version Bump

1. **Determine version increment**
   - **PATCH** (0.0.x): Bug fixes only
   - **MINOR** (0.x.0): New features, backward-compatible
   - **MAJOR** (x.0.0): Breaking changes

2. **Update `pubspec.yaml`**
   - Change `version:` to the new version number.

3. **Finalize CHANGELOG.md**
   - Move items from `## [Unreleased]` to `## [x.y.z] - YYYY-MM-DD`.
   - Ensure all user-visible changes are documented.

4. **Update README.md** if needed
   - Update version references.
   - Add/update feature documentation.

## Publish

1. **Dry run first**

   ```bash
   flutter pub publish --dry-run
   ```

   Review the output:
   - No warnings about missing documentation.
   - No unexpected files being included.
   - Package size is reasonable.

2. **Publish** (requires user confirmation)

   ```bash
   flutter pub publish
   ```

3. **Tag the release**

   ```bash
   git tag v<VERSION>
   git push origin v<VERSION>
   ```

## Post-Release

1. **Verify on pub.dev**
   - Check the package page loads correctly.
   - Verify pub points and analysis scores.
   - Confirm documentation is rendered properly.

2. **Create GitHub release** (optional)

   ```bash
   gh release create v<VERSION> --title "v<VERSION>" --notes "See CHANGELOG.md"
   ```

## Output

Summarize:

- Version published (old → new)
- Type of release (patch/minor/major)
- Key changes in this release
- Pub.dev link
