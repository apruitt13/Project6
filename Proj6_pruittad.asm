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
  mGetString macro numPrompt

  PUSH  EAX
  MOV   EDX, numPrompt
  CALL  WriteString
  POP   EAX
ENDM
  ; Needs to display a prompt by reference. 

  ; Check that the user's entry is within the length that can be accepted and that it has only numbers.

  ; Accept the user's number entry and store it in a memory location. Output parameter by reference.


  mDisplayString macro string
	push	EAX
	call	WriteString					; Prints whatever string is passed to it.
	pop		EAX
  ENDM


; (insert constant definitions here)
  ARRAYSIZE = 5
  STRINGSIZE = 11

.data
 
  randArray			dword	ARRAYSIZE DUP(?)

  intro1			byte	"PROGRAMMING ASSIGNMENT 6: Designing low-level I/O procedures", 13, 10
					byte	"Written by: Adam Pruitt", 13, 10, 13, 10
					byte	"Please provide 10 signed decimal integers.", 13, 10
					byte	"Each number needs to be small enough to fit inside a 32 bit register. After you have finished inputting", 13, 10
					byte	"the raw numbers I will display a list of the integers, their sum, and their average value.", 13, 10, 13, 10, 0
  enterNum			byte	"Please enter a signed number: ", 10, 13, 0
  wrongNum			byte	"ERROR: You did not enter a signed number or your number was too big.", 13, 10
					byte	"Please try again: ", 13, 10, 0
  stringLen			dword	?	

  



.code
main PROC

  push	offset intro1
  call	Intro

  mov	ecx, STRINGSIZE
_getNumLoop:

  call	ReadVal

; Uses the mGetString to get the user inpus in the form of a string of digits.
; Converts the the ascii digits to its numeric value representation (SDWORD).
; Needs to validate that the user's input is a valid number.
; Store it in a list.

  call WriteVal

  loop _getNumLoop

; Implement two procedures for signed integers which useing string primitive directions.

; Needs a loop counter for 10.






; Convert the number to a string of ascii digits.
; Invoke the mDisplayString macro to print the ASCII represntation of the SDWORD value.

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

  mov	edx, [ebp+8]
  mDisplayString edx			; Prints intro1.

  pop	EBP						; Restore EBP.
  RET	4
Intro	ENDP



; 48 is the magic number for changing ascii to a number.
ReadVal	Proc
  PUSH	EBP						; Preserve EBP
  mov	EBP, ESP				; Assign static stack-fram pointer.



  pop	EBP						; Restore EBP.
  RET	4						; Change this value to however much is pushed onto the stack before the procedure is called.

ReadVal		ENDP



WriteVal	Proc
  PUSH	EBP						; Preserve EBP
  mov	EBP, ESP				; Assign static stack-fram pointer.



  pop	EBP						; Restore EBP.
  RET	4						; Change this value to however much is pushed onto the stack before the procedure is called.

WriteVal	ENDP

END main

