extern  printf
extern  atoi
	
section .text                  ; Code section.
        global main             ;the standard gcc entry point

        ;Begin macro
%macro subsqr 2
        push rdi                ;save registers.
        push rax
        push rsi
        push rdx

        mov eax, %1             ;populate eax and ebx for subtraction.
        mov ebx, %2             ;need to reverse order to properly subtract.
        sub eax, ebx

        mul eax
        mov %1, eax     ;store results into first param

        pop rdx
        pop rsi
        pop rax
        pop rdi
        %endmacro

%macro addsqrt 2
	push rdi                ;save registers.
        push rax
        push rsi
        push rdx

	mov eax, %1             ;populate eax and ebx for addition.
        mov ebx, %2             ;takes advantage of communitive property of addition.
        add eax, ebx

	cvtsi2sd xmm0, eax         
        sqrtsd xmm0, xmm0
	
        pop rdx
        pop rsi
        pop rax
        pop rdi
        %endmacro	

main:
        ;save registers.
        push rdi
        push rsi                ;save registers
        sub rsp, 8              ;allign the stack.
	mov r12, rsi		;r12 points to params.
	add r12, 8		;skip the program name.
	mov r13d, 3		;use r13d as a pointer to last element
	
convert:
	mov rdi, [r12]
        call atoi               ;convert args to number.
	mov ebx, arr
        mov [arr+(r13d*4)], eax ;store the value at each address of array
        dec r13d                ;inc count
        add r12, 8              ;point to next arg
        cmp dword r13d, -1
        jne convert             ;loop
        xor r13d, r13d
callsub:	
	subsqr [arr+(r13d*4)], [arr+((r13d+1)*4)]
	subsqr [arr+((r13d+2)*4)], [arr+((r13d+3)*4)]
	jmp calladd
calladd:
        addsqrt [arr+(r13d*4)], [arr + ((r13d+2)*4)]    ;use the 0th and 2nd element in the array.   
        jmp print
print:				        ;now will only print floating point numbers.
	mov edi, ffmt 			;floating point format.
	mov eax, 1			;variable arguments.
	call printf
	jmp restore
	
restore:
        add rsp, 8              ;restore stack to prealigned value.
        pop rsi
        pop rdi
return:

        ;return
        mov eax, 1
        mov ebx, 0
        int 80h
section .data
	arr dd 0, 0, 0, 0	;y2y1x2x1 ;integer array, statically defined for now.
	dfmt dw "%d",10,0 
	ffmt db "The distance is %f",10,0

