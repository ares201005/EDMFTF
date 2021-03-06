
SUBROUTINE checkChargeSize(file_clmsum,lmmaxx,lmax2,ncom,nrad,lmmax,lmmax1,jri,nat)
  IMPLICIT NONE
  CHARACTER*100, intent(in) :: file_clmsum
  INTEGER, intent(out):: lmmaxx, lmax2, ncom, nrad
  INTEGER, intent(out):: lmmax(nat), lmmax1(nat)
  INTEGER, intent(in) :: jri(nat), nat
  ! locals
  REAL*8, allocatable :: clm(:)
  INTEGER :: ISCF, j, jatom, l, m, lm1
  
  open(8, FILE=file_clmsum, status='old')
  READ(8,2044)  ISCF
  READ(8,2043) lmmaxx
  ncom=0
  lmax2=0
  nrad=0
  DO jatom=1,nat
     nrad=max(nrad,jri(jatom))
     allocate( clm(jri(jatom) ) )
     READ(8,2000) LMMAX(JATOM)
     LMMAX1(JATOM)=LMMAX(JATOM)
     ncom=max(ncom,lmmax1(jatom))
     DO LM1=1,LMMAX(JATOM)
        READ(8,2010) L,M
        lmax2=max(lmax2,l)
        IF(M.NE.0) THEN
           LMMAX1(JATOM)=LMMAX1(JATOM)+1
           ncom=max(ncom,lmmax1(jatom))
        endif
        READ(8,2021) ( CLM(J), J=1,JRI(JATOM))
        READ(8,2031)
     ENDDO
     READ(8,1980)
     READ(8,2030)
     deallocate(clm)
  ENDDO
  close(8)
1980 FORMAT(3X)
2043 FORMAT(8X,I4,/)
2044 FORMAT(49X,I3,/)
2000 FORMAT(15X,I3,/,/)
2010 FORMAT(15X,I3,5X,I2,/)
2021 FORMAT(3X,4ES19.12)
2030 FORMAT(/,/,/)
2031 FORMAT(/)
!2071 FORMAT(3X,3I5,2ES19.12)
END SUBROUTINE checkChargeSize

SUBROUTINE readCharge(file_clmsum,clm,lm,lmmaxx,lmax2,ncom,nrad,lmmax,lmmax1,jri,nat)
  ! Reading from lapw0.f
  IMPLICIT NONE
  CHARACTER*100, intent(in) :: file_clmsum
  REAL*8, intent(out) :: CLM(nrad,lmmaxx,nat)
  INTEGER, intent(out):: LM(2,ncom,nat)
  INTEGER, intent(in) :: lmmaxx, lmax2,ncom,nrad
  INTEGER, intent(inout):: lmmax(nat), lmmax1(nat)
  INTEGER, intent(in) :: nat, jri(nat)
  !
  INTEGER :: ISCF, lmmaxx_t
  INTEGER :: jatom
  INTEGER :: lm1, l, m, j
  open(8, FILE=file_clmsum, status='old')
  READ(8,2044)  ISCF
  READ(8,2043) lmmaxx_t
  if (lmmaxx_t.NE.lmmaxx) print *, 'ERROR: current lmmaxx and input lmmaxx do not agree', lmmaxx_t, lmmaxx
  
  DO jatom=1,nat
     READ(8,2000) LMMAX(JATOM)
     LMMAX1(JATOM)=LMMAX(JATOM)
     IF(LMMAX1(JATOM).GT.NCOM) print *, 'ERROR: too small ncom when reading ',file_clmsum
     DO LM1=1,LMMAX(JATOM)
        READ(8,2010) L,M
        if(l.gt.lmax2) print *, 'ERROR: l to large in file', file_clmsum
        LM(1,LM1,JATOM)=L
        LM(2,LM1,JATOM)=M
        IF(M.NE.0) THEN
           LMMAX1(JATOM)=LMMAX1(JATOM)+1
           IF(LMMAX1(JATOM).GT.NCOM) print *, 'ERROR: ncom is too small and incompatible with file', file_clmsum
           LM(1,LMMAX1(JATOM),JATOM)=L
           LM(2,LMMAX1(JATOM),JATOM)=-M
        endif
        READ(8,2021) ( CLM(J,LM1,JATOM), J=1,JRI(JATOM))
        READ(8,2031)
     ENDDO
     READ(8,1980)
     READ(8,2030)
  ENDDO
  close(8)

