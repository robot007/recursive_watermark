Pseudo random m-sequences generation
===================

## **mseq.m**

https://www.mathworks.com/matlabcentral/fileexchange/990-m-sequence-generation-program?focused=5045247&tab=function

## **mseqSearch.m**
https://cfn.upenn.edu/aguirre/wiki/public:m_sequences

## **mseqSearchSiemens.m**

#### Description
The function searches for primitive polynomials with the desired degree and modulo operator. It additionally receives desired number of polynomials to be found and a starting polynomial if user desires to start the search from specific point.
The codes of **mseqSearchSiemens.m** has been developed for the case of resilientChannel. It uses polinom sequence calculation of the mseq.m function and implements iterative search. It is not the fastest and most optimized method but it works much better then the other ones that can be found.

#### Usage
	stages = 7;			 % modulo	
	uniqueLength = 5;    % order
	numberOfPolynoms = 1;  
	startWeights = [0 0 0 0 0];
    poly_weights = mseqSearchSiemens(stages ,uniqueLength ,numberOfPolynoms,startWeights );
   It can also be called:
  

      poly_weights = mseqSearchSiemens(stages ,uniqueLength ,numberOfPolynoms);

   If user the coefficient of the polynomials are not important, or:
   
    poly_weights = mseqSearchSiemens(stages ,uniqueLength );
   If user want all primitive polynomials of this order and modulo value


 