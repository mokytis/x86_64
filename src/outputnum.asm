global _start

section .data
  newline: db 10  ; ascii of newline \n

section .text

_start:
	mov rbx, 123
	call _outputValue
	mov rbx, 32324
	call _outputValue
	jmp _end

_end:
  mov rax, 60  ; exit syscall
  mov rdi, 0 ; 0 = exit code good
  syscall

_outputValue:
	; output ascii for a number (in rbx) and a newline

	; create stackframe
	push rbp
	mov rbp, rsp
	sub rsp, 16  ; we have 16 bytes of local variables

	; we start by adding the values to the stack
	; becuause we need to revese endieness
	push 10
	mov dword [rbp  - 8], 2  ; digits (bytes to output)
	mov dword [rbp - 16], 0  ; digit


_output_addvaluestostack:
	; does a divmod 10
	; adds 48 (ascii int offset) to remainder and pushes it to the stack
	; repeats with the division result until the result is zero

	mov rdx, 0
	mov rcx, 10
	mov rax, rbx
	div rcx

	add rdx, 48 ; ascii int offset (ascii 48 = 0 ascii 49 = 1 etc.)
	push dx
	add dword [rbp  - 8], 2  ; add 2 to digits (each digit is 2 bytes)

	mov rbx, rax
	cmp rax, 0
	je _output_writevaluesfromstack
	jmp _output_addvaluestostack

_output_writevaluesfromstack:
  mov rax, 1
	mov rdi, 1
	mov rsi, rsp
	mov rdx, [rbp - 8] ; length
	syscall

	leave
	ret
