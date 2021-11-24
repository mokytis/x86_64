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

	call _outputValue  ; output rbx (newly calculated fib value)
	jmp _loop    ; repeat

_end:
  mov rax, 60  ; 60 = code for exit syscall
  mov rdi, 0  ; exit code zero (no erorrs)
  syscall

_getInput:
	; get user input
  mov rax, 1  ; write syscall
	mov rdi, 1  ; to fd1 (stdout)
	mov rsi, question  ; ask how many digits (buffer location)
	mov rdx, 21  ; question length (buffer length)
	syscall

  mov rax, 0  ; read syscall
	mov rdi, 0  ; read from fd0 (stdin)
	mov rsi, input  ; store in location 'input'
	mov rdx, 8  ; read 8 bytes of input
	syscall

	mov dword [index], 0
	mov dword [counter], 0

	mov rcx, 7

	; we now need to turn this string into a number
_inputloop:
	mov rax, input
	mov rbx, [index]
	mov al, [rax + rbx]
	cmp al, 10
	je _fininput
	sub al, 48  ; 48 is the acii int offset (ascii 48 = 0 ascii 49 = 1 etc.)
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
  ; write a base 10 ascii representation of rbx to stdout

	; we start by adding the values to the stack
	; becuause we need to revese endieness
  mov dword [digits], 0  ; digits counts how many digits we are outputting

_output_addvaluestostack:
	; loop that uses divmod

	; rdx will store remainder
	; rcx is the divisor
	; rax is the value to divide and will be the result of the division
	mov rdx, 0
	mov rcx, 10
	mov rax, rbx
	div rcx

	add rdx, 48  ; 48 is the ascii off set of digits
	push dx  ; add the ascii for digit to the stack
	add dword [digits], 1 ; inc out digit counter

	mov rbx, rax

	; if we have processed the whole value jump to the output section
	; if not carry on adding values ot the stack
	cmp rax, 0
	je _output_writevaluesfromstack
	jmp _output_addvaluestostack

_output_writevaluesfromstack:
	; loop exit condition
	; exit loop if counter is zero
	cmp dword [digits], 0
	je _output_newlineandreturn

	pop ax  ; get digit to output off the stack
	mov [digit], ax  ; and write it to a buffer

	; output the digit
  mov rax, 1  ; write sys call
	mov rdi, 1  ; write to stdout
	mov rsi, digit  ; memory location of current digit to output
	mov rdx, 1  ; length of buffer is 1
	syscall  ; make the write syscall

	; decrease digit counter
	sub dword [digits], 1
	jmp _output_writevaluesfromstack

_output_newlineandreturn:
  ; write a newline to stdout and return from function
  mov rax, 1      ; write syscall
	mov rdi, 1      ; fd for stdout
	mov rsi, newline  ; buffer location for \n
	mov rdx, 1  ; buffer length is just 1
	syscall  ; make the syscall
	ret  ; return from function. we have finished outputting

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