1980 FORMAT(3X)
2043 FORMAT(8X,I4,/)
2044 FORMAT(49X,I3,/)
2000 FORMAT(15X,I3,/,/)
2010 FORMAT(15X,I3,5X,I2,/)
2021 FORMAT(3X,4ES19.12)
2030 FORMAT(/,/,/)
2031 FORMAT(/)
!2071 FORMAT(3X,3I5,2ES19.12)
END SUBROUTINE readCharge

SUBROUTINE Cmp_c_kub(c_kub)
  IMPLICIT NONE
  REAL*8, intent(out) :: c_kub(0:10,0:10)
  !
  c_kub(:,:)=0.0d0
  c_kub(0,0)=1.d0
  c_kub(3,2)=1.d0
  c_kub(4,0)=.5d0*SQRT(7.d0/3.d0)
  c_kub(4,4)=.5d0*SQRT(5.d0/3.d0)
  c_kub(6,0)=.5d0*SQRT(.5d0)
  c_kub(6,2)=.25d0*SQRT(11.d0)
  c_kub(6,4)=-.5d0*SQRT(7.d0/2.d0)
  c_kub(6,6)=-.25d0*SQRT(5.d0)
  c_kub(7,2)=.5d0*SQRT(13.d0/6.d0)
  c_kub(7,6)=.5d0*SQRT(11.d0/6.d0)
  c_kub(8,0)=.125d0*SQRT(33.d0)
  c_kub(8,4)=.25d0*SQRT(7.d0/3.d0)
  c_kub(8,8)=.125d0*SQRT(65.d0/3.d0)
  c_kub(9,2)=.25d0*SQRT(3.d0)
  c_kub(9,4)=.5d0*SQRT(17.d0/6.d0)
  c_kub(9,6)=-.25d0*SQRT(13.d0)
  c_kub(9,8)=-.5d0*SQRT(7.d0/6.d0)
  c_kub(10,0)=.125d0*SQRT(65.D0/6.D0)
  c_kub(10,2)=.125d0*SQRT(247.D0/6.D0)
  c_kub(10,4)=-.25d0*SQRT(11.D0/2.D0)
  c_kub(10,6)=0.0625d0*SQRT(19.D0/3.D0)
  c_kub(10,8)=-.125d0*SQRT(187.D0/6.D0)
  c_kub(10,10)=-.0625d0*SQRT(85.d0)
END SUBROUTINE Cmp_c_kub



SUBROUTINE cmp_rho_Spherical(YY,llmm, ylm,LM,c_kub,cubic,lmMax,lmaxlmax)
  REAL*8, intent(out)    :: YY(lmMax)
  INTEGER, intent(out)   :: llmm
  COMPLEX*16, intent(in) :: ylm(lmaxlmax) !ylm((lmax+1)*(lmax+1))
  REAL*8, intent(in)     :: c_kub(0:10,0:10)
  INTEGER, intent(in)    :: LM(2,lmMax), lmMax, lmaxlmax
  LOGICAL, intent(in)    :: cubic
  !
  Interface
     REAL*8 FUNCTION SUML(l0,m,YL,lmaxlmax)
       INTEGER, intent(in)    :: l0, m, lmaxlmax
       COMPLEX*16, intent(in) :: YL(lmaxlmax)
     END FUNCTION SUML
  end Interface
  ! locals
  llmm = lmMax
  DO ilm=1,lmMax
     l=LM(1,ilm)
     m=LM(2,ilm)
     YY(ilm) = suml(l,m,ylm,lmaxlmax)
  ENDDO
  IF(cubic.AND.lmMax.GT.1) THEN   ! For cubic structure we can combine a few spherical harmonics
     CALL sumfac(llmm,YY,LM,lmMax,c_kub)
  ENDIF
END SUBROUTINE cmp_rho_Spherical

