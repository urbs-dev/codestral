# codestral

<!-- badges: start -->
[![Lifecycle: stable](https://img.shields.io/badge/lifecycle-stable-brightgreen.svg)](https://lifecycle.r-lib.org/articles/stages.html#stable)
<!-- badges: end -->

**codestral** is an R package that provides an RStudio addin for interacting with Mistral AI models using their API. It supports both Fill-in-the-Middle (FIM) code completion and chat functionality.

## Features

- **Fill-in-the-Middle (FIM)**: Get code completion suggestions based on context
- **Chat functionality**: Interact with Codestral and Codestral Mamba models
- **File inclusion**: Easily include file contents in your prompts
- **Package-aware**: Automatically detects R package environments

## Installation

You can install the development version from GitHub:

``` r
# install.packages("pak")
pak::pak("urbs-dev/codestral")
```

## Getting Started

For detailed usage instructions and examples, please refer to the [codestral-introduction vignette](https://urbs-dev.github.io/codestral/articles/codestral-introduction.html).

## Quick Setup

1. Get your API keys from [Mistral AI Platform](https://mistral.ai/news/la-plateforme)
2. Initialize the package:

``` r
library(codestral)
codestral_init(mistral_apikey = "your-api-key-here", codestral_apikey = "your_codestral-api-key-here")
```

3. Use the RStudio addin "Codestral code completion" to interact with the models

## Documentation

``` r
library(codestral)
vignette("codestral-introduction")
``` 

## License

This package is licensed under the MIT License. See [LICENSE](LICENSE.md) for details.
