#! /usr/bin/env python
# -*- coding: utf-8 -*-

class Config:
  prefix      = "./install"    # Installation path

  compiler    = "GNU"          # Compiler
  fc          = "gfortran"     # Fortran compiler
  cc          = "gcc"          # C compiler
  cxx         = "g++"          # C++ compiler


  cflags      = "-O3"          # linker flags for C programs
  fflags      = "-O3"          # linker flags for Fortran programs
  ldflags      = ""             # linker flags debuggin programs
  ompflag     = "-fopenmp"     # linker/compiler flag for openmp

  mpi_define  = "-D_MPI"       #
  pcc         = "/opt/mpich2/gnu/bin/mpicc"        # C compiler 
  pcxx        = "/opt/mpich2/gnu/bin/mpicxx"       # C++ compiler 
  pfc         = "/opt/mpich2/gnu/bin/mpif90"       # Fortran compiler 
  
  blasname    = "GNU"          # BLAS   library
  blaslib     = "-lblas"         # BLAS   library
  lapacklib   = "-llapack"             # LAPACK library
  fftwlib     = "-lfftw3_omp -lfftw3"  # FFTW   library
  gsl         = "-lgslcblas -lgsl"     # GSL    library


  f2pylib     = "--f90flags='-openmp '"	       # F2PY   library	
  f2pyflag    = "--opt='-O3'"	       # F2PY   library	

  ranlib      = ""             # Ranlib
  arflags     = "rc"           # ar flags

  make        = "make"
  def __init__(self, version):
    self.version = version
  def __getattr__(self,key):
    return None
