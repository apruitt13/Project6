TITLE Project 6     (Proj6_pruittad.asm)

; Author: Adam Pruitt
; Last Modified: 3/13/22
; OSU email address: pruittad@oregonstate.edu
; Course number/section:   CS271 Section 401
; Project Number:     6            Due Date: 3/13/22
; Description: This is a program that has asks a user for 10 signed decinal integers. It will then take those integers and print them out, add them and find the average.
; This program however can only use macros to get the string of numbers, convert them to integers, and print them out as strings.

INCLUDE Irvine32.inc

;----------------------------------------------------------------------------------------------------
; Name: mGetString
;
; Will prompt a user to enter a number. Then it will read that number as a string and store it along
; with the bytes read.
;
; Preconditions: Must pass the prompt, the buffer size, the location where the string will be saved,
; and a location for where the bytes read will be saved.
;
; Receives: 
;	numPrompt	= The string that will be printed to prompt the user to enter a string.
;	count		= The buffer size of the string.
;	numEntered	= The location where the entered string will be saved.
;	byteRead	= The location where the bytes read will be saved.
; 
; Returns: 
;	numEntered	= The string that was entered.
;	byteRead	= The amount of bytes read.
;----------------------------------------------------------------------------------------------------
  mGetString macro numPrompt, count, numEntered, byteRead
	push	edx
	mov		edx, numPrompt			; Move the prompt into edx and display it.
	call	WriteString
	mov		edx, numEntered			; Move the location of numEntered into edx.
	mov		ecx, count				; Move the location of the count into ecx.
	call	ReadString				; Read what the user entered.
	mov		[numEntered], edx		; Save the user entered string into the location numEntered.
	mov		[byteRead], EAX			; Move the bytes read into the location byteRead.
	pop		edx
  
ENDM

;----------------------------------------------------------------------------------------------------
; Name: mDisplayString
;
; Will print out a string.
;
; Preconditions: Must pass the prompt.
;
; Receives: 
;	string	=	The string that will be printed.
; 
; Returns: None
;----------------------------------------------------------------------------------------------------
  mDisplayString macro string
	push	EDX
	mov		EDX, string					
	call	WriteString					; Prints whatever string is passed to it.
	pop		EDX
  ENDM


  ARRAYSIZE = 10						; Constant for the array size.
  CHARACTERSIZE	= 20					; Constant for the string inputed.
  ASCIIARRAYSIZE = 20					; Constant for the arcii array size.
  

.data
 
  numArray			sdword	ARRAYSIZE DUP(?)					; Integer array.
  asciiArray		byte	ASCIIARRAYSIZE DUP(?)				; Ascii array.

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
  goodbye			byte	"Thanks for playing!", 13,10,0
  buffer			byte	21 DUP (0)
  bytesRead			sdword	?							
  inString			byte	CHARACTERSIZE dup(?)
  arrayPosition		sdword	0
  count				sDWORD  LENGTHOF numArray  
  numSum			sdword	?									; Where the sum is stored.
  numAverage		sdword	?									; Where the average is stored.
  lengthAscii		sdword	LENGTHOF  asciiArray


.code
main PROC

  ; Printing the intro.
  push	offset intro1
  call	Intro

; -----------------------------------
; Asks the user for 10 numbers. The numbers are entered as strings
; and then are converted to integers. Before converting it will 
; check to see if the number is valid and in the correct range.
; Then it will store the integer in an array.

; -----------------------------------
  mov	ecx, 10
_getNumLoop:
  push	arrayPosition
  push	offset	numArray
  push	offset	wrongNum
  push	offset	bytesRead
  push	offset	inString
  push	offset	enterNum
  call	ReadVal						; Calling ReadVal to retrieve and store the numbers.
  add	arrayPosition, 4			; Moving to the next array value.
  loop _getNumLoop					; This needs to be looped 10 times to get 10 values.

  call	crlf


; -----------------------------------
; Prints out the array of numbers. It first converts the integer
; by calling WriteVal then it prints the string. It uses an empty array 
; to store the string and prints it out. This will loop 10 times in the 
; procedure.

; -----------------------------------
  ;printing out the array.
  push	count
  push	offset	asciiArray			; Where the string is stored.
  push	offset	numArray			; The integers that were entered.
  push	offset	enteredNums			; String to display.
  call	PrintArray
  
  call	crlf

; -----------------------------------
; Finds the sum of all the entered numbers. It will then print the sum
; by converting the integer into a string using WriteVal.

