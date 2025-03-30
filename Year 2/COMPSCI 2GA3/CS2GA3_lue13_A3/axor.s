.data
.text
.global axor
.extern printf
axor:
	eor r0, r0, r1
	bx lr
