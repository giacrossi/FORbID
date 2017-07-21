!< FORbID integrator: provide the Fejer quadrature formulas.
module FORbID_integrator_fejer
!-----------------------------------------------------------------------------------------------------------------------------------
!< FORbID integrator: provide the Fejer quadrature formulas.
!<
!< Considering the following problem:
!<
!< $$ \int_a^b f(x) = ? $$
!<
!< where \(f(x)\), a generic integrand function, the problem is to perform its definite integral.
!< The n-point Fejer quadrature rule is a quadrature rule that is based on an expansion of the integrand in terms of Chebyshev
!< polynomials.
!<
!< The first Fejer formula can be written as
!< $$ \int_{-1}^1 f(x) dx = \sum_{k=1}^n w_k f \left( \cos \frac{2k-1}{2n} \pi \right) $$
!< where
!< $$ w_k = \frac{2}{n} \left( 1 - 2 \sum_{m=1}^{n/2} \frac{ \cos (2m \theta_k ) }{4m^2 -1} \right)
!< and
!< $$\theta_k = \frac{(2k-1) \pi}{2n}$$.
!<
!< The second Fejer formula can be written as
!< $$ \int_{-1}^1 f(x) dx = \sum_{k=1}^n w_k f \left( \cos \frac{k}{n+1} \pi \right) $$
!< where
!< $$ w_k = \frac{2}{n+1} \left( 1 - 2 \sum_{m=1}^{(n-1)/2} \frac{ \cos (2m \theta_k ) }{4m^2 -1 -\frac{1}{p} \cos (p+1) \theta_k} \right)
!< and
!< $$\theta_k = \frac{k \pi}{n+1}$$.
!< $$p = 2 \left[ \frac{(n+1)}{2} \right] -1$$;
!< The \(w_k \) can also be written as:
!< $$ w_k = \frac{4 \sin \theta_k}{n+1} \sum_{m=1}^{(n+1)/2} \frac{ \sin (2m - 1) \theta_k }{2m -1} \right) $$
!-----------------------------------------------------------------------------------------------------------------------------------

!-----------------------------------------------------------------------------------------------------------------------------------
use FORbID_kinds, only : R_P, I_P
use FORbID_adt_integrand,  only : integrand
use FORbID_adt_integrator, only : integrator
!-----------------------------------------------------------------------------------------------------------------------------------

!-----------------------------------------------------------------------------------------------------------------------------------
implicit none
private
public :: fejer_integrator
!-----------------------------------------------------------------------------------------------------------------------------------

!-----------------------------------------------------------------------------------------------------------------------------------
type, extends(integrator) :: fejer_integrator
  !< FORbID integrator: provide the Fejer quadrature.
  !<
  !< @note The integrator must be initialized (initialize the coefficient and the weights) before used.
  real(R_P), allocatable    :: w(:)     !< Integration weights.
  real(R_P), allocatable    :: x(:)     !< Integration nodes.
  real(R_P), allocatable    :: y(:)     !< Integration nodes.
  real(R_P), allocatable    :: z(:)     !< Integration nodes.
  contains
    procedure, pass(self), public :: init         !< Initialize the integrator.
    procedure, pass(self), public :: integrate_1D !< Integrate 1D integrand function.
    procedure, pass(self), public :: integrate_2D !< Integrate 2D integrand function.
    procedure, pass(self), public :: integrate_3D !< Integrate 3D integrand function.
