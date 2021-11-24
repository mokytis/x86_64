global _start

section .bss
	num1: resb 16
	num2: resb 16
	limit: resb 16
	digits: resb 8
	digit: resb 8
section .data
  newline: db 10
	fizz: db "Fizz"
	buzz: db "Buzz"

section .text

_start:
	mov dword [num1], 1
	mov dword [limit], 100
_loop:
	mov rbx, [num1]
	call _checkDivis
	cmp rax, 0
	jne _match

	mov rbx, [num1]
	call _outputValue
	jmp _loopend

_match:
  mov rax, 1
	mov rdi, 1
	mov rsi, newline
	mov rdx, 1
	syscall
_loopend:
	add dword [num1], 1
	mov rax, [num1]
	cmp rax, [limit]
	je _end
	jmp _loop

_end:
  mov rax, 60
  mov rdi, 0
  syscall

_checkDivis:
	push rbp
	mov rbp, rsp

	mov dword [rbp - 16], 0
	mov [rbp - 32], rbx

	mov rax, [rbp - 32]
	mov rdx, 0
	mov rbx, 3
	div rbx
	cmp rdx, 0

	jne _buzz
_fizz:
  mov rax, 1
	mov rdi, 1
	mov rsi, fizz
	mov rdx, 4
	mov rax, 1
	syscall
	add dword [rbp - 16], 1

_buzz:
	mov rax, [rbp - 32]
	mov rdx, 0
	mov rbx, 5
	div rbx
	cmp rdx, 0

	jne _ex
  mov rax, 1
	mov rdi, 1
	mov rsi, buzz
	mov rdx, 4
	syscall
	add dword [rbp - 16], 1

_ex:
	mov rax, [rbp - 16]
	leave
	ret


_outputValue:
	; we start by adding the values to the stack
	; becuause we need to revese endieness
  mov dword [digits], 0

_outputloop:

	mov rdx, 0
	mov rcx, 10
	mov rax, rbx
	div rcx

	add rdx, 48
	push dx
	add dword [digits], 1

	mov rbx, rax
	cmp rax, 0
	je _outputstack
	jmp _outputloop

_outputstack:
	cmp dword [digits], 0
	je _exitoutput

	pop ax
	mov [digit], ax
  mov rax, 1
	mov rdi, 1
	mov rsi, digit
	mov rdx, 1
	syscall
	sub dword [digits], 1
	jmp _outputstack

_exitoutput:
  mov rax, 1
	mov rdi, 1
	mov rsi, newline
	mov rdx, 1
	syscall
	ret