; -----------------------------------
  push	offset	sumString			; String to be printed saying this is the sum.
  push	offset	numSum				; Where the sum is stored.
  push	offset	asciiArray
  push	count						; Length of the array for loop.
  push	offset	numArray			; The array of integers.
  call  FindSum

  call	crlf


; -----------------------------------
; Finds the average of all the entered numbers. It will then print the sum
; by converting the integer into a string using WriteVal.

; -----------------------------------
  push	offset	numAverage			; Where the average is stored.
  push	offset	asciiArray
  push	offset	numSum
  push	offset	averageString		; String to be printed saying this is the average.
  call	FindAverage

  call	crlf
  call	crlf

  ; Printing out the goodbye.
  push	offset	goodbye
  call	Ending

	Invoke ExitProcess,0	; exit to operating system
main ENDP


;----------------------------------------------------------------------------------------------------
; Name: Intro
;
; Displays the introduction 
;
; Preconditions: The only preconditions are that the variables need to be pushed onto the stack in
; the correct order.
;
; Postconditions: All registers have been restored.
;
; Receives: Some of these are global variables but are first pushed onto the stack. So they are only refereced.
;	intro1 - [ebp+8] - The string for the intro.
; 
; Returns: None
;----------------------------------------------------------------------------------------------------

Intro	Proc
  PUSH	EBP						; Preserve EBP
  mov	EBP, ESP				; Assign static stack-fram pointer.
  pushad

  mDisplayString [ebp+8]		; Prints intro1.

  popad
  pop	EBP						; Restore EBP.
  RET	4						; Cleans up the stack frame.
Intro	ENDP


;----------------------------------------------------------------------------------------------------
; Name: ReadVal
;
; Asks the user for 10 numbers. The numbers are entered as strings and then are converted to integers.  
; Before converting it will check to see if the number is valid and in the correct range.
; Then it will store the integer in an array.
;
; Preconditions: The only preconditions are that the variables, arrays, and strings need to be pushed onto 
; the stack in the correct order.
;
; Postconditions: All registers are restored.
;
; Receives: Some of these are global variables but are first pushed onto the stack. So they are only refereced.
;   arrayPosition		= [ebp + 28] - The position in the array that is being filled.
;   numArray			= [ebp + 24] - The array where the integer is stored.
;   wrongNum			= [ebp + 20] - The string for when a wrong number is entered.
;   bytesRead			= [ebp + 16] - The amount of bytes read during the mGetString macro.
;   inString			= [ebp + 12] - Where the number, as a string, is stored that was entered by the user.
;   enterNum			= [ebp + 12] - The prompt to ask the user to enter a number.
; 
; Returns: 
;   numArray			= [ebp + 24] - The array will have an integer added to it.
;   bytesRead			= [ebp + 16] - The amount of bytes read during the mGetString macro will be saved.
;   inString			= [ebp + 12] - Where the number, as a string, is stored that was entered by the user.
;  
;----------------------------------------------------------------------------------------------------
ReadVal	Proc
  PUSH	EBP					; Preserve EBP
  mov	EBP, ESP			; Assign static stack-fram pointer.
  pushad					; Saving the loop count and different registers.
						
  
  mov	edi, 0				; This is going to be my integer, where it will be coverted into.
  mov	edx, 0				; Makeing sure this is cleared or it will make some of the integers negative.

; -----------------------------------
; Beginning of the section that will ask the user for a number
; and convert it into a string.

; -----------------------------------
_start:
  mGetString [ebp+8], CHARACTERSIZE, [ebp+12], [ebp+16]		; Calling the macro to print the prompt and retrieve a number as a string.
  mov	eax, [ebp+16]		; The number of bytes read.
  mov	esi, [ebp+12]		; Storing the string that was entered into esi.

  cld
  mov	ecx, eax
  cmp	ecx, 11				; Checking if the number is too large.
  jg	_invalid			; If it is jump to invalid.

; -----------------------------------
; Section that validates the number and if it's not jumps to the
; section that gets a new number.

; -----------------------------------
_validateNumber:			
  xor	eax, eax
LODSB
  cmp	eax, 45
  je	_negative			; If it's a negative sign.
  cmp	eax, 43
  je	_positive			; If it's a positive sign.
  cmp	eax, 48
  jl	_invalid			; Jump to _invalid if it's not a number. Numbers are between 48 and 57.
  cmp	eax, 57
  jg	_invalid
  jmp	_convert

