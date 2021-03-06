!< FORbID integrator: provide the Clenshaw-Curtis quadrature formulas.
module FORbID_integrator_clenshaw_curtis
!-----------------------------------------------------------------------------------------------------------------------------------
!< FORbID integrator: provide the Clenshaw-Curtis quadrature formulas.
!<
!< Considering the following problem:
!<
!< $$ \int_a^b f(x) = ? $$
!<
!< where \(f(x)\), a generic integrand function, the problem is to perform its definite integral.
!< The n-point Clenshaw-Curtis quadrature rule is a quadrature rule that is based on an expansion of the integrand in terms of Chebyshev
!< polynomials.
!<
!< $$ \int_{-1}^1 f(x) dx = \sum_{k=1}^n w_k f \left( \cos \frac{k-1}{n-1} \pi \right) $$
!< where
!< $$ w_1 =w_n = \begin{cases}
!<               & \frac{1}{\left( n-1 \right)^2} \text{if $n$ is even} \\
!<               & \frac{1}{n \left( n-2 \right)} \text{if $n$ is odd}
!<               \end{cases} $$
!< $$ w_k = 1 - \sum_{m=1}^{(n-1)/2}^* \frac{2}{4 m^2 -1} \cos  (2m \theta_k ) \right)
!< where \( {\sum}^* \) means that the last term in the sum must be halved if \( n \) is odd
!< and
!< $$\theta_k = \frac{(k-1) \pi}{n-1}$$.
!-----------------------------------------------------------------------------------------------------------------------------------

!-----------------------------------------------------------------------------------------------------------------------------------
use FORbID_kinds, only : R_P, I_P
use FORbID_adt_integrand, only  : integrand
use FORbID_adt_integrator, only : integrator
!-----------------------------------------------------------------------------------------------------------------------------------

!-----------------------------------------------------------------------------------------------------------------------------------
implicit none
private
public :: clenshaw_curtis_integrator
!-----------------------------------------------------------------------------------------------------------------------------------

