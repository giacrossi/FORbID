!< gr integrator: provide the trapezoidal rule.
module gr_integrator_trapezoidal
!-----------------------------------------------------------------------------------------------------------------------------------
!< gr integrator: provide the trapezoidal rule.
!<
!< Considering the following problem:
!<
!< $$ \int_a^b f(x) = ? $$
!<
!< where \(f(x)\), a generic integrand function, the problem is to perform its definite integral.
!< The implemented trapezoidal rule is:
!<
!< $$ \int_a^b f(x) = (b-a)\frac{f(a)+f(b)}{2}$$
!-----------------------------------------------------------------------------------------------------------------------------------

!-----------------------------------------------------------------------------------------------------------------------------------
use gr_kinds, only : R_P
use gr_adt_integrand, only : integrand
!-----------------------------------------------------------------------------------------------------------------------------------

!-----------------------------------------------------------------------------------------------------------------------------------
implicit none
private
public :: trapezoidal_integrator
!-----------------------------------------------------------------------------------------------------------------------------------

!-----------------------------------------------------------------------------------------------------------------------------------
type :: trapezoidal_integrator
  !< gr integrator: provide the trapezoidal rule.
  !<
  !< @note The integrator can be used directly without any initialization.
  contains
    procedure, nopass, public :: integrate !< Integrate integrand function.
endtype trapezoidal_integrator
!-----------------------------------------------------------------------------------------------------------------------------------
contains
  function integrate(f, a, b) result(integral)
  !---------------------------------------------------------------------------------------------------------------------------------
  !< Integrate function *f* with the trapezoidal rule.
  !---------------------------------------------------------------------------------------------------------------------------------
  class(integrand), intent(IN) :: f        !< Function to be integrated.
  real(R_P),        intent(IN) :: a        !< Lower bound.
  real(R_P),        intent(IN) :: b        !< Upper bound.
  real(R_P)                    :: integral !< Definite integral value.
  !---------------------------------------------------------------------------------------------------------------------------------

  !---------------------------------------------------------------------------------------------------------------------------------
  integral = (f%f(a) + f%f(b)) * 0.5_R_P * (b - a)
  return
  !---------------------------------------------------------------------------------------------------------------------------------
  endfunction integrate
endmodule gr_integrator_trapezoidal
