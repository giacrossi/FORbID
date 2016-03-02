!< FORbID integrator: provide the Romberg formula.
module FORbID_integrator_romberg
!-----------------------------------------------------------------------------------------------------------------------------------
!< FORbID integrator: provide the Romberg formula.
!<
!< Considering the following problem:
!<
!< $$ \int_a^b f(x) = ? $$
!<
!< where \(f(x)\), a generic integrand function, the problem is to perform its definite integral.
!< The Romberg's method (Romberg 1955) is used to estimate the definite integral by applying Richardson extrapolation
!< repeatedly on the trapezium rule or the rectangle rule (midpoint rule): the estimates generate a triangular array.
!<
!< Using
!< $$ h_n = \frac{1}{2^n} (b-a)$$
!< the method can be defined by
!< $$R(0,0) = h_1 \left( f(a) + f(b) \right)$$
!< $$R(n,0) = \frac{1}{1} R(n-1,0) + h_n \sum_{k=1}^{2^n-1} f(a + (2k-1)h_n)$$
!< $$R(n.m) = R(n,m-1) + \frac{1}{4^m-1} \left( R(n,m-1) - R(n-1,m-1) \right)$$
!-----------------------------------------------------------------------------------------------------------------------------------

!-----------------------------------------------------------------------------------------------------------------------------------
use FORbID_kinds, only : R_P, I_P
use FORbID_adt_integrand, only : integrand
!-----------------------------------------------------------------------------------------------------------------------------------

!-----------------------------------------------------------------------------------------------------------------------------------
implicit none
private
public :: romberg_integrator
!-----------------------------------------------------------------------------------------------------------------------------------

!-----------------------------------------------------------------------------------------------------------------------------------
type :: romberg_integrator
  !< FORbID integrator: provide the Romberg rule.
  !<
  !< @note The integrator must be initialized (initialize the coefficient and the weights) before used.
  integer(I_P)           :: n        !< Degree of integration formula.
  real(R_P)              :: tol      !< Tolerance
  contains
    procedure, pass(self), public :: init      !< Initialize the integrator.
    procedure, nopass,     public :: integrate !< Integrate integrand function.
endtype romberg_integrator
!-----------------------------------------------------------------------------------------------------------------------------------
contains
  elemental subroutine init(self, n, tol)
  !---------------------------------------------------------------------------------------------------------------------------------
  !< Create the Romberg integration formula: initialize the weights and the coefficient k.
  !---------------------------------------------------------------------------------------------------------------------------------
  class(romberg_integrator), intent(INOUT) :: self   !< Romberg integrator.
  integer(I_P),              intent(IN)    :: n      !< Number of extrapolations.
  real(R_P),                 intent(IN)    :: tol    !< Tolerance parameter.
  self%n = n
  self%tol = tol
  endsubroutine init

  function integrate(self, f, a, b) result(integral)
  !---------------------------------------------------------------------------------------------------------------------------------
  !< Integrate function *f* with the Romberg formula.
  !---------------------------------------------------------------------------------------------------------------------------------
  class(romberg_integrator), intent(IN) :: self     !< Actual Romberg integrator.
  class(integrand),          intent(IN) :: f        !< Function to be integrated.
  real(R_P),                 intent(IN) :: a        !< Lower bound.
  real(R_P),                 intent(IN) :: b        !< Upper bound.
  real(R_P)                             :: integral !< Definite integral value.
  integer(I_P)                          :: i,k      !< Integration indexes.
  real(R_P)                             :: M        !< Midpoint value.
  real(R_P)                             :: h        !< Step size.
  real(R_P), allocatable                :: R(:,:)   !< Integral results.
  !---------------------------------------------------------------------------------------------------------------------------------

  !---------------------------------------------------------------------------------------------------------------------------------
  if (allocated(R)) deallocate(R); allocate(R(0:self%n,0:self%n)); R = 0._R_P
  h = b - a
  R(0,0) = h*(f%f(a) + f%f(b))/2._R_P;
  do i = 1,self%n
    h = h/2._R_P
    M = 0._R_P
    do k = 1,2**(i-1)
      M = M + f%f(a+(2._R_P*k-1._R_P)*h)
    enddo
    R(i,0) = R(i-1,0) / 2._R_P + h*M
    do k = 1,i
      R(i,k) = R(i,k-1) + (R(i,k-1) - R(i-1,k-1))/(4._R_P**k - 1._R_P)
    enddo
    if (abs(R(i,i-1)-R(i,i))<=self%tol) exit
  enddo
  integral = R(i,i)
  return
  !---------------------------------------------------------------------------------------------------------------------------------
  endfunction integrate
endmodule FORbID_integrator_romberg
