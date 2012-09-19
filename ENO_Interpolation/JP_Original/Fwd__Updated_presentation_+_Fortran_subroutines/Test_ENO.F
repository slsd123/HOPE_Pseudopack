#include "pseudopack.h"
#include "dimension.h"

PROGRAM Test_ENO

USE Particle_ENO_Interpolation_1D

IMPLICIT NONE

! =============================================== 
! Begin: Testing Interpolate_Fluid_To_Particle_1D
! ===============================================                 
                 
! Variables
! =========
INTEGER, PARAMETER :: N0 = -7, N5 = 12, NV = 3, Index = 2, Order = 4, Np = 77
INTEGER :: i, j, i1
INTEGER, dimension(N0:N5) :: Left
REALTYPE :: x0, x1, dx, Xp, dXp, error
REALTYPE, dimension(N0:N5)         :: x, dPdx
REALTYPE, dimension(N0:N5,NV)      :: Q

!Current version! REALTYPE, dimension(N0:N5,Order) :: c1 !Current version: Go to "Interpolate_Fluid_To_Particle_1D" in Module_Particle_ENO_Interpolation_1D.F and define c1 with same dimensions.
REALTYPE, dimension(N0:N5,Order-1) :: c1 !Modified version JP: Go to Interpolate_Fluid_To_Particle_1D in Module_Particle_ENO_Interpolation_1D.F and define c1 with same dimensions.
!Modified version JP! REALTYPE, dimension(N0:N5,Order-1) :: c1 !Modified version JP: Go to "Interpolate_Fluid_To_Particle_1D" in Module_Particle_ENO_Interpolation_1D.F and define c1 with same dimensions.

REALTYPE, dimension(Order) :: cx
REALTYPE, dimension(2*NDIM+2)         :: Qfp
REALTYPE, dimension(2*NDIM+2,Np)         :: Qfp_Xp
REALTYPE, dimension(2*NDIM+1,Np)         :: Qfp_Xp_Exact
REALTYPE, dimension(Np)    :: Xp_vec, norm
REALTYPE :: heaviside

! Uniform grid on [ x(N0) x(N5) ]
! ===============================
x(N0) = -3.0d0
x(N5) =  2.0d0
dx = ( x(N5) - x(N0) ) / ( N5 - N0 )
do i = N0+1, N5-1
   x(i) = x(i-1) + dx
   !write(*,*), x(i)
enddo

! Q on the uniform grid
! =====================
do i = N0, N5
   Q(i,1) =   x(i)**3 - 3*x(i)**2  + 11*x(i) -  7
   Q(i,2) =  -x(i)**3 + 2.*x(i)**2 - 4*x(i)  + 11
   Q(i,3) = 2*x(i)**3 - 11*x(i)**2           +  2
   !Heaviside Test!   Q(i,1) = heaviside(x(i))
   !Heaviside Test!   Q(i,2) = heaviside(x(i))
   !Heaviside Test!   Q(i,3) = heaviside(x(i)) 
!   write(*,*), Q(i,1), Q(i,2), Q(i,3)
enddo

! Testing ENO_Interpolation_Setup_1D
! ==================================  
!  call ENO_Interpolation_Setup_1D ( N0, N5, Order, x, dx, x0, &
!                                    x1, cx )
! Printing output:
! ---------------
! write(*,*), "cx = ["									
! do i = 1, Order
!    write(*,*), cx(i)
! enddo   
! write(*,*), "]"

! Testing Divided_Differences_1D
! ==============================
! call Divided_Differences_1D ( N0, N5, NV, x, Q, Index, Order,  &
!                               c1 )
! Printing output:
! ---------------			   
! write(*,*) "Size(c1) = [", shape(c1), "]"
! write(*,*)
! write(*,*), "c1 = ["
! do i = N0, N5
!    write(*,*), ( c1(i,j), j = 1, 3 ) 
! enddo
! write(*,*), "]"

! Testing ENO_Interpolation_Stencil_1D
! ====================================  
! call ENO_Interpolation_Stencil_1D ( N0, N5, Order, c1, Left )

! Printing output:
! --------------- 
! write(*,*), "Left = ["
! do i = N0, N5
!    write(*,*), Left(i)
! enddo
! write(*,*), "]"

! Testing ENO_Interpolation_1D with one particle
! ============================================== 

! Defining particle:
! ----------------- 
! Xp = x(2) + dx/4
! i1 = 2
! call ENO_Interpolation_1D ( N0, N5, NV, Order, dx, x, Q,   &
!                             dPdx, Xp, i1, Left, cx, Qfp )
! Printing output:
! ---------------
! write(*,*), "Qfp = ["
! do i = 1, 2*NDIM+2
!    write(*,*), Qfp(i)
! enddo
! write(*,*), "]"