SUBROUTINE Cmp_rho_radial(rho, clm, YY, r, LM, c_kub, cubic, llmm, lmMax, jri, npt)
  IMPLICIT NONE
  REAL*8, intent(out):: rho(jri,npt)
  REAL*8, intent(in) :: clm(jri,lmMax), YY(lmMax,npt)
  REAL*8, intent(in) :: r(jri), c_kub(0:10,0:10)
  LOGICAL, intent(in):: cubic
  INTEGER, intent(in):: LM(2,lmMax)
  INTEGER, intent(in):: lmMax, jri, npt, llmm
  Interface
     REAL*8 Function srolyln(clmspu,YY,LM,lmMax,llmm,c_kub, cubic)
       IMPLICIT NONE
       REAL*8, intent(in) :: clmspu(lmMax), YY(lmMax)
       INTEGER, intent(in):: LM(2,lmMax)
       INTEGER, intent(in):: lmMax, llmm
       REAL*8, intent(in) :: c_kub(0:10,0:10)
       LOGICAL, intent(in):: cubic
     END Function srolyln
  end Interface
  ! locals
  REAL*8, PARAMETER :: pi=3.1415926535897932d0
  INTEGER :: ir, k
  REAL*8  :: ft, rs
  !
  ! jri = JRI(jatom)
  ! cubic = iatnr(jatom)>0
  ! need: r[jri[jatom]]
  !
  !print *, 'jri=', jri, 'npt=', npt, 'llmm=', llmm
  !print *, 'lm=', lm, 'cubic=', cubic
  
  DO ir=1,jri
     DO k=1,npt
        ft = srolyln(clm(ir,:),YY(:,k),LM,lmMax,llmm,c_kub,cubic)/(r(ir)**2)
        rho(ir,k)=ft
        !
        RS=(0.75D0/(pi*ft))**(1./3.)
        !ZET=0.0
        !CALL CORLSD(RS,ZET,ECLSD,VLSDU,VLSDD,ECRS,ECZET,ALFC)
        !vxcu=vxcu+2.d0*VLSDU
        !excu=excu+2.d0*eclsd
     ENDDO
  enddo
END SUBROUTINE Cmp_rho_radial

REAL*8 FUNCTION SUML(l0,m,YL,lmaxlmax)
  ! Gives the following combination of Ylm's:
  !-------------------------------------------------------------------------------!
  !    |  m=0      |   m=2,4,6                     |   m=1,3,5                    !
  !-------------------------------------------------------------------------------!
  !l<0 | -i*Y_{lm} |  -i/sqrt(2)*(Y_{lm}-Y_{l,-m}) |   i/sqrt(2)*(Y_{lm}+Y_{l,-m})!
  !l>0 |    Y_{lm} |   1/sqrt(2)*(Y_{lm}+Y_{l,-m}) |  -1/sqrt(2)*(Y_{lm}-Y_{l,-m})!
  !------------------------------------------------------------------------------ !
  IMPLICIT NONE
  INTEGER, intent(in)    :: l0, m, lmaxlmax
  COMPLEX*16, intent(in) :: YL(lmaxlmax)
  ! locals
  REAL*8     :: TCC
  COMPLEX*16 :: imag,imag1
  REAL*8     :: minu
  INTEGER    :: l
  imag = (0.d0,1.0d0)
  imag1= (1.d0,0.d0)
  !
  minu=1.
  l=l0
  IF(l.LT.0) THEN
     l=-l
     imag1=-imag
     minu=-1.d0
  END IF
  IF(MOD(m,2).EQ.1) THEN                                           
     imag1=-imag1
     minu=-minu
  END IF
  IF (m.EQ.0) THEN
     TCC=dble(imag1*YL(l*(l+1)+m+1)) ! ...SYMMETRIC PART,  MM EQ.0
  ELSE
     TCC=dble(imag1*(YL(l*(l+1)+m+1)+YL(l*(l+1)-m+1)*minu)/SQRT(2.D0))
  ENDIF
  SUML = TCC
END FUNCTION SUML

