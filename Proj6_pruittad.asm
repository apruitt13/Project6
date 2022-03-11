TITLE Project 6     (Proj6_pruittad.asm)

; Author: Adam Pruitt
; Last Modified: 3/13/22
; OSU email address: pruittad@oregonstate.edu
; Course number/section:   CS271 Section 401
; Project Number:     6            Due Date: 3/13/22
; Description: This is a program that has asks a user for 10 signed decinal integers. It will then take those integers and print them out, add them and find the average.
; This program however can only use macros to get the string of numbers, convert them to integers, and print them out as strings.

INCLUDE Irvine32.inc

; Macros
  mGetString macro numPrompt, count, numEntered, byteRead
	mov		edx, numPrompt
	call	WriteString
	mov		edx, numEntered
	mov		ecx, count
	call	ReadString
	mov		[numEntered], edx
	mov		[byteRead], EAX
  
ENDM
  ; Needs to display a prompt by reference. 

  ; Check that the user's entry is within the length that can be accepted and that it has only numbers.

  ; Accept the user's number entry and store it in a memory location. Output parameter by reference.


  mDisplayString macro string
	push	EDX
	mov		EDX, string
	call	WriteString					; Prints whatever string is passed to it.
	pop		EDX
  ENDM


; (insert constant definitions here)
  ARRAYSIZE = 10
  CHARACTERSIZE	= 20
  

.data
 
  numArray			sdword	ARRAYSIZE DUP(?)

  intro1			byte	"PROGRAMMING ASSIGNMENT 6: Designing low-level I/O procedures", 13, 10
					byte	"Written by: Adam Pruitt", 13, 10, 13, 10
					byte	"Please provide 10 signed decimal integers.", 13, 10
					byte	"Each number needs to be small enough to fit inside a 32 bit register. After you have finished inputting", 13, 10
					byte	"the raw numbers I will display a list of the integers, their sum, and their average value.", 13, 10, 13, 10, 0
  enterNum			byte	"Please enter a signed number: ", 0
  wrongNum			byte	"ERROR: You did not enter a signed number or your number was too big.", 13, 10
					byte	"Please try again: ", 0
  stringLen			dword	?	
  buffer			byte	21 DUP (0)
  bytesRead			dword	?
  inString			byte	CHARACTERSIZE dup(?)

  enteredNum		sdword	?


  



.code
main PROC

  push	offset intro1
  call	Intro

  mov	ecx, 10
_getNumLoop:
  push  ecx

  push	offset	enteredNum
  push	offset	numArray
  push	offset	wrongNum
  push	offset	bytesRead
  push	offset	inString
  push	offset	enterNum
  call	ReadVal
  pop ecx
  loop _getNumLoop


	Invoke ExitProcess,0	; exit to operating system
main ENDP


;----------------------------------------------------------------------------------------------------
; Name: intro
;
; Displays the introduction 
;
; Preconditions: The only preconditions are that the variables need to be pushed onto the stack in
; the correct order.
;
; Postconditions: EDX changed.
;
; Receives: 
;	
; 
; Returns: None
;----------------------------------------------------------------------------------------------------

Intro	Proc
  PUSH	EBP						; Preserve EBP
  mov	EBP, ESP				; Assign static stack-fram pointer.

  mDisplayString [ebp+8]			; Prints intro1.

  pop	EBP						; Restore EBP.
  RET	4
Intro	ENDP

;----------------------------------------------------------------------------------------------------
; Name: intro
;
; Displays the introduction 
;
; Preconditions: The only preconditions are that the variables need to be pushed onto the stack in
; the correct order.
;
; Postconditions: EDX changed.
;
; Receives: 
;	
; 
; Returns: None
;----------------------------------------------------------------------------------------------------
ReadVal	Proc
  PUSH	EBP						; Preserve EBP
  mov	EBP, ESP				; Assign static stack-fram pointer.
  mov	edi, 0				; This is going to be my integer


