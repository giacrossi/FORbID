!< FORbID, Fortran Object oriented ...
module FORbID
!-----------------------------------------------------------------------------------------------------------------------------------
!< FORbID, Fortran Object oriented ...
!-----------------------------------------------------------------------------------------------------------------------------------

!-----------------------------------------------------------------------------------------------------------------------------------
use FORbID_adt_integrand, only : integrand
use FORbID_integrator_midpoint,    only : midpoint_integrator
use FORbID_integrator_trapezoidal, only : trapezoidal_integrator
use FORbID_integrator_simpson,     only : simpson_integrator
!-----------------------------------------------------------------------------------------------------------------------------------

!-----------------------------------------------------------------------------------------------------------------------------------
implicit none
private
public :: integrand
public :: midpoint_integrator
public :: trapezoidal_integrator
public :: simspon_integrator
!-----------------------------------------------------------------------------------------------------------------------------------
endmodule FORbID
