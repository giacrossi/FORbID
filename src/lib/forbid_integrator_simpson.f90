!< FORbID integrator: provide the Simpson's rule.
module FORbID_integrator_simpson
!-----------------------------------------------------------------------------------------------------------------------------------
!< FORbID integrator: provide the Simpson's rule
!<
!< Considering the following problem:
!<
!< $$ \int_a^b f(x) = ? $$
!<
!< where \(f(x)\), a generic integrand function, the problem is to perform its definite integral.
!< The implemented Simpson's rule is:
!<
!< $$ \int_a^b f(x) = \frac{b-a}{6} \left[ f(a) + 4f \left(\frac{a+b}{2} \right) + f(b) \right]$$
!-----------------------------------------------------------------------------------------------------------------------------------

!-----------------------------------------------------------------------------------------------------------------------------------
use FORbID_kinds, only : R_P
use FORbID_adt_integrand, only : integrand
!-----------------------------------------------------------------------------------------------------------------------------------

!-----------------------------------------------------------------------------------------------------------------------------------
implicit none
private
public :: simpson_integrator
!-----------------------------------------------------------------------------------------------------------------------------------

!-----------------------------------------------------------------------------------------------------------------------------------
type :: simpson_integrator
  !< FORbID integrator: provide the Simpson's rule.
  !<
  !< @note The integrator can be used directly without any initialization.
  contains
    procedure, nopass, public :: integrate !< Integrate integrand function.
endtype simpson_integrator
!-----------------------------------------------------------------------------------------------------------------------------------
contains
  function integrate(f, a, b) result(integral)
  !---------------------------------------------------------------------------------------------------------------------------------
  !< Integrate function *f* with the Simpson's rule.
  !---------------------------------------------------------------------------------------------------------------------------------
  class(integrand), intent(IN) :: f        !< Function to be integrated.
  real(R_P),        intent(IN) :: a        !< Lower bound.
  real(R_P),        intent(IN) :: b        !< Upper bound.
  real(R_P)                    :: integral !< Definite integral value.
  !---------------------------------------------------------------------------------------------------------------------------------

  !---------------------------------------------------------------------------------------------------------------------------------
  integral = (f%f(a) + 4._R_P * f%f((a + b) / 2._R_P)+ f%f(b)) * (b - a) / 6._R_P
  return
  !---------------------------------------------------------------------------------------------------------------------------------
  endfunction integrate
endmodule FORbID_integrator_simpson
