section .data
	; 10 is the decimal of ascii new line (\n)
	text db "Hello, World!", 10

section .text
	global _start

_start:
	mov rax, 1    ; code for write syscall
	mov rdi, 1    ; write to stdout stdout
	mov rsi, text ; memory location of buffer
	mov rdx, 14   ; length of buffer
	syscall

	mov rax, 60 ; exit syscall
	mov rdi, 0  ; exit code
	syscall
