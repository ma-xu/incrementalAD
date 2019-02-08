This is an incremental Least squared Support Vector Machine base on L1-norm distance metric.
Objective:
	min |w|_{1} + C*sum(|ei|)
	s.t. ei = 1-yi(wx+b)
Convert to:
	min |w|_{1} + C*sum(|1-yi(wx+b)|)

Derivation:
	f(x)' = sign(w)+C*[e'*diag(sign(e-YXw))YX]'

The we can use SGD to optimize the function.

