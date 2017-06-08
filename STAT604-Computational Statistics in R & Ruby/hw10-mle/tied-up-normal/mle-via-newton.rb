# Method for compute the maximum likelihood estimate (MLE) using the multivariate
# version of the Newton-Raphson algorithm.
#
# Arguments to the method:
#     1. 'logLikelihood' is an object whose class is derivated from
#         the class 'LogLikelihood'
#     2. 'initial_parameter_value' is a GSL::Vector
#     3. 'tolerance' is a Float specifying how close the norm of the
#         gradient evaluated at the approximation needs to be to zero.
#
# Before returning, the method should verify that it has found a maximum (as
# opposed to a minimum or point of inflection) and raise an expection if it has
# not found a maximum.  Exceptions are covered in Chapter 8 of the Pick Axe
# book.  The method should return the number of iterations to convergence.
# After the method call, the value of the parameter of the logLikelihood object
# should be the approximate MLE.
#
def mle_via_newton(logLikelihood,initial_parameter_value,tolerance=0.001)
  # Your code goes here.
end
