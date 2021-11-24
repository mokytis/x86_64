global _start

section .text

_start:
	call _getInput
	sub dword [counter], 1

  mov rbx, 1   ; inital value 1
	mov [num1], rbx
	call _outputValue

  mov rbx, 1   ; initial value 2
	mov [num2], rbx
	call _outputValue

_loop:
	mov rbx, [num2]

	add rbx, [num1] ; calculate next fib value
	mov rcx, [num1]
	mov [num2], rcx
	mov [num1], rbx

	sub dword [counter], 1   ; check counter and maybe exit
	jz _end

	call _outputValue  ; output rbx (newly calculated)
	jmp _loop    ; repeate

_end:
  mov rax, 60
  mov rdi, 0
  syscall

_getInput:
	; get user input
  mov rax, 1
	mov rdi, 1
	mov rsi, question
	mov rdx, 21
	syscall

  mov rax, 0
	mov rdi, 0
	mov rsi, input
	mov rdx, 8
	syscall

	mov dword [index], 0
	mov dword [counter], 0

	mov rcx, 7
_inputloop:
	mov rax, input
	mov rbx, [index]
	mov al, [rax + rbx]
	cmp al, 10
	je _fininput
	sub al, 48
	mov bl, al
	mov rax, 0
	mov al, [counter]
	imul rax, 10
	add rax, rbx
	mov [counter], rax
	sub rcx, 1
	add dword [index], 1
	jnz _inputloop
_fininput:
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

section .bss
	digits: resb 8
	digit: resb 8
	input: resb 8
	index: resb 8
	counter: resb 8
	num1: resb 16
	num2: resb 16
section .data
  newline: db 10
	question: db "How many fib values? "
