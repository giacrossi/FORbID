!< FORbID integrator: provide the Newton-Cotes six points rule.
module FORbID_integrator_newton_cotes6
!-----------------------------------------------------------------------------------------------------------------------------------
!< FORbID integrator: provide the Newton-Cotes six points rule.
!<
!< Considering the following problem:
!<
!< $$ \int_a^b f(x) = ? $$
!<
!< where \(f(x)\), a generic integrand function, the problem is to perform its definite integral.
!< The implemented Newton-Cotes six points rule is:
!<
!< $$ \int_a^b f(x) = 5 \frac{b-a}{576} \left[ 19f(a) + 75f \left(\frac{a+b}{5} \right) + 50f \left(2\frac{a+b}{5} \right) + 50f \left(3\frac{a+b}{5} \right) + 75f \left(4\frac{a+b}{5} \right) + 19f(b) \right]$$
!-----------------------------------------------------------------------------------------------------------------------------------

!-----------------------------------------------------------------------------------------------------------------------------------
use FORbID_kinds, only : R_P
use FORbID_adt_integrand, only : integrand
!-----------------------------------------------------------------------------------------------------------------------------------

!-----------------------------------------------------------------------------------------------------------------------------------
implicit none
private
public :: newton_cotes6_integrator
!-----------------------------------------------------------------------------------------------------------------------------------

!-----------------------------------------------------------------------------------------------------------------------------------
type :: newton_cotes6_integrator
  !< FORbID integrator: provide the Newton-Cotes six points rule.
  !<
  !< @note The integrator can be used directly without any initialization.
  contains
    procedure, nopass, public :: integrate !< Integrate integrand function.
endtype newton_cotes6_integrator
!-----------------------------------------------------------------------------------------------------------------------------------
contains
  function integrate(f, a, b) result(integral)
  !---------------------------------------------------------------------------------------------------------------------------------
  !< Integrate function *f* with the Newton-Cotes six points rule.
  !---------------------------------------------------------------------------------------------------------------------------------
  class(integrand), intent(IN) :: f        !< Function to be integrated.
  real(R_P),        intent(IN) :: a        !< Lower bound.
  real(R_P),        intent(IN) :: b        !< Upper bound.
  real(R_P)                    :: integral !< Definite integral value.
  !---------------------------------------------------------------------------------------------------------------------------------

  !---------------------------------------------------------------------------------------------------------------------------------
  integral = (19._R_P * f%f(a) + 75._R_P * f%f((a + b) / 5._R_P) + 50._R_P * f%f(2._R_P * (a + b) / 5._R_P) &
    + 50._R_P * f%f(3._R_P * (a + b) / 5._R_P) + 75._R_P * f%f(4._R_P * (a + b) / 5._R_P) + f%f(b)) * 5._R_P * (b - a) / 576._R_P
  return
  !---------------------------------------------------------------------------------------------------------------------------------
  endfunction integrate
endmodule FORbID_integrator_newton_cotes6