; -----------------------------------
; This is the section where if a negative sign is in the string
; it jumps to here. It checks to see if the negative sign is at the 
; beginning of the string. If it is it sets an indicator for later
; if it isn't it's an invalid number.

; -----------------------------------
_negative:
  push	eax
  mov	eax, [ebp+16]		; The number of bytes read.
  cmp	ecx, eax			; Comparing ecx to the number of bytes read. ECX holds the counter for how many times it loops for the string.
  pop	eax
  jl	_invalid
  mov	edx, 1				; Adds 1 to edx to indicate it's a negative number for later.
  loop	_validateNumber
  
; -----------------------------------
; This is the section where if an addition sign is in the string
; it jumps to here. It checks to see if the addition sign is at the 
; beginning of the string. It won't change anything if it is. If it's
; not at the beginning it is invalid.

; -----------------------------------
_positive:
  mov	eax, [ebp+16]		; If there is a addition sign. 
  cmp	ecx, eax			; Comparing ecx to the number of bytes read. ECX holds the counter for how many times it loops for the string.
  jl	_invalid
  loop	_validateNumber

; -----------------------------------
; If a number is invalid it jumps to this section. It will not
; loop because it's invalid. It will display a new string and 
; store a new number, as a string. It will then make sure it's
; not too large and move to see if it's a valid number.

; -----------------------------------
_invalid:
  mov	edi, 0													; Clearing edi for if there are multiple invalid numbers in a row.
  mGetString [ebp+20], CHARACTERSIZE, [ebp+12], [ebp+16]		; If it's an invalid number it prints a different statement and counts the string again.
  mov	eax, [ebp+16]											; The number of bytes read.
  mov	esi, [ebp+12]											; Storing the string that was entered into esi.
  mov	ecx, eax
  cmp	ecx, 11													; Checking if the number is too large.
  jg	_invalid
  jmp	_validateNumber

; -----------------------------------
; At this point it is a valid number string and will be converted to an integer.
; This is done by subtracting 48 from the ascii value and multiplying by 10 to 
; get what integer it is. It then will continually add the remainders together.

; -----------------------------------
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
  loop	_validateNumber
; After the number is created checking to see if the the value had a negative sign.
  cmp	edx, 1
  je	_isNegative				; If it is negative it jumps.
  jmp	_addToArray

; If it's negative it is negated then jumps to the where it is added to the array.
_isNegative:
  neg	edi
  jmp	_addToArray

; -----------------------------------
; At this point it is an integer. The integer is added to the array
; and the procdure is done.

; -----------------------------------
_addToArray:
  mov	edx, [ebp + 28]			; Moves the number of the position of the array item to edx.
  mov	eax, [ebp + 24]			; Moves the array to eax.
  add	eax, edx				; Moves to the spot of the array.
  mov	[eax], edi				; Moves the integer to that spot.

  popad							; Restoring the registers.

  pop	EBP						; Restore EBP.
  RET	28						; Cleans up the stack frame.

ReadVal		ENDP


;----------------------------------------------------------------------------------------------------
; Name: PrintArray
;
; Prints out the array of numbers. It first converts the integer by calling WriteVal then it prints the string. 
; It uses an empty array to store the string and prints it out. This will loop 10 times.
;
; Preconditions: The only preconditions are that the variables, arrays, and strings need to be pushed onto 
; the stack in the correct order.
;
; Postconditions: All registers are restored.
;
; Receives: 
;	asciiArray	= [ebp + 16] - Where the integer is stored once converted to a string.
;	numArray	= [ebp + 12] - The integers that were entered.
;	enteredNums	= [ebp + 8]	 - The string that will be displayed.
; 
; Returns: 
;	asciiArray	= [ebp + 16] - Where the integer is stored once converted to a string.

;----------------------------------------------------------------------------------------------------

PrintArray	Proc
  PUSH	EBP						; Preserve EBP
  mov	EBP, ESP				; Assign static stack-fram pointer.
  pushad						; Saving the registers.


  mDisplayString [ebp + 8]		; Displays the string enteredNums
  mov	ecx, 0
  mov	edi, [ebp + 16]			; Array to store values
  mov	esi, [ebp + 12]			; Move the first element of the array.
  mov	ecx, 10

; -----------------------------------
; This is the loop that will continually call WriteVal to print the integers that were entered. 
; WriteVal will need to convert the integer into a string and then call mDisplayString.

