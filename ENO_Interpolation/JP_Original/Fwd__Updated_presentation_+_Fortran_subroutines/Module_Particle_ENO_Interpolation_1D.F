#include "pseudopack.h"
#include "dimension.h"

 MODULE Particle_ENO_Interpolation_1D

 IMPLICIT NONE
 
 PRIVATE
 PUBLIC :: Polynomial
 PUBLIC :: ENO_Interpolation_Setup_1D 
 PUBLIC :: Divided_Differences_1D  
 PUBLIC :: ENO_Interpolation_Stencil_1D
 PUBLIC :: Particle_Locate_HostCell
 PUBLIC :: ENO_Interpolation_1D
 PUBLIC :: Interpolate_Fluid_To_Particle_1D
 CONTAINS
 
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

      Subroutine Polynomial ( k, x, n, z, f )
                                                                        
  INTEGER  :: k, n, j
  REALTYPE :: x, f
  REALTYPE, dimension(n) :: z(n)
                                                                        
  SELECT CASE (k)
    CASE (1)
      f = (x-z(2))/(z(k)-z(2))
      do j = 3, n
        f = f*(x-z(j))/(z(k)-z(j))
      enddo

    CASE DEFAULT
      f = (x-z(1))/(z(k)-z(1))
      do j = 2, k-1
        f = f*(x-z(j))/(z(k)-z(j))
      enddo

      do j = k+1, n
        f = f*(x-z(j))/(z(k)-z(j))
      enddo

  END SELECT

  END Subroutine Polynomial
 

 
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

  Subroutine ENO_Interpolation_Setup_1D ( N0, N5, Order, x, dx, x0, &
                                          x1, cx )                      
                                        
  INTEGER  :: N0, N5, Order
  INTEGER  :: n  
  REALTYPE :: dx, x0, x1
  REALTYPE, dimension(N0:N5) :: x
  REALTYPE, dimension(Order) :: cx

  x0 = x(N0)
  x1 = x(N5)
 
  do n = 1, Order
    cx(n) = (n-1)*dx 
  enddo
 
  END Subroutine ENO_Interpolation_Setup_1D 

!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

  Subroutine Divided_Differences_1D ( N0, N5, NV, x, Q, Index, Order,  &
                                      c1 )
! Begin JP version:
! ================
#if 1

  INTEGER  :: N0, N5, NV, Index, Order
  INTEGER  :: i, k, l, n
  REALTYPE, dimension(N0:N5)         :: x
  REALTYPE, dimension(N0:N5,NV)      :: Q
  REALTYPE, dimension(N0:N5,Order-1) :: c1  
  REALTYPE, dimension(Order)         :: c, xa
 
   c1 = ZERO 
  
   do i = N0, N5 - Order + 1 
       xa = x(i:i+Order-1)
       do n = 1, Order
          c(n) = Q(i+n-1,Index)
       enddo
       do l = 1, Order-1
          do k = Order, l+1, -1		
             c(k) = (c(k)-c(k-1))/(xa(k)-xa(k-l)) 
          enddo		  	
          c1(i,l) = c(k+1)		  
       enddo
   enddo
   
#endif
! End JP version:
! ==============

! Begin Old version:
! =================
#if 0 
  
  INTEGER  :: N0, N5, NV, Index, Order
  INTEGER  :: i, k, l, n
  REALTYPE, dimension(N0:N5)         :: x
  REALTYPE, dimension(N0:N5,NV)      :: Q
  REALTYPE, dimension(N0:N5,Order) :: c1  
  REALTYPE, dimension(Order+1)         :: c, xa
 
   c1 = ZERO 
  
   do i = N0 + Order, N5 - Order 
       xa = x(i:i+Order)
       do n = 1, Order
          c(n) = Q(i+n-1,Index)
       enddo
       do l = 1, Order-1
          do k = Order, l+1, -1		
             c(k) = (c(k)-c(k-1))/(xa(k)-xa(k-l)) 
          enddo		  	
          c1(i,l) = c(k)		  
       enddo
   enddo
   
#endif   
! End Old version:
! ===============   

  END Subroutine Divided_Differences_1D

!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
                                          
! Begin JP version:
! ================							
#if 1	
					
  Subroutine ENO_Interpolation_Stencil_1D ( N0, N5, Order, c1, Left )      
					
  INTEGER :: N0, N5, Order
  INTEGER, dimension(N0:N5) :: Left
  INTEGER :: i, j, m, is, js
  REALTYPE, dimension(N0:N5,Order-1) :: c1
  
  Left(N0) = N0; Left(N5-Order+2:N5) = N5 - Order + 1
  
  do i = N0 + 1, N5 - Order + 1
     is = i
     do m = 2, Order-1
        if ( ABS(c1(is-1,m)) < ABS(c1(is,m)) .AND. (is-1) >= N0) is = is - 1
     enddo
     Left(i) = is
  enddo

  End Subroutine ENO_Interpolation_Stencil_1D
  
