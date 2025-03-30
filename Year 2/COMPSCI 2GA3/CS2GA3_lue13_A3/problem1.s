.data
int: .word 0xBD5B7DDE
string: .asciz "\n%i\n"

.text
.global main
.extern int_out
main:
	push {ip, lr}
	ldr r1, =int
	ldr r0, [r1]
	asr r0, r0, #1
	bl int_out
	pop {ip, pc}