; -----------------------------------
  _printVal:
  push	ecx						; Saving the loop count.
  push	edi						; Saving the array location.
  call	writeVal				; Calling the procedure.
  pop	edi						; Restoring the array location.
  pop	ecx						; Restoring the loop count.
  add	esi, 4					; Moving to the next array spot.
  cmp	ecx, 1					; If it's the end don't add a comma and period.
  je	_end
  mov	al, ','
  call	WriteChar
  mov	al, ' '
  call	WriteChar
  loop	_printVal
  
  _end:
  popad							; Restoring the registers.
  pop	EBP						; Restore EBP.
  RET	20						; Cleans up the stack frame.
  
PrintArray	ENDP


;----------------------------------------------------------------------------------------------------
; Name: FindSum
;
; Finds the sum of all the entered numbers. It will then print the sum by converting the integer into a string using WriteVal.
;
; Preconditions: The only preconditions are that the variables, arrays, and strings need to be pushed onto 
; the stack in the correct order.
;
; Postconditions: All registers are restored.
;
; Receives: 
;	sumString	= [ebp + 24] - String to be printed saying this is the sum.
;	numSum		= [ebp + 20] - Where the sum is stored.
;	asciiArray	= [ebp + 16] - The array where the string equivalent of an integer is stored when converted.		
;	count		= [ebp + 12] - Length of the array for loop.
;	numArray	= [ebp + 8]	 - The array where the integers are stored.
; 
; Returns: None
;----------------------------------------------------------------------------------------------------

FindSum		Proc
  PUSH	EBP						; Preserve EBP
  mov	EBP, ESP				; Assign static stack-fram pointer.
  pushad

  mDisplayString [ebp + 24]		; Displays the string enteredNums

  mov	edx, 0
  mov	edi, [ebp + 8]			; Move the first element of the array.
  mov	ecx, [ebp + 12]			; The count
 
; -----------------------------------
; This is the loop that will add up all of the integers in the array.
; It will continually add the next number to the running total and then
; move to the next item in the array.

; -----------------------------------
  _addNums:
  mov	eax, [edi]				; Move the number to eax.
  add	edx, eax				; Add eax to the total.
  add	edi, 4					; Move to the next integer in the array.
  loop	_addNums
  mov	eax, 0
  mov	eax, [ebp + 20]			; Where the sum is stored
  mov	[eax], edx				; The total was stored in edx now moving to sdword.	

; -----------------------------------
; This is where the sum of the numbers is displayed. WriteVal is called. The string
; to say this is the sum is passed to it as well as the integer. It will convert the integer
; into a string and display it.

; -----------------------------------
  mov	edi, [ebp + 16]			; The string that will be displayed.
  mov	esi, [ebp + 20]			; The sum of the integers.
  push	ecx						; Saves the count for the array length.
  push	edi						; Saved where the string is stored.
  call	writeVal
  pop	edi						; Restores edi.
  pop	ecx						; Restores ecx.


  popad							; Restores all the registers.
  pop	EBP						; Restore EBP.
  RET	20						; Cleans up the stack frame.

FindSum		ENDP


;----------------------------------------------------------------------------------------------------
; Name: FindAverage
;
; Finds the average of all the entered numbers. It will then print the average by converting the integer into a string using WriteVal.
;
; Preconditions: The only preconditions are that the variables, arrays, and strings need to be pushed onto 
; the stack in the correct order.
;
; Postconditions: All registers are restored.
;
; Receives: 
;	numAverage		= [ebp + 20] - Where the average is stored.
;	asciiArray		= [ebp + 16] - Where the integer once converted is saved.
;	numSum			= [ebp + 12] - The sum of all the integers.
;	averageString	= [ebp + 8]  - String to be printed saying this is the average.
; 
; Returns: None
;----------------------------------------------------------------------------------------------------

FindAverage		Proc
  PUSH	EBP						; Preserve EBP
  mov	EBP, ESP				; Assign static stack-fram pointer.
  pushad

  mDisplayString [ebp + 8]		; Displaying the string this is the average.

; -----------------------------------
; This where the average is calculated. It takes the sum of the integers
; and it divides it by 10.

; -----------------------------------
  mov	edx, [ebp + 12]			; Moves the sum location.
  mov	eax, [edx]				; Moves the integer into edx.
  mov	esi, 10					; Moves 10 to esi.
  cdq
  idiv	esi						; Divides the sum by 10.
  jmp	_store

  _store:
  mov	edx, [ebp + 20]			; Where the average is stored
  mov	[edx], eax				; Moves the average to storage.

