-- complex.moon

C = {
	complexUnpack: (cx) -> return
	imaginary: (cx_) -> cx_.imaginary
	real: (cx_) -> cx_.real
	conjugate: (cx_): -> (cx_ * -cx_)
}
return C