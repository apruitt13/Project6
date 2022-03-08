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
  mGetString
  ; Needs to display a prompt by reference. 

  ; Check that the user's entry is within the length that can be accepted and that it has only numbers.

  ; Accept the user's number entry and store it in a memory location. Output parameter by reference.


  mDisplayString

  ; Needs to print the string which is stored in a specific memory by reference.

  

; (insert constant definitions here)

.data

; (insert variable definitions here)

.code
main PROC

; Implement two procedures for signed integers which useing string primitive directions.

; Needs a loop counter for 10.

call ReadVal
; Uses the mGetString to get the user inpus in the form of a string of digits.
; Converts the the ascii digits to its numeric value representation (SDWORD).
; Needs to validate that the user's input is a valid number.
; Store it in a list.


call WriteVal
; Convert the number to a string of ascii digits.
; Invoke the mDisplayString macro to print the ASCII represntation of the SDWORD value.

	Invoke ExitProcess,0	; exit to operating system
main ENDP

; (insert additional procedures here)

END main
