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
  ARRAYSIZE = 5
  CHARACTERSIZE	= 20
  

.data
 
  numArray			dword	ARRAYSIZE DUP(?)

  intro1			byte	"PROGRAMMING ASSIGNMENT 6: Designing low-level I/O procedures", 13, 10
					byte	"Written by: Adam Pruitt", 13, 10, 13, 10
					byte	"Please provide 10 signed decimal integers.", 13, 10
					byte	"Each number needs to be small enough to fit inside a 32 bit register. After you have finished inputting", 13, 10
					byte	"the raw numbers I will display a list of the integers, their sum, and their average value.", 13, 10, 13, 10, 0
  enterNum			byte	"Please enter a signed number: ", 0
  wrongNum			byte	"ERROR: You did not enter a signed number or your number was too big.", 13, 10
					byte	"Please try again: ", 13, 10, 0
  stringLen			dword	?	
  buffer			byte	21 DUP (0)
  bytesRead			dword	?
  inString			byte	CHARACTERSIZE dup(?)


  



.code
main PROC

  push	offset intro1
  call	Intro

  mov	ecx, 10
_getNumLoop:
  push  ecx
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


  mGetString [ebp+8], CHARACTERSIZE, [ebp+12], [ebp+16]
  mov	eax, [ebp+16]
  mov	esi, [ebp+12]

cld

  xor	eax, eax
  mov	ecx, eax
  dec	ecx

LODSB
  cmp	al, 48
  jl	_invalid
  cmp	al, 57
  jg	_invalid


  jmp	_end

  



_invalid:
  mGetString [ebp+20], CHARACTERSIZE, [ebp+12], [ebp+16]


  _end:
  pop	EBP						; Restore EBP.
  RET	16						; Change this value to however much is pushed onto the stack before the procedure is called.

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



  pop	EBP						; Restore EBP.
  RET	4						; Change this value to however much is pushed onto the stack before the procedure is called.

WriteVal	ENDP

END main