; -----------------------------------
; This is where the average of the numbers is displayed. WriteVal is called. The string
; to say this is the average is passed to it as well as the integer. It will convert the integer
; into a string and display it.

; -----------------------------------
  _print:
  mov	edi, [ebp + 16]			; The string to display.
  mov	esi, [ebp + 20]			; The average.
  push	ecx						; Saves ecx.
  push	edi						; Saves edi.
  call	writeVal
  pop	edi						; Restores edi.
  pop	ecx						; Restores ecx.

  popad							; Restores all the registers.
  pop	EBP						; Restore EBP.
  RET	16						; Cleans up the stack frame.

FindAverage		ENDP


;----------------------------------------------------------------------------------------------------
; Name: WriteVal
;
; WriteVal takes in an integer from an array and will convert it into a string, store that in an array
; and then display the string version of the integer. 
;
; Preconditions: The only preconditions are that the variables, arrays, and strings need to be pushed onto 
; the stack in the correct order.
;
; Postconditions: All registers are restored.
;
; Receives: 
;	The location of the integer that needs to be converted. 
;	The location of the array where the ascii value of the integer is stored.
; 
; Returns: 
;	Will store a new ascii value in an array and display that value.
;	
;----------------------------------------------------------------------------------------------------
WriteVal	Proc
  PUSH	EBP						; Preserve EBP
  mov	EBP, ESP				; Assign static stack-fram pointer.
  pushad						; Saves all the registers.
  CLD

  mov	eax, [esi]				; Move the value into eax
  mov	ecx, 1					; Count for stosb of how many bytes to display.

; -----------------------------------
; This is where the integer is changed into a string. This is done by dividing the integer by 10,
; adding 48 to the remainder, and saving that value.

; -----------------------------------
_convertNum:
  cmp	eax, 0					; If the number is less than zero it's negative.
  jl	_negativeNum	
  mov	ebx, 10					
  cdq
  idiv	ebx						; Dividing the integer by 10.
  add	edx, 48
  push  edx						; Move the remainder onto the stack
  cmp	eax, 0
  jg	_addToCount				; Continue converting the next number.
  jmp	_printNum				; Or if finished jump to printing.

; Moves to the next number and adds one to the count for stosb.
_addToCount:					
  add	ecx, 1
  jmp	_convertNum

; -----------------------------------
; If it's a negative number the value is negated, a negative sign is printed
; and then jumps to _convertNum to convert the positive value into ascii.

; -----------------------------------
_negativeNum:
  neg	eax						; Negate the number.
  push	eax
  mov	al, '-'
  call	writeChar
  pop	eax
  jmp	_convertNum  

; -----------------------------------
; This is the section where the ascii value of the number is displayed. It takes
; the value from the array and writes it to the array, then moves to the next value
; in the array and stores that. Then it prints the whole ascii value.

; -----------------------------------
_printNum:
  pop	eax						; Pops the remainder which is the ascii value of the number.
  stosb							; Stores the bytes.
  mov	edx, [ebp + 8]			; Moves to the next number.
  loop	_printNum				; Continues doing this for all the bytes.
  mov	eax, 0					; The null terminator.
  stosb
  mDisplayString edx			; Displays the ascii value of the number.
  mov	eax, 0
  stosb

  popad							; Restores the registers.
  pop	EBP						; Restore EBP.
  RET							; The stack frame is cleaned before. If I change this it breaks the program.
  
WriteVal	ENDP


;----------------------------------------------------------------------------------------------------
; Name: Ending
;
; Displays the goodbye message. 
;
; Preconditions: The only preconditions are that the variables need to be pushed onto the stack in
; the correct order.
;
; Postconditions: All registers are restored.
;
; Receives: 
;	ending = [ebp + 8] - The goodbye message.
; 
; Returns: None
;----------------------------------------------------------------------------------------------------

Ending		PROC

  PUSH	EBP						; Preserve EBP
  mov	EBP, ESP				; Assign static stack-fram pointer.
  pushad						; Saves the registers.

  mDisplayString [ebp+8]		; Prints ending.

  popad							; Restores the registers.
  pop	EBP						; Restore EBP.
  RET	4						; Cleans up the stack frame.

Ending		ENDP

END main

