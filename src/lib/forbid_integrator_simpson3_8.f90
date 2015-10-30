!< FORbID integrator: provide the Simpson's rule with factor 3/8.
module FORbID_integrator_simpson3_8
!-----------------------------------------------------------------------------------------------------------------------------------
!< FORbID integrator: provide the Simpson's rule with factor 3/8.
!<
!< Considering the following problem:
!<
!< $$ \int_a^b f(x) = ? $$
!<
!< where \(f(x)\), a generic integrand function, the problem is to perform its definite integral.
!< The implemented Simpson's rule is:
!<
!< $$ \int_a^b f(x) = 3 \frac{b-a}{16} \left[ f(a) + 3f \left(a + \frac{b-a}{3} \right) + 3f \left(a + 2\frac{b-a}{3} \right) + f(b) \right]$$
!-----------------------------------------------------------------------------------------------------------------------------------

!-----------------------------------------------------------------------------------------------------------------------------------
use FORbID_kinds, only : R_P
use FORbID_adt_integrand, only : integrand
!-----------------------------------------------------------------------------------------------------------------------------------

!-----------------------------------------------------------------------------------------------------------------------------------
implicit none
private
public :: simpson3_8_integrator
!-----------------------------------------------------------------------------------------------------------------------------------

!-----------------------------------------------------------------------------------------------------------------------------------
type :: simpson3_8_integrator
  !< FORbID integrator: provide the Simpson's rule with factor 3/8.
  !<
  !< @note The integrator can be used directly without any initialization.
  contains
    procedure, nopass, public :: integrate !< Integrate integrand function.
endtype simpson3_8_integrator
!-----------------------------------------------------------------------------------------------------------------------------------
contains
  function integrate(f, a, b) result(integral)
  !---------------------------------------------------------------------------------------------------------------------------------
  !< Integrate function *f* with the Simpson's rule with factor 3/8.
  !---------------------------------------------------------------------------------------------------------------------------------
  class(integrand), intent(IN) :: f        !< Function to be integrated.
  real(R_P),        intent(IN) :: a        !< Lower bound.
  real(R_P),        intent(IN) :: b        !< Upper bound.
  real(R_P)                    :: integral !< Definite integral value.
  !---------------------------------------------------------------------------------------------------------------------------------

  !---------------------------------------------------------------------------------------------------------------------------------
  integral = (f%f(a) + 3._R_P * f%f(a + (b - a) / 3._R_P) + 3._R_P * f%f(a + 2._R_P * (b - a) / 3._R_P) + f%f(b)) * 3._R_P &
    * (b - a) / 16._R_P
  return
  !---------------------------------------------------------------------------------------------------------------------------------
  endfunction integrate
endmodule FORbID_integrator_simpson3_8
