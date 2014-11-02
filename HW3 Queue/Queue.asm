;                 Name: Torkom Pailevanian
;
;                 Function: Queue

$INCLUDE (queue.inc)

NAME Queue

CGROUP  GROUP   CODE   

CODE	SEGMENT PUBLIC 'CODE'           

	ASSUME  CS:CGROUP     



; QueueInit 
; 
; Description:        Initialize the queue of the passed length (l) 
;                     and element size (s) at the passed address 
;                     (a). This procedure does all the necessary 
;                     initialization to prepare the queue for use. 
;                     After calling this procedure the queue is 
;                     empty and ready to accept values. The passed 
;                     length (l) is the maximum number of items that 
;                     can be stored in the queue. The passed element 
;                     size (s) specifies whether each entry in the 
;                     queue is a byte (8-bits) or a word (16-bits). 
;                     If s is true (non-zero) the elements are words 
;                     and if it is false (zero) they are bytes. 
;                     The address (a) is passed in SI by value 
;                     (thus the queue starts at DS:SI), the length 
;                     (l) is passed by value in AX, and the element 
;                     size (s) is passed by value in BL.
;
; Operation:          This function sets the location of the header
;                     pointer and the tail pointer both at the
;                     location of the first element.  The element 
;                     size is multiplied by the length of the queue.
;                     The last element of the queue is left empty to
;                     determine that the queue is full.  The first
;                     element is the header pointer.  The second
;                     element is the tail pointer. The third element
;                     is the size of each element. The length of the
;                     queue is stored in the fourth element.
; 
; Arguments:	      AX - length of the queue (l)
;	                  SI - address of the queue (a)
;                   BL - element size (s)
;
; Return Value:	      None	 
; 
; Local Variables:    AX - length of the queue
;                     SI - address of the queue
;                     BL - element size
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
; Registers Changed:  AX, SI, BL, CX, CF, SF, ZF
; 
; Known Bugs:         None.
;
; Limitations:        Can only handle element sizes of word and byte
;
; Revision History:   10/24/14   Torkom Pailevanian   initial revision
;                     10/30/14   Torkom Pailevanian   wrote assembly Code
;
;Pseudo Code
;       Set Headpointer at first element location
;       Set tailpointer at first element location
;       put value of element size (s) in Structure
;       put length of structure (l) in Structure
   
QueueInit             PROC        NEAR                 
                      PUBLIC      QueueInit

QueuePtrInit:
        MOV   [SI].headPtr, emptyQueueOffset  ;have the head pointer
                                  ;point to the first element of the structure
        MOV   [SI].tailPtr, emptyQueueOffset  ;have the tail pointer
                                  ;point to the first element of the structure
                                  ;since struct is empty
        CMP   BL, BYTE_TYPE       ;Checks if element size is byte (0) or word(> 0)
        JG    SetSizeWord         ;Size was not zero and the size byte needs to be 1
        ;JMP  SetSizeByte         ;Size was zero so the size byte needs to be 0

SetSizeByte:
        MOV   [SI].elemSize, BYTE_TYPE  ;Sets the size byte to 0 since elements are bytes
		JMP	  EndQueueInit		  ;Jumps to the end of the function

SetSizeWord:
        MOV   [SI].elemSize, WORD_TYPE  ;Sets the size byte to 1 since elements are words

EndQueueInit:
        RET                       ;Finishes the function
        
QueueInit      ENDP    


; QueueEmpty 
; 
; Description:        The function is called with the address of the 
;                     queue to be checked (a) and returns with the 
;                     zero flag set if the queue is empty and with the 
;                     zero flag reset otherwise. The address (a) is 
;                     passed in SI by value.
; 
; Operation:          This function checks to see if the header
;                     pointer and the tail pointer are pointing to the
;                     same location.  If the two pointers point to the
;                     same location then the zero flag is set, else,
;                     the zero flag is reset.
; 
; Arguments:          SI - address of the queue (a)
;
; Return Value:       ZF	
; 
; Local Variables:    SI - address of the queue (a)
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
; Registers Changed:  SI, SF, OF, ZF
;
; Known Bugs:         None.
;
; Limitations:        None.
; 
; Revision History:   10/24/14   Torkom Pailevanian   initial revision
;
;  Pseudo Code
;       If(head pointer == tail pointer)
;               set ZF
;       else
;               reset ZF

QueueEmpty	      PROC        NEAR                 
                  PUBLIC      QueueEmpty

