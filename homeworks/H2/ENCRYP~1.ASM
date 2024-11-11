include fisio.h
.model small
.stack 100h
.data
	error_msg db 'Something went wrong.$'
	succes_msg db 'Everything is fine.$'
	ifilen db 'dummy.txt',0
	oef db 'enc.fl',0
	key_file db 'enc.key',0
	odc db 'dec.txt',0
	buffer db 8 dup(0)
	key db ?
	hr dw ?
	hwe dw ?
	hwk dw ?
	result dw ?
	result2 dw ?
	result3 dw ?
.code
main:
	mov ax, @data
	mov ds, ax
	; generate a random XOR key using system time
	mov ah, 2ch ; DOS function to get system time
	int 21h
	mov key, dl ; use DL (seconds) as the random key
	CreazaFisier key_file, 0, hwk, result
	cmp result, -1
	je exit_process
	ScrieInFisier hwk, key, 1, result, result2
	InchideFisier hwk, result
	call encrypt_file
	call decrypt_file
	mov ax, 4c00h
	int 21h
	exit_process:
		mov ax, 4c01h
		int 21h

encrypt_file proc
	CreazaFisier oef, 0, hwe, result
	mov ax, result
	cmp ax, -1
	je error_exit
	DeschideFisier ifilen, 0, hr, result
	mov ax, result
	cmp ax, -1
	je error_exit
	jmp citire
	error_exit:
		mov ax, 4c01h
		int 21h
	citire:
	CitesteDinFisier hr, buffer, 8, result, result2
	cmp result, 0
	je exit_loop
	mov cx, result
	mov si, offset buffer
	encrypt_loop:
		mov al, byte ptr [si]
		xor al, key
		mov byte ptr [si], al
		inc si
		loop encrypt_loop
	ScrieInFisier hwe, buffer, result, result2, result3
	jmp citire

	exit_loop:
		InchideFisier hwe, result
		InchideFisier hr, result
		ret
	exit_label:
		mov ax, 4c01h
		int 21h
endp
	
decrypt_file proc
	CreazaFisier odc, 0, hwe, result
	mov ax, result
	cmp ax, -1
	je error_exit1
	DeschideFisier oef, 0, hr, result
	mov ax, result
	cmp ax, -1
	je error_exit1
	jmp citire
	error_exit1:
		mov ax, 4c01h
		int 21h
	citire1:
	CitesteDinFisier hr, buffer, 8, result, result2
	cmp result, 0
	je exit_loop1
	mov cx, result
	mov si, offset buffer
	encrypt_loop1:
		mov al, byte ptr [si]
		xor al, key
		mov byte ptr [si], al
		inc si
		loop encrypt_loop1
	ScrieInFisier hwe, buffer, result, result2, result3
	jmp citire1

	exit_loop1:
		InchideFisier hwe, result
		InchideFisier hr, result
		ret
	exit_label1:
		mov ax, 4c01h
		int 21h
endp
end main