SUBROUTINE SUMFAC(llmm,YY,LM,lmMax,c_kub)
  IMPLICIT NONE
  INTEGER, intent(out) :: llmm
  REAL*8, intent(inout):: YY(lmMax)
  INTEGER, intent(in)  :: LM(2,lmMax), lmMax
  REAL*8, intent(in)   :: c_kub(0:10,0:10)  
  ! locals
  INTEGER :: l, m, i, al
  llmm=0
  i=1
  DO
     IF(i.gt.lmMax) EXIT
     l = lm(1,i)
     m = lm(2,i)
     al = abs(l)
     IF(l.EQ.0.AND.m.EQ.0) THEN
        llmm=llmm+1
        yy(llmm)=yy(i)
        i=i+1
     ELSEIF (l.EQ.-3.AND.m.EQ.2) THEN  
        llmm=llmm+1
        yy(llmm)=yy(i)
        i=i+1
     ELSEIF (l.EQ.4.OR.l.EQ.6.OR.l.EQ.-7.OR.l.EQ.-9) THEN  
        llmm=llmm+1
        yy(llmm)=c_kub(al,m)*yy(i) + c_kub(al,m+4)*yy(i+1)
        i=i+2
     ELSEIF (l.EQ.8.OR.l.EQ.10) THEN 
        llmm=llmm+1
        yy(llmm)=c_kub(l,m)*yy(i) + c_kub(l,m+4)*yy(i+1) + c_kub(l,m+8)*yy(i+2) 
        i=i+3
     ELSE
        WRITE(6,*) 'UNCORRECT LM LIST FOR CUBIC STRUCTURE'
        STOP
     ENDIF
  END DO
  RETURN
END SUBROUTINE SUMFAC

REAL*8 Function srolyln(clmspu,YY,LM,lmMax,llmm,c_kub, cubic)
  IMPLICIT NONE
  REAL*8, intent(in) :: clmspu(lmMax), YY(lmMax)
  INTEGER, intent(in):: LM(2,lmMax)
  INTEGER, intent(in):: lmMax, llmm
  REAL*8, intent(in) :: c_kub(0:10,0:10)
  LOGICAL, intent(in):: cubic
  ! locals
  REAL*8, PARAMETER :: pi=3.1415926535897932d0
  REAL*8  :: fu
  INTEGER :: i, iyy, lm1, l, m, al
  
  fu=clmspu(1)*YY(1)/sqrt(4.D0*pi)
  !-------------
  IF(.NOT.cubic) THEN ! non-cubic
     DO lm1=2,llmm
        fu=fu+CLMSPU(lm1)*YY(lm1)
     ENDDO
  ELSE
     iyy=0
     i=1
     DO
        l = lm(1,i)
        m = lm(2,i)
        al = abs(l)
        IF(i.gt.lmmax) EXIT
        IF(l.EQ.0.AND.m.EQ.0) THEN
           iyy=iyy+1
           i=i+1
        ELSEIF (l.EQ.-3.AND.m.EQ.2) THEN
           iyy=iyy+1
           fu=fu+clmspu(i)*yy(iyy)
           i=i+1
        ELSEIF (l.EQ.4.OR.l.EQ.6.OR.l.EQ.-7.OR.l.EQ.-9) THEN  
           iyy=iyy+1
           fu=fu+(c_kub(al,m)*CLMSPU(i)+c_kub(al,m+4)*CLMSPU(i+1))*YY(iyy)
           i=i+2
        ELSEIF (l.EQ.8.OR.l.EQ.10) THEN 
           iyy=iyy+1
           fu=fu+(c_kub(l,m)*CLMSPU(i)+c_kub(l,m+4)*CLMSPU(i+1)+c_kub(l,m+8)*CLMSPU(i+2))*YY(iyy)
           i=i+3
        ELSE
           WRITE(6,*) 'UNCORRECT LM LIST FOR CUBIC STRUCTURE'
           WRITE(6,*) 'srolyl.f'
           STOP
        ENDIF
     END DO
     IF(iyy.NE.llmm) THEN
        write(6,*) 'iyy=',iyy,' different from llmm=',llmm
        STOP
     ENDIF
  ENDIF
  srolyln = fu ! we do not multiply by 2 due to spin, because clm is not divided by 2.
  return
end Function srolyln