CheckEmpty:
        MOV	  AL, [SI].headPtr	;Move head pointer to memory to compare with tail pointer
		CMP   AL, [SI].tailPtr  ;Checks if head pointer and tail pointer
                                          ;are pointing to same location
        ;JMP   QueueEmptyEnd       Zero flag is already set appropriately so to go to end of function

QueueEmptyEnd:
        RET                        ;Return from the function with zero flag state set

QueueEmpty	ENDP

; QueueFull 
; 
; Description:        The function is called with the address of the 
;                     queue to be checked (a) and returns with the 
;                     zero flag set if the queue is full and with the 
;                     zero flag reset otherwise. The address (a) is 
;                     passed in SI by value.
; 
; Operation:          This function checks to see if the tail pointer
;                     + 1 mod Arraysize is equal to the head pointer.
;                     This is the equivalent operation as tail pointer
;                     and Arraysize -1 if the arraysize is a power of
;                     2. If it is true, then the zero flag is set, if
;                     not the zero flag is reset.
; 
; Arguments:          SI - address of the queue (a)
;
; Return Value:       ZF        
; 
; Local Variables:    SI - address of the queue (a)
;
; Shared Variables:   None.
; Global Variables:   None.
; 
; Input:              None.
; Output:             None.
; 
; Error Handling:     None. 
; 
; Algorithms:         X MOD 2^n = X AND 2^n - 1
;
; Data Structures:    None.
; 
; Registers Changed:  SI, AX, SF, OF, ZF
;
; Known Bugs:         None.
;
; Limitations:        None.
; 
; Revision History:   10/24/14   Torkom Pailevanian   initial revision
;                     10/30/14   Torkom Pailevanian   wrote code and modified Algorithms
;
;  Pseudo Code
;       If(head pointer == ((tail pointer + 1)AND ArraySize - 1 ))
;               set ZF
;       else
;               reset ZF

QueueFull            PROC        NEAR                 
                     PUBLIC      QueueFull

CheckFull:

        MOV   AL, [SI].tailPtr  		;Moves tail pointer to SI to do AND operation with array size
        ADD   AL, emptyBuffer           ;Adds 2 to tail pointer since there is a 2 byte buffer space between
                                        ;the tail pointer and the headpointer when full
        MOV   BL, QUEUE_SIZE - 1        ;Prepares the (Array size - 1) argument to do AND operation since
                                        ;x MOD 2^n is equal to x AND 2^n - 1
        AND   AL, BL                    ;Completes MOD operation with queue size

        CMP   [SI].headPtr, AL  ;Checks if head pointer and extra byte are in the same location
        ;JMP   QueueFullEnd       Zero flag is already set appropriately so to go to end of function

QueueFullEnd:
        RET                        ;Return from the function with zero flag state set
        
QueueFull      ENDP    

; Dequeue 
; 
; Description:        This function removes either an 8-bit value or 
;                     a 16-bit value (depending on the queue's element 
;                     size) from the head of the queue at the passed 
;                     address (a) and returns it in AL or AX. The 
;                     value is returned in AL if the element size is 
;                     bytes and in AX if it is words. If the queue is 
;                     empty it waits until the queue has a value to 
;                     be removed and returned. It does not return 
;                     until a value is taken from the queue. The 
;                     address (a) is passed in SI by value.
; 
; Operation:          This function has a loop which checks to see if
;                     the queue is empty.  If the queue is empty it
;                     waits until the queue is not empty to retrieve
;                     the value at the head pointer.  If the size bit 
;                     is 0 then the function returns a single byte
;                     into AL.  If the size bit is a 1, the function
;                     returns a word into AX
; 
; Arguments:          SI - address of the queue (a)
;
; Return Value:       AX or AL        
; 
; Local Variables:    SI - address of the queue (a)
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
; Registers Changed:  SI, SF, OF, ZF, AX
;
; Known Bugs:         None.
;
; Limitations:        None.
; 
; Revision History:   10/24/14   Torkom Pailevanian   initial revision
;
;  Pseudo Code
;       While(queue empty)
;               wait
;               Put byte at head pointer in AL
;               Inc Headpointer
;               If(queue size == 1)
;                       put byte at Headpointer in AH
;                       inc Headpointer
;       

Dequeue            PROC        NEAR                 
                   PUBLIC      Dequeue

CheckQueueEmpty:
        PUSH  AX
        CALL  QueueEmpty                ;Checks to see if queue is empty before taking an element
        POP   AX
        JZ    CheckQueueEmpty           ;If queue is empty it blocks dequeue
        ;JMP  DequeueBody               ;start to pull data out of queue

