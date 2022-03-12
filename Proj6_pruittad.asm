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
	push	edx
	mov		edx, numPrompt
	call	WriteString
	mov		edx, numEntered
	mov		ecx, count
	call	ReadString
	mov		[numEntered], edx
	mov		[byteRead], EAX
	pop		edx
  
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
  ASCIIARRAYSIZE = 20
  

.data
 
  numArray			sdword	ARRAYSIZE DUP(?)
  asciiArray		byte	ASCIIARRAYSIZE DUP(?)

  intro1			byte	"PROGRAMMING ASSIGNMENT 6: Designing low-level I/O procedures", 13, 10
					byte	"Written by: Adam Pruitt", 13, 10, 13, 10
					byte	"Please provide 10 signed decimal integers.", 13, 10
					byte	"Each number needs to be small enough to fit inside a 32 bit register. After you have finished inputting", 13, 10
					byte	"the raw numbers I will display a list of the integers, their sum, and their average value.", 13, 10, 13, 10, 0
  enterNum			byte	"Please enter a signed number: ", 0
  wrongNum			byte	"ERROR: You did not enter a signed number or your number was too big.", 13, 10
					byte	"Please try again: ", 0
  enteredNums		byte	"You entered the following numbers: ", 13, 10, 0
  sumString			byte	"The sum of thse numbers is: ", 0
  averageString		byte	"The truncated average is: ", 0
  stringLen			sdword	?	
  buffer			byte	21 DUP (0)
  bytesRead			sdword	?
  inString			byte	CHARACTERSIZE dup(?)

  enteredNum		sdword	?
  arrayPosition		sdword	0
  count				sDWORD   LENGTHOF numArray  ; debugging purposes
  numSum			sdword	?
  numAverage		sdword	?
  lengthAscii		sdword	LENGTHOF  asciiArray


  



.code
main PROC

  push	offset intro1
  call	Intro

  mov	ecx, 10
_getNumLoop:
  push	arrayPosition
  push	offset	numArray
  push	offset	wrongNum
  push	offset	bytesRead
  push	offset	inString
  push	offset	enterNum
  call	ReadVal
  add	arrayPosition, 4
  loop _getNumLoop

  call	crlf


  push	count
  push	offset	asciiArray
  push	offset	numArray
  push	offset	enteredNums
  call	PrintArray
  

  ;Finding the sum
  call	crlf
  push	offset numSum
  push	count
  push	offset	numArray
  call  FindSum


  push	offset	numAverage
  push	offset	numSum
  push	offset	averageString
  call	FindAverage


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
  pushad

  mDisplayString [ebp+8]			; Prints intro1.

  popad
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
  push  ecx						; Saving the loop count.
  
  mov	edi, 0				; This is going to be my integer
  mov	edx, 0				; Make sure this is cleared or it will make some of the integers negative.

_start:
  mGetString [ebp+8], CHARACTERSIZE, [ebp+12], [ebp+16]
  mov	eax, [ebp+16]		; The number of bytes read.
  mov	esi, [ebp+12]		; Storing the string that was entered into esi.

  cld
  mov	ecx, eax
  cmp	ecx, 11				; Checking if the number is too large.
  jg	_invalid
_getNumber:			
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
  cmp	ecx, 11				; Checking if the number is too large.
  jg	_invalid
  jmp	_getNumber

; converting the string to a number.
_convert:

  push  eax						; Saving the value in eax. This is the ascii value
  push	edx						; Saving if it's negative.
  sub	eax, 48					; Subtracting 48 from it.
  mov	ebx, eax				; Moving it to ebp.
  mov	eax, 10					; Moving 10 to eax to multiply.
  mul	edi						; edi is where the number is stored. Starts at 0. Multiply that by 10.
  mov	edi, eax				; Updating edi.
  add	edi, ebx				; Add edi to the amount when 48 subtracted from it.
  pop	edx						; Restoring the negative indicator.
  pop	eax						; Restoring eax.
  loop	_getNumber

; Checking to see if the the value had a negative sign.
  cmp	edx, 1
  je	_isNegative
  jmp	_addToArray

; If it's negative it is negated.
_isNegative:
  neg	edi
  jmp	_addToArray