_start:
  mGetString [ebp+8], CHARACTERSIZE, [ebp+12], [ebp+16]

  mov	eax, [ebp+16]		; The number of bytes read.
  mov	esi, [ebp+12]		; Storing the string that was entered into esi.


  cld


  mov	ecx, eax

_getNumber:			; Right now it is looping too many times. It is going past the end. I need to check the number in ECX to see what's wrong. It needs to be the string length.
  xor	eax, eax
LODSB
  ; I also need to check if the first number is a negative number or positive. But only the first time. Otherwise it's an invalid number.
  cmp	eax, 45
  je	_negative			; If it's a negative sign.
  cmp	eax, 43
  je	_positive			; If it's a positive sign.
  cmp	eax, 48
  jl	_invalid			; Jump to _invalid if it's not a number. Numbers are between 48 and 57.
  cmp	eax, 57
  jg	_invalid
  jmp	_convert

; If there is a negative sign at the beginning it's a valid number. Otherwise it's invalid.
_negative:
  push	eax
  mov	eax, [ebp+16]		; The number of bytes read.
  cmp	ecx, eax
  pop	eax
  jl	_invalid
  mov	edx, 1				; Adds 1 to edx to indicate it's a negative number for later.
  push	edx					; Preserve the 1
  loop	_getNumber
  
; If there is a positive sign at the beginning it's a valid number. Otherwise it's invalid.
_positive:
  mov	eax, [ebp+16]		; If there is a plus 
  cmp	ecx, eax
  jl	_invalid
  loop	_getNumber

; The number is not valid. A new string is displayed and a new number retrieved.
_invalid:
  mGetString [ebp+20], CHARACTERSIZE, [ebp+12], [ebp+16]		; If it's an invalid number it prints a different statement and counts the string again.
  mov	eax, [ebp+16]
  mov	esi, [ebp+12]

  mov	ecx, eax
  jmp	_getNumber

; converting the string to a number.
_convert:
  push  eax						; Saving the value in eax. This is the ascii value
  push	ebp
  sub	eax, 48					; Subtracting 48 from it.
  mov	ebp, eax				; Moving it to ebp.
  mov	eax, 10					; Moving 10 to eax to multiply.
  mul	edi						; edi is where the number is stored. Starts at 0. Multiply that by 10.
  mov	edi, eax				; Updating edi.
  add	edi, ebp				; Add edi to the amount when 48 subtracted from it.

  pop	ebp
  pop	eax
  loop	_getNumber
; check if it was zero and multiply by zero if it was
  pop	edx
  cmp	edx, 1
  je	_isNegative
  jmp	_addToArray

_isNegative:

  neg	edi
  jmp	_addToArray


_addToArray:
  mov	eax, [ebp + 28]
  mov	[eax], edi
  mov	edi, [eax]
  

  mov	[ebp + 24], edi
  mov	eax, [ebp + 24] ; checking the number by writing it. Can be deleted.
  call	writeint
  ;mov	[eax], edi
  ;mov	edi, [eax]
; add the number to the array.


  pop	EBP						; Restore EBP.
  RET	20						; Change this value to however much is pushed onto the stack before the procedure is called.

ReadVal		ENDP


;----------------------------------------------------------------------------------------------------
; Name: intro
;
; Displays the introduction 
;
; Preconditions: The only preconditions are that the variables need to be pushed onto the stack in
; the correct order.
;
; Postconditions: EDX changed.
;
; Receives: 
;	
; 
; Returns: None
;----------------------------------------------------------------------------------------------------
WriteVal	Proc
  PUSH	EBP						; Preserve EBP
  mov	EBP, ESP				; Assign static stack-fram pointer.

  ; need to change an integer to an ascii representation.

  pop	EBP						; Restore EBP.
  RET	4						; Change this value to however much is pushed onto the stack before the procedure is called.

WriteVal	ENDP

END main

