# StanModels


[![][travis-img]][travis-url] 


## Introduction

This package contains Julia versions of the mcmc models contained in the R package "rethinking" associated with the book [Statistical Rethinking](https://xcelab.net/rm/statistical-rethinking/) by Richard McElreath. It is part of the [StatisticalRethinkingJulia](https://github.com/StatisticalRethinkingJulia) Github organization of packages.

This package contains the [Stan](https://github.com/StanJulia) versions.

## Versions

### v1.0.0

- All scripts now use StanSample.jl (instead of CmdStan.jl).
- Chapters have changed and in some cases the chapter numbers need to be updated (which I will do as I update StatisticalRethinking.jl).
- This repo now only contains a representative subset of the models.

### v0.x.x

- All scripts use CmdStan.jl.
- Documentation is generated using Literate.jl.

## Questions and issues

Question and contributions are very welcome, as are feature requests and suggestions. Please open an [issue][issues-url] if you encounter any problems or have a question.

[travis-img]: https://travis-ci.org/StatisticalRethinkingJulia/StanModels.jl.svg?branch=master
[travis-url]: https://travis-ci.org/StatisticalRethinkingJulia/StanModels.jl

[issues-url]: https://github.com/StatisticalRethinkingJulia/StanModels.jl/issues
