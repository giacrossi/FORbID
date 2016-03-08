!< Test FORbID with the integration of cosin function.
program integrate_cos
!-----------------------------------------------------------------------------------------------------------------------------------
!< Test FORbID with the integration of cosin function.
!-----------------------------------------------------------------------------------------------------------------------------------

!-----------------------------------------------------------------------------------------------------------------------------------
use FORbID_kinds, only : R_P
use type_cos,     only : cosf
use FORbID,       only : newton_cotes_integrator
!-----------------------------------------------------------------------------------------------------------------------------------

!-----------------------------------------------------------------------------------------------------------------------------------
implicit none
real(R_P), parameter          :: pi=4._R_P * atan(1._R_P)
type(cosf)                    :: cos_field
type(newton_cotes_integrator) :: integrator
real(R_P)                     :: integral
real(R_P)                     :: delta
integer, parameter            :: Ni=100
integer                       :: i
!-----------------------------------------------------------------------------------------------------------------------------------

!-----------------------------------------------------------------------------------------------------------------------------------
call cos_field%init(w=1._R_P)
call integrator%init(n=1)
integral = 0._R_P
!delta = pi/Ni
!do i=1, Ni
!  integral = integral + integrator%integrate(integrator, f=cos_field, a=(i-1)*delta, b=i*delta)
!enddo
call integrator%adaptive_integrate(f=cos_field, a=0._R_P, b=pi, b_orig=pi, tol=10._R_P**(-6), ad_integral=integral)
print*, integral
stop
!-----------------------------------------------------------------------------------------------------------------------------------
endprogram integrate_cos
