# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.1.0] - 2025

### Added
- Initial release.
- Lua filter that collects all external links (http, https, ftp) from a Quarto revealjs presentation.
- Deduplication: links appearing multiple times are listed only once.
- Automatic "Further reading" slide appended at the end of the presentation.
- Scrollable slide when more than 6 links are collected.
- Customizable slide title, subtitle, and scroll message via YAML (`further-reading` key).
- Minimum and medium usage examples in `docs/`.
