!< Define sin function that is a concrete extension of the abstract integrand type.
module type_sin
!-----------------------------------------------------------------------------------------------------------------------------------
!< Define sin function that is a concrete extension of the abstract integrand type.
!-----------------------------------------------------------------------------------------------------------------------------------

!-----------------------------------------------------------------------------------------------------------------------------------
use FORbID_kinds, only : R_P
use FORbID, only : integrand
!-----------------------------------------------------------------------------------------------------------------------------------

!-----------------------------------------------------------------------------------------------------------------------------------
implicit none
private
public :: sinf
!-----------------------------------------------------------------------------------------------------------------------------------

!-----------------------------------------------------------------------------------------------------------------------------------
type, extends(integrand) :: sinf
  !< sin function.
  private
  real(R_P) :: w=0._R_P !< Frequency of trigonometric function.
  contains
    ! auxiliary methods
    procedure, pass(self), public :: init !< Init field.
    ! ADT integrand deferred methods
    procedure, pass(self), public :: f => sin_x !< Time derivative, residuals.
endtype sinf
!-----------------------------------------------------------------------------------------------------------------------------------
contains
  ! auxiliary methods
  subroutine init(self, w)
  !---------------------------------------------------------------------------------------------------------------------------------
  !< Construct an initialized sin function.
  !---------------------------------------------------------------------------------------------------------------------------------
  class(sinf), intent(INOUT) :: self !< sin function.
  real(R_P),   intent(IN)    :: w    !< Frequency.
  !---------------------------------------------------------------------------------------------------------------------------------

  !---------------------------------------------------------------------------------------------------------------------------------
  self%w = w
  return
  !---------------------------------------------------------------------------------------------------------------------------------
  endsubroutine init

  ! ADT integrand deferred methods
  function sin_x(self, x, y, z) result(f)
  !---------------------------------------------------------------------------------------------------------------------------------
  !---------------------------------------------------------------------------------------------------------------------------------
  class(sinf),         intent(IN) :: self !< sin function.
  real(R_P),           intent(IN) :: x    !< X abscissa.
  real(R_P), optional, intent(IN) :: y    !< Y abscissa.
  real(R_P), optional, intent(IN) :: z    !< Z abscissa.
  real(R_P)                       :: f    !< Result of the time derivative function of integrand field.
  !---------------------------------------------------------------------------------------------------------------------------------

  !---------------------------------------------------------------------------------------------------------------------------------
  f = sin(self%w * x)
  return
  !---------------------------------------------------------------------------------------------------------------------------------
  endfunction sin_x
endmodule type_sin