DequeueBody:
        MOV   BL, [SI].headPtr  		;Move the value of the head pointer to BL
        MOV	  BH, 0						;Clear BX since address registers need to be 16 bits
		MOV   AL, [SI].queueData[BX] 	;Move value of element at head pointer to AL
        INC   BL                        ;Increments the value of the head pointer
        CMP   [SI].elemSize, WORD_TYPE  ;Checks if the elements are words
        JNZ   UpdateHeadPTR             ;calls function to update the headpointer for the next element
        ;JZ    RemoveMSB                ;if the size was word it calls function to move MSB to AH

RemoveMSB:
		MOV   BH, 0                     ;Clear the MSB of BX since our index for the que is at most 255
        MOV   AH, [SI].queueData[BX]    ;Move the MSB of element at head pointer to AL
        INC   BL                        ;Increments the value of the head pointer
        ;JMP  UpdateHeadPTR             ;updates the head pointer so that it points to the next location

UpdateHeadPTR:
        MOV   [SI].headPtr, BL  ;Only stores value of BL since the array size is 256 bytes so
                                        ;incrementing the head pointer at 255 would bring it back to 0
        ;JMP  EndDequeue                ;End function 
EndDequeue:
        RET                             ;Return from function

Dequeue      ENDP    

; Enqueue 
; 
; Description:        This function adds the passed 8-bit or 16-bit 
;                     (depending ont he elemenst size) value (v) to 
;                     the tail of the queue at the passed address (a). 
;                     If the queue is full it waits until the queue 
;                     has an open space in which to add the value. It 
;                     does not return until the value is added to the 
;                     queue. The address (a) is passed in SI by value 
;                     and the value to enqueue (v) is passed by value 
;                     in AL if the element size for the queue is bytes 
;                     and in AX if it is words.
; 
; Operation:          This function has a loop which checks to see if
;                     the queue is full.  If the queue is full it
;                     waits until the queue is has an empty spot
;                     to put the value at AX or AL at the location of
;                     the tail pointer. If the value of the size bit
;                     is 0 then only 1 byte is added to the loc of the
;                     tail pointer.  If the value of the size bit is 1
;                     then a word is added to the tail pointer with
;                     the least significant byte first.  Once the tail
;                     pointer reaches the bottom of the que, it starts
;                     from the top of the queue.
; 
; Arguments:          SI - address of the queue (a)
;                     AX - value to be added to the queue (v)
;
; Return Value:       None        
; 
; Local Variables:    SI - address of the queue (a)
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
; Registers Changed:  SI, SF, OF, ZF, AX
;
; Known Bugs:         None.
;
; Limitations:        None.
; 
; Revision History:   10/24/14   Torkom Pailevanian   initial revision
;
;  Pseudo Code
;       While(queue full)
;               wait
;       MOV AL into position at tail pointer
;       Inc tailpointer
;       If (size == 1)
;               MOV AH into tail pointer position
;       If (tail pointer at bottom)
;               place tail pointer at top of list
;       else
;               increment tail pointer
;       

Enqueue            PROC        NEAR                 
                   PUBLIC      Enqueue

CheckQueueFull:
        PUSH  AX
        CALL  QueueFull                 ;Checks to see if queue is full before taking an element
        POP   AX
        JZ    CheckQueueFull            ;If queue is empty it blocks dequeue
        ;JMP  EnqueueBody               ;start to pull data out of queue

EnqueueBody:
        MOV   BL, [SI].tailPtr  		;Move the value of the tail pointer to BL
        MOV   BH, 0						;Clears BH so that we can use lower 8 bits of BX for addressing
		MOV   [SI].queueData[BX], AL 	;Put AL at tail pointer value
        INC   BL                        ;Increments the value of the tail pointer
        CMP   [SI].elemSize, WORD_TYPE  ;Checks if the elements are words
        JNZ   UpdateTailPTR             ;calls function to update the tail pointer 
        ;JZ    PutMSB                  ;if the size was word it calls function to AH into the next byte

PutMSB:
		MOV   BH, 0                     ;Clear the MSB of BX since our index for the que is at most 255
        MOV   [SI].queueData[BX], AH 	;Move the MSB into the next byte of the queue
        INC   BL                        ;Increments the value of the tail pointer
        ;JMP  UpdateTailPTR             ;updates the tail pointer so that it points to the next location

UpdateTailPTR:
        MOV   [SI].tailPtr, BL  		;Only stores value of BL since the array size is 256 bytes so
                                        ;incrementing the tail pointer at 255 would bring it back to 0
        ;JMP  EndDequeue                ;End function 
EndEnqueue:
        RET        

Enqueue      ENDP

CODE	ENDS            



	END
