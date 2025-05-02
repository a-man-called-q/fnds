## [0.3.0] - 2025-05-03
### Added
- Non-interactive CLI functionality for automated and scripted workflows
- Enhanced command processing pipeline
- New utility functions for input validation
- Support for unlimited nested command levels (commands can be nested as deep as needed)

### Breaking Changes
- The `question` parameter now accepts a `String` instead of a `Function` in all interactive input functions (`ask`, `confirm`, `select`, `multipleSelect`), I have no idea why I use Function in the first place.

### Fixed
- Improved error handling for invalid inputs
- Fixed console output formatting issues
- Platform supports now supposedly mentions `windows`, `linux`, and `macos` instead of all except `web`

## [0.2.0] - 2025-04-02
### Added
- Initial release of FNDS CLI with interactive selection and question prompts.
- Support for `ask`, `confirm`, `select`, and `multipleSelect` functions.
- Integration with `StateManager` for structured responses.
