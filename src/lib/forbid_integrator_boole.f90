!< FORbID integrator: provide the Boole's rule, from the family of Newton-Cotes.
module FORbID_integrator_boole
!-----------------------------------------------------------------------------------------------------------------------------------
!< FORbID integrator: provide the Boole's rule
!<
!< Considering the following problem:
!<
!< $$ \int_a^b f(x) = ? $$
!<
!< where \(f(x)\), a generic integrand function, the problem is to perform its definite integral.
!< The implemented Boole's rule is:
!<
!< $$ \int_a^b f(x) = \frac{b-a}{45} \left[ 7f(a) + 32f \left(\frac{a+b}{4} \right) + 12f \left(\frac{a+b}{2} \right) + 32f
!\left(\frac{3(a+b)}{4} \right) + 7f(b) \right]$$
!-----------------------------------------------------------------------------------------------------------------------------------

!-----------------------------------------------------------------------------------------------------------------------------------
use FORbID_kinds, only : R_P
use FORbID_adt_integrand, only : integrand
!-----------------------------------------------------------------------------------------------------------------------------------

!-----------------------------------------------------------------------------------------------------------------------------------
implicit none
private
public :: boole_integrator
!-----------------------------------------------------------------------------------------------------------------------------------

!-----------------------------------------------------------------------------------------------------------------------------------
type :: boole_integrator
  !< FORbID integrator: provide the Boole's rule.
  !<
  !< @note The integrator can be used directly without any initialization.
  contains
    procedure, nopass, public :: integrate !< Integrate integrand function.
endtype boole_integrator
!-----------------------------------------------------------------------------------------------------------------------------------
contains
  function integrate(f, a, b) result(integral)
  !---------------------------------------------------------------------------------------------------------------------------------
  !< Integrate function *f* with the Boole's rule.
  !---------------------------------------------------------------------------------------------------------------------------------
  class(integrand), intent(IN) :: f        !< Function to be integrated.
  real(R_P),        intent(IN) :: a        !< Lower bound.
  real(R_P),        intent(IN) :: b        !< Upper bound.
  real(R_P)                    :: integral !< Definite integral value.
  !---------------------------------------------------------------------------------------------------------------------------------

  !---------------------------------------------------------------------------------------------------------------------------------
  integral = (7._R_P * f%f(a) + 32._R_P * f%f((a + b) / 4._R_P) + 12._R_P * f%f((a + b) / 2._R_P) + 32._R_P * f%f(3._R_P * (a + b) &
  / 4._R_P) + 7._R_P * f%f(b)) * (b - a) / 45._R_P
  return
  !---------------------------------------------------------------------------------------------------------------------------------
  endfunction integrate
endmodule FORbID_integrator_boole
