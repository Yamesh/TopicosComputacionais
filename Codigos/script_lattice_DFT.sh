#rm energia_Al.dat
for a in 3.34 3.38 3.42 3.46 3.50 3.54 3.58 3.62 3.66 3.70 3.74 3.78 
do
b=`echo "scale=5;1.889725989*$a"|bc`
cat > Diam.files<< ! 
Diam_$a.in
Diam_$a.out
Diam-$a-i
Diam-"$a"_o
Diam_"$a"_x
6c.pspnc
!

cat > Diam_$a.in <<!
# Crystalline Germanium : computation of the total energy
#

#Definition of the unit cell
acell 3*$b          # This is equivalent to   10.18 10.18 10.18
rprim  0.0  0.5  0.5   # In lessons 1 and 2, these primitive vectors 
       0.5  0.0  0.5   # (to be scaled by acell) were 1 0 0  0 1 0  0 0 1 
       0.5  0.5  0.0   # that is, the default.

#Definition of the atom types
ntypat 1          # There is only one type of atom
znucl 6          # The keyword "znucl" refers to the atomic number of the 
                  # possible type(s) of atom. The pseudopotential(s) 
                  # mentioned in the "files" file must correspond
                  # to the type(s) of atom. Here, the only type is Silicon.
                         

#Definition of the atoms
natom 2           # There are two atoms
typat 1 1         # They both are of type 1, that is, Silicon.
xred              # This keyword indicate that the location of the atoms
                  # will follow, one triplet of number for each atom
   0.0  0.0  0.0  # Triplet giving the REDUCED coordinate of atom 1.
   1/4  1/4  1/4  # Triplet giving the REDUCED coordinate of atom 2.
                  # Note the use of fractions (remember the limited 
                  # interpreter capabilities of ABINIT)

#Definition of the planewave basis set
ecut  12.0         # Maximal kinetic energy cut-off, in Hartree

#Definition of the k-point grid
kptopt 1          # Option for the automatic generation of k points, taking
                  # into account the symmetry
ngkpt 4 4 4       # This is a 2x2x2 grid based on the primitive vectors
nshiftk 4         # of the reciprocal space (that form a BCC lattice !),
                  # repeated four times, with different shifts :
shiftk 0.5 0.5 0.5
       0.5 0.0 0.0
       0.0 0.5 0.0
       0.0 0.0 0.5
                  # In cartesian coordinates, this grid is simple cubic, and
                  # actually corresponds to the
                  # so-called 4x4x4 Monkhorst-Pack grid

#Definition of the SCF procedure
nstep 10          # Maximal number of SCF cycles
toldfe 1.0d-6     # Will stop when, twice in a row, the difference 
                  # between two consecutive evaluations of total energy 
                  # differ by less than toldfe (in Hartree) 
diemac 12.0       # Although this is not mandatory, it is worth to
                  # precondition the SCF cycle. The model dielectric
                  # function used as the standard preconditioner
                  # is described in the "dielng" input variable section.
                  # Here, we follow the prescription for bulk silicon.

!


abinis <Diam.files> Diam_$a.log 

E=`grep "Total energy" Diam_$a.out|cut -d " " -f 7`
echo $a $E >> energia_Diam.dat
done
