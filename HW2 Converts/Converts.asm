;                 Name: Torkom Pailevanian
;
;                 Function: Converters
$INCLUDE (converts.inc)

NAME Converts

CGROUP  GROUP   CODE   

CODE	SEGMENT PUBLIC 'CODE'           

	ASSUME  CS:CGROUP     

; Dec2String 
; 
; Description:	    The function is passed a 16-bit signed value to convert to 
;	                  decimal value (at most 5 digits plus sign) and store as a 
;                   string. The string contains the <null> terminated decimal 
;                   representation of the value in ASCII. The resulting string 
;                   is stored starting at the memory location indicated by the 
;                   passed address
;
; Operation: 	      The function first checks to see if the digit is positive 
;                   or negative.  The function starts dividing with the largest
;                   power of 10 possible (10000) and loops dividing the number 
;                   by the power of 10, the quotient is a digit and the 
;                   remainder is used in the next iteration of the loop.  Each 
;                   loop iteration divides the power of 10 by 10 until it is 0.  
;                   At that point the number has been converted to string.
; 
; Arguments:	        AX - binary value to convert to decimal (n)
;	                    SI - address to start storing string (a)
;
; Return Value:	      None	 
; 
; Local Variables: 	  Remainder - remainder from division operation
;	                    pwr10 - power of 10 being divided by
;	                    arg - copy of number to convert
;                     string_index - stores index of output string
;	
; Shared Variables:   None
; Global Variables:   None
; 
; Input:              None
; Output:             None
; 
; Error Handling:     None
; 
; Algorithms:         None.
;
; Data Structures:    None.
; 
; Registers Changed:  AX, SI, DX, CX, CF, SF, ZF
; 
; Known Bugs:         None.
;
; Limitations:        Can only handle signed inputs of 16 bits
;
; Revision History:   10/19/14   Torkom Pailevanian   initial revision
;                     10/24/14   Torkom Pailevanian   wrote asm code
;
;Pseudo Code
;   pwr10 = 10000
;	  IF(negative)
;		    add "-" to string
;       negate arg
;	  REPEAT
;		    remainder = arg modulo pwr10
;		    arg = arg/pwr10
;		    add to string pointer location arg + '0' for ascii value
;       increment string pointer by 1 byte
;       arg = remainder
;		    pwr10 = pwr10/10
;	  UNTIL (pwr10 = 0)
;	  add <null> to end string


Dec2String      PROC        NEAR                 
                PUBLIC      Dec2String

Dec2StringInit:
        MOV     CX, 10000         ;start with the 10,000's digit
        ;JMP    CheckNegative     ;starts func to see if input is negative
          
CheckNegative:
        CMP     AX, 0             ;compare to check signed big
        JS      DoIfNegative      ;If signed bit on jumps to add "-" function
        JMP     Dec2StringLoop    ;jump to main loop if arg is not negative
          
DoIfNegative:
        MOV     byte ptr [SI], ASCII_BAR  ;Add the '-' char to string since negative
        INC     SI                ;increments SI so we can store the next char
        NEG     AX                ;Makes arg unsigned to start dividing
        ;JMP    Dec2StringLoop    ;Runs the main loop

Dec2StringLoop:
        MOV     DX, 0             
        CMP     CX, 0             ;checks if pwr10 > 0
        JLE     AddNullToDecString   ;exits the loop if the pwr10 <= 0
        
Dec2StringLoopBody:
        MOV     DX, 0             ;setup for arg/pwr10
        DIV     CX                ;divides the argument by pwr10
        PUSH    DX                ;Put remainder on stack so to divide
        MOV     byte ptr [SI], ASCII_0  ;adds offser for '0' to string location
        ADD     [SI], AX          ;adds the value of quotent to string location
        INC     SI                ;increments SI so we can store next char
        MOV     AX, CX            ;moves pwr10 to AX so we can divide by 10
        MOV     CX, 10            ;Moves 10 into CX so we can divide
        MOV     DX, 0             ;Clears DX before dividing
        DIV     CX                ;divides pwr10 by 10
        MOV     CX, AX            ;puts new pwr10 into CX
        POP     DX                ;puts remainder back in DX
        MOV     AX, DX            ;puts argument back into AX
        JMP     Dec2StringLoop    ;starts back at the top of loop
        
