global _start

section .data
	counter: dq 1  ; loop counter. value to output/check divisors for
	limit: dq 100  ; loop exit value. program outputs $limit values
	digits: dq 0  ; used in _outputValue. (TODO move from here to _outputValue)
	digit: dw 0  ; used in _outputValue. (TODO move from here to _ouputValue)
  newline: db 10  ; ascii of newline \n
	fizz: db "Fizz"
	buzz: db "Buzz"

section .text

_start:
_loop:
	; check if counter divides by 3 or 5. if it does checkDivis will output
	; Fizz and/or Buzz accordingly
	; if this happened, we want to ouptut a newline here (what _match does)
	; if not, we want to output an ascii of the number (_outputValue)
	mov rbx, [counter]
	call _checkDivis
	cmp rax, 0
	jne _match

	mov rbx, [counter]
	call _outputValue
	jmp _loopend

_match:
 ; output newline
  mov rax, 1  ; write syscall
	mov rdi, 1  ; fd1 = stdout
	mov rsi, newline  ; buffer to write
	mov rdx, 1  ; buffer length for newline is 1
	syscall
_loopend:
	add dword [counter], 1  ; increment counter/fizzbuzz number
	mov rax, [counter]

	; loop pexit condition.
	cmp rax, [limit]
	je _end
	jmp _loop

_end:
  mov rax, 60  ; exit syscall
  mov rdi, 0 ; 0 = exit code good
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
	add dword [digits], 1

	mov rbx, rax
	cmp rax, 0
	je _output_writevaluesfromstack
	jmp _output_addvaluestostack

_output_writevaluesfromstack:
	; outputs the ascii vlaues from the stack
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
	jmp _output_writevaluesfromstack

_exitoutput:
	; output a newline
  mov rax, 1
	mov rdi, 1
	mov rsi, newline
	mov rdx, 1
	syscall
	ret