_addToArray:
  mov	edx, [ebp + 28]
  mov	eax, [ebp + 24]
  add	eax, edx
  mov	[eax], edi
  ;mov	edi, [eax]		; Debugging purposes printed out the number.
  ;mov	eax, edi
  ;call	writeint




; add the number to the array.
  pop   ecx
  pop	EBP						; Restore EBP.
  RET	28						; Change this value to however much is pushed onto the stack before the procedure is called.

ReadVal		ENDP


;----------------------------------------------------------------------------------------------------
; Name: PrintArray
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

PrintArray	Proc
  PUSH	EBP						; Preserve EBP
  mov	EBP, ESP				; Assign static stack-fram pointer.
  pushad


  mDisplayString [ebp + 8]		; Displays the string enteredNums
  mov	ecx, 0

  mov	edi, [ebp + 16]			; Array to store values
  mov	esi, [ebp + 12]			; Move the first element of the array.
  mov	ecx, 10
  _printVal:
  push	ecx
  push	edi
  ;push	esi
  ; make sure to push and add.
  call	writeVal
  ;pop	esi
  ;pop	edi
  add	esi, 4
  ;pop	ecx
  loop	_printVal
  
  popad
  pop	EBP						; Restore EBP.
  RET	20						; Change this value to however much is pushed onto the stack before the procedure is called.
  
PrintArray	ENDP

;----------------------------------------------------------------------------------------------------
; Name: writeVal
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
  pushad
  CLD

_letsChangeThisNum:
  mov	eax, [esi]				; Move the value into eax
  mov	ecx, 1


	_nextNum:
	  cmp	eax, 0
	  jl	_negativeNum
	  mov	ebx, 10
	  cdq
	  idiv	ebx
	  add	edx, 48
	  push  edx					; Move the remainder onto the stack
	  cmp	eax, 0
	  jg	_addFourNum			; Continue converting the next number.
	  ;mov	edi, [ebp + 8]
	  jmp	_printNum

_addFourNum:
  add	ecx, 1
  jmp	_nextNum


_negativeNum:
  neg	eax
  push	eax
  mov	al, '-'
  call	writeChar
  pop	eax
  jmp	_nextNum  

_printNum:
  pop	eax
  stosb
  mov	edx, eax
  mov	edx, [ebp + 8]
  loop	_printNum
  mDisplayString edx
  mov	al, ','
  call	WriteChar
  mov	al, ' '
  call	WriteChar
  mov	eax, 0
  stosb


  _end:

  popad
  pop	EBP						; Restore EBP.
  RET							; Change this value to however much is pushed onto the stack before the procedure is called.
  
WriteVal	ENDP

;----------------------------------------------------------------------------------------------------
; Name: FindSum
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

FindSum		Proc
  PUSH	EBP						; Preserve EBP
  mov	EBP, ESP				; Assign static stack-fram pointer.
  pushad

  mov	edx, 0
  mov	edi, [ebp + 8]			; Move the first element of the array.
  mov	ecx, [ebp + 12]
  
  _addNums:
  mov	eax, [edi]
  add	edx, eax
  add	edi, 4
  loop	_addNums
  mov	eax, 0
  mov	eax, [ebp + 16]			; Where the sum is stored
  mov	[eax], edx




  popad
  pop	EBP						; Restore EBP.
  RET	16						; Change this value to however much is pushed onto the stack before the procedure is called.

FindSum		ENDP



;----------------------------------------------------------------------------------------------------
; Name: FindAverage
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

FindAverage		Proc
  PUSH	EBP						; Preserve EBP
  mov	EBP, ESP				; Assign static stack-fram pointer.
  pushad

  mDisplayString [ebp + 8]

  mov	edx, [ebp + 12]
  mov	eax, [edx]
  mov	esi, 10	
  cdq
  idiv	esi
  imul	edx, 2
  cmp	edx, eax
  jge	_addOne
  jmp	_dontAdd

  _addone:
  add	eax, 1
  mov	edx, [ebp + 16]			; Where the average is stored
  mov	[edx], eax
  jmp	_end

  _dontAdd:
  mov	edx, [ebp + 16]			; Where the average is stored
  mov	[edx], eax

  _end:

  popad
  pop	EBP						; Restore EBP.
  RET	16						; Change this value to however much is pushed onto the stack before the procedure is called.

FindAverage		ENDP

END main

