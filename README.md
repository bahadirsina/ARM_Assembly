# ARM_Assembly

Implement a set of array operations in ARM assembly language.

In this project, it is requested to perform an array of operations in the ARM assembly language. The KEIL simulator was used to develop and test the code. First of all, an array of 32-bit positive integers is created. The first element in array A [0] is the size of the array, so the number of elements in the array (i.e. integer "size") is A [0]. The remaining elements in A (A [1] – A [size]) are values in the array.
The main () function tests the program's functions. The values of the integers in the array are unordered but reside in consecutive positions throughout the memory. The address of the first integer of the array is kept in R1. If the value in the R2 register is 1, find is performed, and if it is 2, sorting is performed.

The find () function finds a specific value (given in the R0 register) in the array containing the address of the first element of the array argument (given in R1). The search result is stored in the R0 register. R0 = 1 if the item is found, R0 = 0 otherwise. If the value is found in the array, it contains the address of R1. The original directory has not been modified for this procedure.

The sort () function sorts the items in the array. The procedure takes two arguments: the size of the array (given in the R0 register) and the address of the first element of the array argument (given in R1). At the end of the operation, the address of the first element of the sorted list is in the R0 register. The "Counting Order" algorithm is used in the sequence.