!-----------------------------------------------------------------------------------------------------------------------------------
type, extends(integrator) :: clenshaw_curtis_integrator
  !< FORbID integrator: provide the Clenshaw-Curtis quadrature.
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
endtype clenshaw_curtis_integrator
!-----------------------------------------------------------------------------------------------------------------------------------
contains
  elemental subroutine init(self, n, d)
  !---------------------------------------------------------------------------------------------------------------------------------
  !< Create the Clenshaw-Curtis quadrature: initialize the weights and the roots
  !---------------------------------------------------------------------------------------------------------------------------------
  class(clenshaw_curtis_integrator), intent(INOUT) :: self                      !< Clenshaw-Curtis integrator.
  integer(I_P),                      intent(IN)    :: n                         !< Number of integration nodes.
  integer(I_P),                      intent(IN)    :: d                         !< Number of integration dimensions.
  real(R_P),                         parameter     :: pi=4._R_P * atan(1._R_P)  !< Pi Greek.
  real(R_P)                                        :: app                       !< Dummy variable and theta_k.
  integer(I_P)                                     :: i, m                      !< Counters for cycles.
  self%n = n
  if (allocated(self%w)) deallocate(self%w); allocate(self%w(1:n)); self%w = 0._R_P
  if (allocated(self%x)) deallocate(self%x); allocate(self%x(1:n)); self%x = 0._R_P
  if (MOD(n,2_I_P)==0) then
    do i=2,n-1
      self%x(i) = cos((i - 1._R_P)/(self%n - 1._R_P) * pi)
      app       = 0._R_P
      do m=1,(n-1)/2
        app = app + 2._R_P / (4._R_P * m**2._R_P - 1._R_P) * cos(2._R_P * m * ((i - 1._R_P)/(self%n - 1._R_P) * pi))
      enddo
      self%w(i) = 1._R_P - app
    enddo
    self%w(1) = 1._R_P / (n - 1._R_P)**2._R_P
    self%w(n) = 1._R_P / (n - 1._R_P)**2._R_P
  else
    do i=2,n-1
      self%x(i) = cos((i - 1._R_P)/(self%n - 1._R_P) * pi)
      app       = 0._R_P
      do m=1,((n-1)-1)/2
        app = app + 2._R_P / (4._R_P * m**2._R_P - 1._R_P) * cos(2._R_P * m * ((i - 1._R_P)/(self%n - 1._R_P) * pi))
      enddo
      app = app + 1._R_P / (4._R_P * ((n-1._R_P)/2._R_P)**2._R_P - 1._R_P) &
          * cos(2._R_P * ((n-1._R_P)/2._R_P) * ((i - 1._R_P)/(self%n - 1._R_P) * pi))
      self%w(i) = 1._R_P - app
    enddo
    self%w(1) = 1._R_P / (n*(n - 2._R_P))
    self%w(n) = 1._R_P / (n*(n - 2._R_P))
  endif
  self%x(1) = 1._R_P
  self%x(n) = -1._R_P
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
  !< Integrate function *f* with one of the Clenshaw-Curtis's formula.
  !---------------------------------------------------------------------------------------------------------------------------------
  class(clenshaw_curtis_integrator), intent(IN) :: self     !< Actual clenshaw-curtis integrator.
  class(integrand),                  intent(IN) :: f        !< Function to be integrated.
  real(R_P),                         intent(IN) :: a        !< Lower bound.
  real(R_P),                         intent(IN) :: b        !< Upper bound.
  real(R_P)                                     :: integral !< Definite integral value.
  integer(I_P)                                  :: i        !< Integration index.
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
  !< Integrate function *f* with one of the Clenshaw-Curtis's formula.
  !---------------------------------------------------------------------------------------------------------------------------------
  class(clenshaw_curtis_integrator), intent(IN) :: self     !< Actual clenshaw-curtis integrator.
  class(integrand),                  intent(IN) :: f        !< Function to be integrated.
  real(R_P),                         intent(IN) :: a        !< Lower bound, First Variable.
  real(R_P),                         intent(IN) :: b        !< Upper bound, First Variable.
  real(R_P),                         intent(IN) :: c        !< Lower bound, Second Variable.
  real(R_P),                         intent(IN) :: d        !< Upper bound, Second Variable.
  real(R_P)                                     :: integral !< Definite integral value.
  integer(I_P)                                  :: i, j     !< Integration indexes.
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
  !< Integrate function *f* with one of the Clenshaw-Curtis's formula.
  !---------------------------------------------------------------------------------------------------------------------------------
  class(clenshaw_curtis_integrator), intent(IN) :: self     !< Actual clenshaw-curtis integrator.
  class(integrand),                  intent(IN) :: f        !< Function to be integrated.
  real(R_P),                         intent(IN) :: a        !< Lower bound, First Variable.
  real(R_P),                         intent(IN) :: b        !< Upper bound, First Variable.
  real(R_P),                         intent(IN) :: c        !< Lower bound, Second Variable.
  real(R_P),                         intent(IN) :: d        !< Upper bound, Second Variable.
  real(R_P),                         intent(IN) :: g        !< Lower bound, Third Variable.
  real(R_P),                         intent(IN) :: h        !< Upper bound, Third Variable.
  real(R_P)                                     :: integral !< Definite integral value.
  integer(I_P)                                  :: i, j, k  !< Integration indexes.
  !---------------------------------------------------------------------------------------------------------------------------------

  !---------------------------------------------------------------------------------------------------------------------------------
  integral = 0._R_P
  do k=1,self%n
    do j=1,self%n
      do i=1,self%n
        integral = integral + self%w(i) * self%w(j) * self%w(j) * f%f(self%x(i)*(b-a)/2._R_P + (a+b)/2._R_P) * &
                                                                  f%f(self%y(j)*(d-c)/2._R_P + (d+c)/2._R_P) * &
                                                                  f%f(self%z(k)*(h-g)/2._R_P + (g+h)/2._R_P)
      enddo
    enddo
  enddo
  integral = integral * (b - a) / 2.0_R_P * (d - c) / 2.0_R_P * (h - g) / 2.0_R_P
  return
  !---------------------------------------------------------------------------------------------------------------------------------
  endfunction integrate_3D
endmodule FORbID_integrator_clenshaw_curtis
