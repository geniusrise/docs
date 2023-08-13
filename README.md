# Geniusrise Docs

Welcome to the Geniusrise documentation repository. This repository contains the source files for the Geniusrise documentation, built using MkDocs and the Material theme.

## Table of Contents

- [Geniusrise Docs](#geniusrise-docs)
  - [Table of Contents](#table-of-contents)
  - [Structure](#structure)
  - [Theme and Appearance](#theme-and-appearance)
  - [Extensions and Plugins](#extensions-and-plugins)
  - [Contributing](#contributing)
  - [Building Locally](#building-locally)

## Structure

The documentation is structured as follows:

- **Home**: The landing page of the documentation.
- **Getting Started**: An introduction and guide to get started with Geniusrise.
- **Core Reference**: Detailed reference documentation, further divided into:
  - CLI Tools: Documentation for `boltctl`, `discover`, `geniusctl`, `schema`, `spoutctl`, and `yamlctl`.
  - Core Components: Documentation for `bolt`, `spout`, and various data and state components.
  - Tasks: Documentation for task-related components like `base`, `ecs`, and `k8s`.

## Theme and Appearance

The documentation uses the Material theme with the following customizations:

- **Palette**:
  - Scheme: Slate
  - Primary Color: Pink
  - Accent Color: Deep Purple
- **Font**:
  - Text: Fira Code
  - Code: Source Code Pro
- **Logo**: A custom logo located at `assets/logo-1.jpg`.
- **Features**: Several features like instant navigation, tracking, expandable sections, and auto-hiding header.

## Extensions and Plugins

The documentation utilizes several MkDocs extensions and plugins:

- **Table of Contents**: With permalinks enabled.
- **Search**: Provides a search functionality across the documentation.
- **Mkdocstrings**: For auto-generating documentation from Python docstrings.
- **Print-site**: For printing the entire site with a custom banner.

## Contributing

Contributions to the documentation are welcome! If you find any issues or areas of improvement, please open an issue or submit a pull request.

## Building Locally

To build the documentation locally:

1. Ensure you have MkDocs and the required plugins installed.
2. Clone this repository.
3. Navigate to the repository directory and run:
   ```bash
   mkdocs serve
   ```
4. Open your browser and go to `http://127.0.0.1:8000/`.

