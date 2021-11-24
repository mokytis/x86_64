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

  mov rax, 60  ; 60 = exit syscall
  mov rdi, 0   ; 0 = standard exit status code
  syscall

_askName:
  mov rax, 1  ; 60 = write syscall
  mov rdi, 1  ; 1 = file descriptor (fd 1 = stdout)
  mov rsi, text1  ; text1 = buffer to output
  mov rdx, 19  ; 19 = length of buffer
  syscall
  ret

_getName:
  mov rax, 0  ; 0 = read syscall
  mov rdi, 0  ; 0 = file descriptor (fd 0 = stdin)
  mov rsi, name  ; buffer to write to
  mov rdx, 16 ; num of bytes to read
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