! Testing Interpolate_Fluid_To_Particle_1D
! ========================================

! Uniform particle on [x(N0),x(N5)] with grid spacing dXp = dx/4
! -------------------------------------------------------------- 
 Xp_vec(1) = x(N0)
 dXp = dx/4
 do i = 2, Np
    Xp_vec(i) = Xp_vec(i-1) + dXp
 enddo

 call Interpolate_Fluid_To_Particle_1D ( N0, N5, NV, Np, Index, Order, & 
                                         Xp_vec, dx, x, Q, Qfp_Xp )

 ! Writing Qfp_Xp in a file
 ! ======================== 
 open (unit = 777, file = "Qfp_Xp.dat", status = "unknown")
 
 do i = 1 , Np
    
    write(777,*), Qfp_Xp(1,i) , Qfp_Xp(2,i) , Qfp_Xp(3,i) 
 
 enddo
 
 close (777)

							
 ! Comparing Qfp and Qfp exact
 ! ===========================
 do i = 1, Np
    Qfp_Xp_Exact(1,i) =   Xp_vec(i)**3 - 3*Xp_vec(i)**2  + 11*Xp_vec(i) -  7
    Qfp_Xp_Exact(2,i) =  -Xp_vec(i)**3 + 2.*Xp_vec(i)**2 - 4*Xp_vec(i)  + 11
    Qfp_Xp_Exact(3,i) = 2*Xp_vec(i)**3 - 11*Xp_vec(i)**2           +  2
 enddo
 
 norm = 0.0d0
 
 do i = 1, Np
    norm(i) = sqrt( (Qfp_Xp_Exact(1,i)-Qfp_Xp(1,i))**2 + &
              (Qfp_Xp_Exact(2,i)-Qfp_Xp(2,i))**2 + &
              (Qfp_Xp_Exact(3,i)-Qfp_Xp(3,i))**2 )
 enddo
 
 error = 0
 do i = 1, Np
    error = error + norm(i)
 enddo
 error = error / real(Np)
 write(*,*), "Error = ", error
 
! ============================================= 
! End: Testing Interpolate_Fluid_To_Particle_1D
! =============================================

#if 0
! Begin: Testing Subroutine ENO_Interpolation_Setup_1D
! ----------------------------------------------------

! Variables
! ---------
INTEGER, PARAMETER :: N0 = -3, N5 = 2, Order = 5
INTEGER  :: i, n
REALTYPE :: dx, x0, x1
REALTYPE, dimension(N0:N5) :: x
REALTYPE, dimension(Order) :: cx

! Grid 
! ----
x(N0) = -PI
!write(*,*), x(N0)
dx = 0.5d0
do i = N0 + 1, N5
x(i) = x(i-1) + dx
!write(*,*), x(i)
enddo

 call ENO_Interpolation_Setup_1D ( N0, N5, Order, x, dx, x0, &
                                   x1, cx )
								   
 write(*,*), "x0 = ", x0
 write(*,*), "x1 = ", x1
 write(*,*), "i", "cx(i)"
 write(*,*),  
 do i = 1, Order
    write(*,*), i, cx(i)
 enddo
								   
								   
! End: Testing Subroutine ENO_Interpolation_Setup_1D
! --------------------------------------------------
#endif

#if 0
! Begin: Testing Subroutine Polynomial
! ------------------------------------

! Variables
! ---------
INTEGER, PARAMETER :: N0 = 1, N5 = 5
INTEGER, PARAMETER :: n = 5
INTEGER  :: i, k
REALTYPE :: x, f, dz
REALTYPE, dimension(N0:N5) :: z

! Grid 
! ----
z(N0) = -PI
dz = 0.5d0
do i = N0 + 1, N5
z(i) = z(i-1) + dz
enddo

! x
! --
x = -2.3245d0

! Testing Polynomial
! ------------------
do i = 1, n
   call Polynomial ( i, x, n, z, f )
   print *, i, f
enddo

! End: Testing Subroutine Polynomial
! ----------------------------------
#endif

END PROGRAM Test_ENO

!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

 FUNCTION heaviside(x)
 REALTYPE :: heaviside            
 REALTYPE, INTENT( IN ) :: x
 REALTYPE, PARAMETER :: tol = 1.0d-16
 
 if ( x < 0 .AND. abs(x) >= tol ) then
 
     heaviside = 0.0d0
	 
 elseif ( x > 0 .AND. abs(x) >= tol) then
   
     heaviside = 1.0d0
	 
 elseif ( abs(x) < tol ) then

     heaviside = 0.5d0

endif	 
 
 END FUNCTION heaviside

 
