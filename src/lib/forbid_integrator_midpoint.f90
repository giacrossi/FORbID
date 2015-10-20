!< FORbID integrator: provide the midpoint rule.
module FORbID_integrator_midpoint
!-----------------------------------------------------------------------------------------------------------------------------------
!< FORbID integrator: provide the midpoint rule.
!<
!< Considering the following problem:
!<
!< $$ \int_a^b f(x) = ? $$
!<
!< where \(f(x)\), a generic integrand function, the problem is to perform its definite integral.
!< The implemented midpoint rule is:
!<
!< $$ \int_a^b f(x) = (b-a) f(a)$$
!-----------------------------------------------------------------------------------------------------------------------------------

!-----------------------------------------------------------------------------------------------------------------------------------
use FORbID_kinds, only : R_P
use FORbID_adt_integrand, only : integrand
!-----------------------------------------------------------------------------------------------------------------------------------

!-----------------------------------------------------------------------------------------------------------------------------------
implicit none
private
public :: midpoint_integrator
!-----------------------------------------------------------------------------------------------------------------------------------

!-----------------------------------------------------------------------------------------------------------------------------------
type :: midpoint_integrator
  !< FORbID integrator: provide the midpoint rule.
  !<
  !< @note The integrator can be used directly without any initialization.
  contains
    procedure, nopass, public :: integrate !< Integrate integrand function.
endtype midpoint_integrator
!-----------------------------------------------------------------------------------------------------------------------------------
contains
  function integrate(f, a, b) result(integral)
  !---------------------------------------------------------------------------------------------------------------------------------
  !< Integrate function *f* with the midpoint rule.
  !---------------------------------------------------------------------------------------------------------------------------------
  class(integrand), intent(IN) :: f        !< Function to be integrated.
  real(R_P),        intent(IN) :: a        !< Lower bound.
  real(R_P),        intent(IN) :: b        !< Upper bound.
  real(R_P)                    :: integral !< Definite integral value.
  !---------------------------------------------------------------------------------------------------------------------------------

  !---------------------------------------------------------------------------------------------------------------------------------
  integral = f%f(a) * (b - a)
  return
  !---------------------------------------------------------------------------------------------------------------------------------
  endfunction integrate
endmodule FORbID_integrator_midpoint
