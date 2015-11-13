!< FORbID, Fortran Object oriented ...
module FORbID
!-----------------------------------------------------------------------------------------------------------------------------------
!< FORbID, Fortran Object oriented ...
!-----------------------------------------------------------------------------------------------------------------------------------

!-----------------------------------------------------------------------------------------------------------------------------------
use FORbID_adt_integrand,              only : integrand
use FORbID_integrator_newton-cotes,    only : newton-cotes_integrator
use FORbID_integrator_gauss,           only : gauss_integrator
use FORbID_integrator_fejer,           only : fejer_integrator
use FORbID_integrator_clenshaw-curtis, only : clenshaw-curtis_integrator
!-----------------------------------------------------------------------------------------------------------------------------------

!-----------------------------------------------------------------------------------------------------------------------------------
implicit none
private
public :: integrand
public :: newton-cotes_integrator
public :: gauss_integrator
public :: fejer_integrator
public :: clenshaw-curtis_integrator
!-----------------------------------------------------------------------------------------------------------------------------------
endmodule FORbID
