#include "pseudopack.h"

Module Element_Type

IMPLICIT NONE

    REALTYPE :: x0, x1
    integer  :: N, N0, N1, N2, N3, N4, N5, NV

    integer  :: Method, Symmetry

    integer  :: WENO_Order  , WENO_Weight, WENO_Unroll_Loop
    REALTYPE :: WENO_Epsilon, WENO_Power , WENO_Lambda, WENO_Sound_Speed

    REALTYPE, dimension(:)  , ALLOCATABLE :: x
    REALTYPE, dimension(:)  , ALLOCATABLE :: Lambda, V_Moving_Frame
    REALTYPE, dimension(:,:), ALLOCATABLE :: Q, Q0
    REALTYPE, dimension(:,:), ALLOCATABLE :: Riemann

    character(LEN=3), dimension(:), ALLOCATABLE :: Shock_Case

    integer  :: N_x
    integer  :: M_s

    REALTYPE :: dx
    REALTYPE :: CFL

END Module Element_Type
!
! ==================================================================
!
Module Domain_Definition

  USE Element_Type

IMPLICIT NONE

  integer, parameter :: Dimensions    = 1
  integer            :: Index_x       = 1
  logical            :: Distributed_x = .FALSE.

END Module Domain_Definition
