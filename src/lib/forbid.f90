!< FORbID, Fortran Object oriented ...
module FORbID
!-----------------------------------------------------------------------------------------------------------------------------------
!< FORbID, Fortran Object oriented ...
!-----------------------------------------------------------------------------------------------------------------------------------

!-----------------------------------------------------------------------------------------------------------------------------------
use FORbID_adt_integrand,              only : integrand
use FORbID_integrator_newton_cotes,    only : newton_cotes_integrator
use FORbID_integrator_gauss,           only : gauss_integrator
use FORbID_integrator_fejer,           only : fejer_integrator
use FORbID_integrator_clenshaw_curtis, only : clenshaw_curtis_integrator
!-----------------------------------------------------------------------------------------------------------------------------------

!-----------------------------------------------------------------------------------------------------------------------------------
implicit none
private
public :: integrand
public :: newton_cotes_integrator
public :: gauss_integrator
public :: fejer_integrator
public :: clenshaw_curtis_integrator
!-----------------------------------------------------------------------------------------------------------------------------------
endmodule FORbID
