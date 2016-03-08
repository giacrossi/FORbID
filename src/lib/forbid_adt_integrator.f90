!< Define the abstract type *integrator* for building integrators.
module FORbID_adt_integrator
!-----------------------------------------------------------------------------------------------------------------------------------
!< Define the abstract type *integrator* for building integrators.
!-----------------------------------------------------------------------------------------------------------------------------------

!-----------------------------------------------------------------------------------------------------------------------------------
use FORbID_kinds, only : I_P, R_P
use FORbID_adt_integrand, only : integrand
!-----------------------------------------------------------------------------------------------------------------------------------

!-----------------------------------------------------------------------------------------------------------------------------------
implicit none
private
public :: integrator, adaptive_integrator
!-----------------------------------------------------------------------------------------------------------------------------------

!-----------------------------------------------------------------------------------------------------------------------------------
type, abstract :: integrator
  !< Abstract type for building integrators.
  integer(I_P)           :: n        !< numbers of points of the quadrature (Gauss, Cleshaw-Curtis), degree of integration formula
                                     !< (Newton-Cotes, Romberg).
  contains
    !< Deferred procedures that concrete integrator must implement
    procedure(abstract_integrate), pass(self), deferred, public :: integrate
endtype integrator

abstract interface
  !< Abstract type bound procedure necessary for implementing a concrete extension of the class(integrator).
  function abstract_integrate(self, f, a, b) result(integral)
  !---------------------------------------------------------------------------------------------------------------------------------
  !< Integrate function *f* with one of the integrator chosed.
  !---------------------------------------------------------------------------------------------------------------------------------
  import :: integrator, integrand, R_P
  class(integrator), intent(IN)  :: self     !< Actual integrator.
  class(integrand),  intent(IN)  :: f        !< Integrand field.
  real(R_P),         intent(IN)  :: a        !< Lower bound.
  real(R_P),         intent(IN)  :: b        !< Upper bound.
  real(R_P)                      :: integral !< Result of the definite integral.
  !---------------------------------------------------------------------------------------------------------------------------------
  endfunction abstract_integrate
endinterface

type, extends(integrator), abstract :: adaptive_integrator
  !< Abstract type for building adaptive integrators.
  contains
    procedure, pass(self), public :: adaptive_integrate !< Procedure for the adaptive integration.
    !private
    !procedure       :: adaptive_integrate !< Procedure for the adaptive integration.
    !generic, public :: integrate => adaptive_integrate
endtype adaptive_integrator

contains

recursive subroutine adaptive_integrate(self, f, a, b, b_orig, tol, ad_integral)
  !---------------------------------------------------------------------------------------------------------------------------------
  !< Integrate adaptively function *f* with one of the integrator chosed.
  !---------------------------------------------------------------------------------------------------------------------------------
  class(adaptive_integrator), intent(IN)  :: self                  !< Actual integrator.
  class(integrand),           intent(IN)  :: f                     !< Function to be integrated.
  real(R_P),                  intent(IN)  :: a, b                  !< Lower and Upper bounds.
  real(R_P),                  intent(IN)  :: b_orig                !< Original upper bound.
  real(R_P),                  intent(IN)  :: tol                   !< Tolerance error.
  real(R_P),                  intent(OUT) :: ad_integral           !< Definite integral value.
  real(R_P)                               :: h                     !< Integration step.
  real(R_P)                               :: first_int, second_int !< Temporary integration results.
  !---------------------------------------------------------------------------------------------------------------------------------

  !---------------------------------------------------------------------------------------------------------------------------------
  h = (b - a) / 2._R_P
  first_int  = self%integrate(f=f, a=a, b=b)
  second_int = self%integrate(f=f, a=a, b=a+h) + self%integrate(f=f, a=a+h, b=b)
  if ((abs(second_int - first_int))<tol) then
    ad_integral = second_int + ad_integral
    if ((b_orig - b)>tol) call adaptive_integrate(self, f=f, a=b, b=a+2._R_P*h, tol=tol, b_orig=b_orig, ad_integral=ad_integral)
  else
    call adaptive_integrate(self, f=f, a=a, b=a+h, tol=tol/2._R_P, b_orig=b_orig, ad_integral=ad_integral)
  endif
end subroutine adaptive_integrate
!-----------------------------------------------------------------------------------------------------------------------------------
endmodule FORbID_adt_integrator
