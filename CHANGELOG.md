# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [1.0.0] - 2025-08-02

### Added
- **BREAKING**: Optional `of:` parameter for enhanced validation
- `InvalidCaseError` - raised when cases are not in the allowed `of:` list
- `MissingCaseError` - raised when not all `of:` values are handled
- Comprehensive validation ensuring all cases belong to specified list
- Requirement that all `of:` values must have corresponding cases
- Full backward compatibility when `of:` parameter is not used

### Changed
- **BREAKING**: `exhaustive_case` signature now accepts optional `of:` parameter

### Technical
- 100% test coverage maintained
- Full RuboCop compliance with comprehensive documentation
- GitHub Actions CI/CD pipeline with multi-Ruby version testing
- Automated dependency management via Dependabot

## [0.1.0] - 2025-08-02

### Added
- Initial implementation of `exhaustive_case` method
- Support for single and multiple value matching in `on` clauses
- Automatic error raising for unhandled cases via `UnhandledCaseError`
- Core gem structure and configuration
- RSpec testing framework setup
- RuboCop linting configuration
- Development scripts (`bin/setup`, `bin/console`)

[Unreleased]: https://github.com/yourusername/exhaustive_case/compare/v1.0.0...HEAD
[1.0.0]: https://github.com/yourusername/exhaustive_case/releases/tag/v1.0.0
[0.1.0]: https://github.com/yourusername/exhaustive_case/releases/tag/v0.1.0
