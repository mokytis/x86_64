global _start

section .data
  counter: dq 1  ; loop counter. value to output/check divisors for
  limit: dq 100  ; loop exit value. program outputs $limit values
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