endtype fejer_integrator
!-----------------------------------------------------------------------------------------------------------------------------------
contains
  elemental subroutine init(self, n, d)
  !---------------------------------------------------------------------------------------------------------------------------------
  !< Create the Fejer quadrature: initialize the weights and the roots
  !---------------------------------------------------------------------------------------------------------------------------------
  class(fejer_integrator), intent(INOUT) :: self                      !< Fejer integrator.
  integer(I_P),            intent(IN)    :: n                         !< Number of integration nodes.
  integer(I_P),            intent(IN)    :: d                         !< Number of integration dimensions.
  real(R_P),               parameter     :: pi=4._R_P * atan(1._R_P)  !< Pi Greek.
  real(R_P)                              :: app, theta                !< Dummy variable and theta_k.
  integer(I_P)                           :: i, m                      !< Counters for cycles.
  self%n = n
  if (allocated(self%w)) deallocate(self%w); allocate(self%w(1:n)); self%w = 0._R_P
  if (allocated(self%x)) deallocate(self%x); allocate(self%x(1:n)); self%x = 0._R_P
  if (MOD(n,2_I_P)==0) then
    do i=1,n
      self%x(i) = cos((2._R_P * i - 1._R_P)/(2._R_P * self%n) * pi)
      theta     = (2._R_P * i - 1._R_P ) * pi / (2._R_P * self%n)
      app       = 0._R_P
      do m=1,n/2
        app = app + cos(2._R_P * m * theta) / ( 4._R_P * m**2._R_P - 1._R_P )
      enddo
      self%w(i) = (2._R_P / self%n) * (1._R_P - 2._R_P * app)
    enddo
  else
    do i=1,n
      self%x(i) = cos((i * pi)/(self%n + 1._R_P))
      theta     = i * pi / (self%n + 1._R_P)
      app       = 0._R_P
      do m=1,(n-1)/2
        app = app + sin((2._R_P * m - 1._R_P) * theta) / ( 2._R_P * m - 1._R_P )
      enddo
      self%w(i) = app * (4._R_P * sin(theta)) / (self%n + 1._R_P)
    enddo
  endif
  select case(d)
  case(2)
    if (allocated(self%y)) deallocate(self%y); allocate(self%y(1:n)); self%y = self%x
  case(3)
    if (allocated(self%y)) deallocate(self%y); allocate(self%y(1:n)); self%y = self%x
    if (allocated(self%z)) deallocate(self%z); allocate(self%z(1:n)); self%z = self%x
  endselect
  endsubroutine init

  function integrate_1D(self, f, a, b) result(integral)
  !---------------------------------------------------------------------------------------------------------------------------------
  !< Integrate function *f* with one of the Fejer's formula.
  !---------------------------------------------------------------------------------------------------------------------------------
  class(fejer_integrator),        intent(IN) :: self     !< Actual Fejer integrator.
  class(integrand),               intent(IN) :: f        !< Function to be integrated.
  real(R_P),                      intent(IN) :: a        !< Lower bound.
  real(R_P),                      intent(IN) :: b        !< Upper bound.
  real(R_P)                                  :: integral !< Definite integral value.
  integer(I_P)                               :: i        !< Integration index.
  !---------------------------------------------------------------------------------------------------------------------------------

  !---------------------------------------------------------------------------------------------------------------------------------
  integral = 0._R_P
  do i=1,self%n
    integral = integral + self%w(i) * f%f(self%x(i)*(b-a)/2._R_P + (a+b)/2._R_P)
  enddo
  integral = integral * (b - a) / 2._R_P
  return
  !---------------------------------------------------------------------------------------------------------------------------------
  endfunction integrate_1D

  function integrate_2D(self, f, a, b, c, d) result(integral)
  !---------------------------------------------------------------------------------------------------------------------------------
  !< Integrate function *f* with one of the Fejer's formula.
  !---------------------------------------------------------------------------------------------------------------------------------
  class(fejer_integrator), intent(IN) :: self     !< Actual Fejer integrator.
  class(integrand),        intent(IN) :: f        !< Function to be integrated.
  real(R_P),               intent(IN) :: a        !< Lower bound, First Variable.
  real(R_P),               intent(IN) :: b        !< Upper bound, First Variable.
  real(R_P),               intent(IN) :: c        !< Lower bound, Second Variable.
  real(R_P),               intent(IN) :: d        !< Upper bound, Second Variable.
  real(R_P)                           :: integral !< Definite integral value.
  integer(I_P)                        :: i, j     !< Integration indexes.
  !---------------------------------------------------------------------------------------------------------------------------------

  !---------------------------------------------------------------------------------------------------------------------------------
  integral = 0._R_P
  do j=1,self%n
    do i=1,self%n
      integral = integral + self%w(i) * self%w(j) * f%f(self%x(i)*(b-a)/2._R_P + (a+b)/2._R_P) * &
                                                    f%f(self%y(j)*(d-c)/2._R_P + (d+c)/2._R_P)
    enddo
  enddo
  integral = integral * (b - a) / 2.0_R_P * (d - c) / 2.0_R_P
  return
  !---------------------------------------------------------------------------------------------------------------------------------
  endfunction integrate_2D

  function integrate_3D(self, f, a, b, c, d, g, h) result(integral)
  !---------------------------------------------------------------------------------------------------------------------------------
  !< Integrate function *f* with one of the Fejer's formula.
  !---------------------------------------------------------------------------------------------------------------------------------
  class(fejer_integrator), intent(IN) :: self     !< Actual Fejer integrator.
  class(integrand),        intent(IN) :: f        !< Function to be integrated.
  real(R_P),               intent(IN) :: a        !< Lower bound, First Variable.
  real(R_P),               intent(IN) :: b        !< Upper bound, First Variable.
  real(R_P),               intent(IN) :: c        !< Lower bound, Second Variable.
  real(R_P),               intent(IN) :: d        !< Upper bound, Second Variable.
  real(R_P),               intent(IN) :: g        !< Lower bound, Third Variable.
  real(R_P),               intent(IN) :: h        !< Upper bound, Third Variable.
  real(R_P)                           :: integral !< Definite integral value.
  integer(I_P)                        :: i, j, k  !< Integration indexes.
  !---------------------------------------------------------------------------------------------------------------------------------

  !---------------------------------------------------------------------------------------------------------------------------------
  integral = 0._R_P
  do k=1,self%n
    do j=1,self%n
      do i=1,self%n
        integral = integral + self%w(i) * self%w(j) * self%w(k) * f%f(self%x(i)*(b-a)/2._R_P + (a+b)/2._R_P) * &
                                                                  f%f(self%y(j)*(d-c)/2._R_P + (d+c)/2._R_P) * &
                                                                  f%f(self%z(k)*(h-g)/2._R_P + (g+h)/2._R_P)
      enddo
    enddo
  enddo
  integral = integral * (b - a) / 2.0_R_P * (d - c) / 2.0_R_P * (h - g) / 2.0_R_P
  return
  !---------------------------------------------------------------------------------------------------------------------------------
  endfunction integrate_3D
endmodule FORbID_integrator_fejer
