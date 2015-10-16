<a name="top"></a>

# FORbID

[![License](https://img.shields.io/badge/license-GNU%20GeneraL%20Public%20License%20v3,%20GPLv3-blue.svg)]()
[![License](https://img.shields.io/badge/license-BSD2-red.svg)]()
[![License](https://img.shields.io/badge/license-BSD3-red.svg)]()
[![License](https://img.shields.io/badge/license-MIT-red.svg)]()

[![Status](https://img.shields.io/badge/status-alpha-orange.svg)]()
[![GitHub issues](https://img.shields.io/github/issues/Fortran-FOSS-Programmers/FORbID.svg)]()

### FORbID, FORtran Integral Definite solver

- FORbID is a pure Fortran (KISS) library for numerical integration of definite integrals;
- FORbID is Fortran 2008+ standard compliant;
- FORbID is OOP designed;
- FORbID is a Free, Open Source Project.

#### Table of Contents

+ [What is FORbID?](#what-is-FORbID?)
+ [Main features](#main-features)
+ [Status](#status)
+ [Copyrights](#copyrights)
+ [Documentation](#documentation)

## What is FORbID?

With modern Fortran standards (2003+) introduction, is possible to develop a KISS and lightweight library for numerical integration of definite integrals using the new features of Object Oriented Programming like Abstract Data Type (ADT).

Go to [Top](#top)

## Main features

FORbID is aimed to be a KISS-pure-Fortran library for numerical integration of definite integrals.

+ [ ] Pure Fortran implementation;
+ [ ] KISS and user-friendly:
    + [ ] simple API, presently based on the Rouson's Abstract Data Type Pattern [2];
    + [ ] easy building and porting on heterogeneous architectures;
+ [ ] comprehensive integrators set out-of-the-box [1]:
    + [ ] primitive rules:
        + [ ] midpoint rule;
        + [x] trapezoidal rule;
        + [ ] composite trapezoidal rule;
    + [ ] Simpson's rule;
    + [ ] Nonequally spaced abscissas:
        + [ ] spline interpolation
    + [ ] Integration formulas of interpolatory type:
        + [ ] Newton-Cotes interpolation formulas;
        + [ ] Fejér interpolation formulas;
        + [ ] Clenshar-Curtis interpolation formulas;
    + [ ] Adaptive quadrature
    + [ ] Gaussian quadrature formulae:
        + [ ] Gauss-Kronrod formulae:
        + [ ] Montecarlo schemes for multidimensional function;
        + [ ] acceleration methods;
+ [ ] efficient:
    + [ ] high scalability on parallel architectures:
        + [ ] support for shared memory multi/many cores architecture;
        + [ ] support for distributed memory cluster;
+ [ ] [Tests-Driven](https://github.com/Fortran-FOSS-Programmers/FOODiE/wiki/Examples) Developed ([TDD](https://en.wikipedia.org/wiki/Test-driven_development)):
+ [ ] well documented:
    + [ ] clear documentation of schemes implementations;
    + [ ] comprehensive [wiki](https://github.com/Fortran-FOSS-Programmers/FORbID/wiki):
+ [x] collaborative developed on [GitHub](https://github.com/giacombum/FORbID);
+ [x] [FOSS licensed](https://github.com/giacombum/FORbID/wiki/Copyrights);

Any feature request is welcome.

#### Bibliography

[1] *Methods of Numerical Integration*, Davis, P. J., Rabinowitz, P., Elsevier, 1984, [link]http://www.sciencedirect.com/science/article/pii/B9780122063602500017

[2] *Scientific Software Design: The Object-Oriented Way*, Rouson, Damian and Xia, Jim and Xu, Xiaofeng, 2011, ISBN 9780521888134, Cambridge University Press, New York, NY, USA.

## Status [![Status](https://img.shields.io/badge/status-beta-orange.svg)]()

FORbID project is just started.

We are searching for Fortraners enthusiast joining our team.

## Copyrights

FORbID is an open source project, it is distributed under a multi-licensing system:

+ for FOSS projects:
  - [GPL v3](http://www.gnu.org/licenses/gpl-3.0.html);
+ for closed source/commercial projects:
  - [BSD 2-Clause](http://opensource.org/licenses/BSD-2-Clause);
  - [BSD 3-Clause](http://opensource.org/licenses/BSD-3-Clause);
  - [MIT](http://opensource.org/licenses/MIT).

Anyone is interest to use, to develop or to contribute to FORbID is welcome, feel free to select the license that best matches your soul!

More details can be found on [wiki](https://github.com/giacombum/FORbID/wiki/Copyrights).

Go to [Top](#top)

## Documentation

Besides this README file the FORbID documentation is contained into its own [wiki](https://github.com/giacombum/FORbID/wiki). Detailed documentation of the API is contained into the [GitHub Pages](http://Fortran-FOSS-Programmers.github.io/FORbID/index.html) that can also be created locally by means of [ford tool](https://github.com/cmacmackin/ford).

Go to [Top](#top)
