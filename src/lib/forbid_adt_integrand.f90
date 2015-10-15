!< Define the abstract type *integrand* for building integrators.
module gr_adt_integrand
!-----------------------------------------------------------------------------------------------------------------------------------
!< Define the abstract type *integrand* for building integrators.
!-----------------------------------------------------------------------------------------------------------------------------------

!-----------------------------------------------------------------------------------------------------------------------------------
use gr_kinds, only : R_P
!-----------------------------------------------------------------------------------------------------------------------------------

!-----------------------------------------------------------------------------------------------------------------------------------
implicit none
private
public :: integrand
!-----------------------------------------------------------------------------------------------------------------------------------

!-----------------------------------------------------------------------------------------------------------------------------------
type, abstract :: integrand
  !< Abstract type for building integrators.
  contains
    ! public deferred procedures that concrete integrand-field must implement
    procedure(function_value), pass(self), deferred, public :: f !< f(x).
endtype integrand

abstract interface
  !< Abstract type bound procedures necessary for implementing a concrete extension of the class(integrand).
  function function_value(self, x) result(f)
  !---------------------------------------------------------------------------------------------------------------------------------
  !< f(x), integrand function evaluation.
  !---------------------------------------------------------------------------------------------------------------------------------
  import :: integrand, R_P
  class(integrand), intent(IN)  :: self !< Integrand field.
  real(R_P),        intent(IN)  :: x    !< Independent abscissa value.
  real(R_P)                     :: f    !< Result of the time derivative function of integrand field.
  !---------------------------------------------------------------------------------------------------------------------------------
  endfunction function_value
endinterface
!-----------------------------------------------------------------------------------------------------------------------------------
endmodule gr_adt_integrand