#endif
! End JP version:
! ==============  

! Begin Old version:
! =================
#if 0

  Subroutine ENO_Interpolation_Stencil_1D ( N0, N5, Order, c1, Left )      
					
  INTEGER :: N0, N5, Order
  INTEGER, dimension(N0:N5) :: Left
  INTEGER :: i, j, m, is, js
  REALTYPE, dimension(N0:N5,Order) :: c1
  
  Left(N0:N0+Order-1) = N0
  
  do i = N0 + Order, N5
     is = i
     do m = 2, Order-1
        if ( ABS(c1(is-1,m)) < ABS(c1(is,m)) ) is = is - 1
     enddo
     Left(i) = is
  enddo

  End Subroutine ENO_Interpolation_Stencil_1D

#endif
! End Old version:
! ===============


!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

  Subroutine Particle_Locate_HostCell (N0, N5, Xp, x_n, x0, x1)     
                                                                                        
  INTEGER  :: N0, N5
  INTEGER  :: x_n
  REALTYPE :: Xp
  REALTYPE :: x0, x1
 
  x_n   = INT((Xp-x0)/(x1-x0)*(N5-N0)) + N0 
   
  END Subroutine Particle_Locate_HostCell
 
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! 

  Subroutine ENO_Interpolation_1D ( N0, N5, NV, Order, dx, x, Q,   &
                                    dPdx, Xp, i1, Left, cx, Qfp )     
                                 
  INTEGER  :: N0, N5, NV, Order
  INTEGER  :: i1
  INTEGER , dimension(N0:N5)    :: Left
  INTEGER  :: i, n, i0
  REALTYPE :: dx, Xp
  REALTYPE, dimension(N0:N5,NV) :: Q
  REALTYPE, dimension(N0:N5)    :: x, dPdx
  REALTYPE, dimension(2*NDIM+2)         :: Qfp 
  REALTYPE, dimension(Order)          :: cx
  REALTYPE, dimension(Order)          :: hx  
  REALTYPE :: Sum0
  REALTYPE :: xa, dx1

  
! Look up the interpolation stencil
  i0 =    Left(i1)
  
  xa = x(i1) 
  
  dx1 = (Xp-xa) + (i1-i0)*dx
   
! Determine the Lagrange interpolant
   do n = 1, Order
     CALL Polynomial (n, dx1, Order, cx, hx(n))
   enddo
 
! Lagrange interpolation
  do i = 1, NV

    Sum0 = ZERO

    do n = 1, Order     
        Sum0 = Sum0 + Q(i0+n-1,i)*hx(n)      
    enddo

    Qfp(i) = Sum0

  enddo
 
   Sum0 = ZERO   
   
   do n = 1, Order    
       Sum0 = Sum0 + dPdx(i0+n-1)*hx(n)           
   enddo
   
   Qfp(NV+1) = Sum0 

  END Subroutine ENO_Interpolation_1D

!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

  Subroutine Interpolate_Fluid_To_Particle_1D ( N0, N5, NV, Np, Index, Order, & 
                                                Xp, dx, x, Q, Qfp_Xp )   
  
  
  INTEGER  :: N0, N5, NV, Np, Index, Order, i, i1
  INTEGER, dimension(N0:N5) :: Left
  REALTYPE :: dx, x0, x1 
  REALTYPE, dimension(N0:N5)    :: x, dPdx
  REALTYPE, dimension(N0:N5,NV) :: Q
  REALTYPE, dimension(2*NDIM+2,Np) :: Qfp_Xp
  REALTYPE, dimension(Np)    :: Xp
  
  !Current version! REALTYPE, dimension(N0:N5,Order) :: c1 !Current version: Go to "Test_ENO.F" and define c1 with same dimensions.
  REALTYPE, dimension(N0:N5,Order-1) :: c1 !Modified version JP: Go to "Test_ENO.F" and define c1 with same dimensions.
  !Modified version JP! REALTYPE, dimension(N0:N5,Order-1) :: c1 !Modified version JP: Go to "Test_ENO.F" and define c1 with same dimensions.
  
  REALTYPE, dimension(Order) :: cx
  
 dPdx = ZERO 
 
 call ENO_Interpolation_Setup_1D ( N0, N5, Order, x, dx, x0, &
                                   x1, cx ) 
 
 call Divided_Differences_1D ( N0, N5, NV, x, Q, Index, Order,  &
                               c1 )
  
 call ENO_Interpolation_Stencil_1D ( N0, N5, Order, c1, Left ) 


 
 do i = 1, Np

    call Particle_Locate_HostCell (N0, N5, Xp(i), i1, x0, x1)
 
    call ENO_Interpolation_1D ( N0, N5, NV, Order, dx, x, Q,   &
                                dPdx, Xp(i), i1, Left, cx,  &
                                Qfp_Xp(:,i) )       
   
 enddo 
 
  END Subroutine Interpolate_Fluid_To_Particle_1D

!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
  
END MODULE Particle_ENO_Interpolation_1D