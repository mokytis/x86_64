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

section .bss
  input: resb 8
  index: resb 8
  counter: resb 8
section .data
  num1: dq 1
  num2: dq 1
  question: db "How many fib values? "