AddNullToDecString:
        MOV     byte ptr [SI], ASCII_NULL  ;terminates the string with a null  
        ;JMP    EndDec2String     ;done converting

EndDec2String:
        RET                       ;Return from function
 
Dec2String	ENDP     

; Hex2String 
; 
; Description:        The function is passed a 16-bit unsigned value (n) to 
;                     convert to 16 bit hexadecimal and store as an ASCII
;                     string. The string is terminated by the <null> 
;                     terminated hexadecimal representation of the value in 
;                     ASCII. The resulting string is stored starting at the 
;                     memory location indicated by the passed address. 
; 
; Operation:          This function rotates the argument by 4 bits and does a 
;                     bitwise	and with 0x000F to get the value of last 4 
;                     digits.  It takes this value as an offset from the
;                     '0' or 'A' character, depending on its value, to add 
;                     the character to the string.
; 
; Arguments:          AX - binary value to convert to hex (n)
;	                    SI - address to start storing string (a)
;
; Return Value:       None.	
; 
; Local Variables:    arg - copy of number to convert to hex
;                     string_index - stores index of output string   
;	                    result - value of AND operation
;
; Shared Variables:   None.
; Global Variables:   None.
; 
; Input:              None.
; Output:             None.
; 
; Error Handling:     None. 
; 
; Algorithms:         None.
;
; Data Structures:    None.
; 
; Registers Changed:  AX, SI, CX, SF, OF, ZF
;
; Known Bugs:         None.
;
; Limitations:        Can only handle unsigned inputs of 16 bits
; 
; Revision History:   10/19/14   Torkom Pailevanian   initial revision
;                     10/24/14   Torkom Pailevanian   wrote asm code
;
;  Pseudo Code
;	      FOR (i = 0 to 3, i++)
;         Rotate arg 4 bits right
;		      result = AND arg with 0x000F
;		      IF(result between 0 and 9)
;			        add result + '0' to string pointer location
;		      ELSE
;			        add result - 10 + 'A' to string pointer location
; 		    increments string pointer by 1 byte
;	      add <null> to end of string 

Hex2String	    PROC        NEAR                 
                PUBLIC      Hex2String
                
Hex2StringInit:
        MOV     CX, 0             ;initialize counter for FOR loop
        ;JMP    Hex2StringLoop    ;starts main loop for conversion

Hex2StringLoop:
        CMP     CX, 4             ;checks to see if the loop is done iterating
        JGE     AddNullToHexString   ;Exits loop if the counter is >= 4
        ;JMP    Hex2StringLoopBody  ;Enters loop body

Hex2StringLoopBody:
        ROL     AX, 4             ;rotates argument 4 bits to the left
        MOV     DX, AX            ;moves argument to DX to prepare for AND op
        AND     DX, 000Fh         ;gets the least significant 4 bits
        CMP     DX, 10            ;compares least sig 4 bits with 10
        JGE     UpperChars        ;if >= 10 goes to upper loop A-F
        ;JMP    LowerChars        ;else goes to lower characters loop 0-9
        
LowerChars:
        MOV     byte ptr [SI], ASCII_0  ;Add the '0' offset to string
        ADD     [SI], DX          ;Adds the value of the Offset from '0' to SI
        JMP     Increments        ;Jumps to last part of loop
        
UpperChars:
        SUB     DX, 10            ;find the quotents offset from 'A'
        MOV     byte ptr [SI], ASCII_A  ;Adds the 'A' offset to the string
        ADD     [SI], DX          ;Add the offset from 'A' to the string
        ;JMP    Increments        ;Jumps to last part of loop
        
Increments:        
        INC     SI                ;Increment SI to add next character
        INC     CX                ;Increment the counter for the loop
        JMP     Hex2StringLoop    ;Go back to start of loop

AddNullToHexString:
        MOV     byte ptr [SI], ASCII_NULL  ;terminates the string with a null  
        ;JMP    EndHex2String     ;done converting
EndHex2String:
        RET                       ;Return from function
        
Hex2String	ENDP    

CODE	ENDS            



	END
