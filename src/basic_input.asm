section .data
	text1 db "What is your name? "
	text2 db "Hello, "

section .bss
	name resb 16

section .text
	global _start

_start:

	call _askName
	call _getName
	call _outputName

	mov rax, 60
	mov rdi, 0
	syscall

_askName:
	mov rax, 1
	mov rdi, 1
	mov rsi, text1
	mov rdx, 19
	syscall
	ret

_getName:
	mov rax, 0
	mov rdi, 0
	mov rsi, name
	mov rdx, 16
	syscall
	ret

_outputName:
	mov rax, 1
	mov rdi, 1
	mov rsi, text2
	mov rdx, 7
	syscall

	mov rax, 1
	mov rdi, 1
	mov rsi, name
	mov rdx, 16
	syscall
	ret
