;                 Name: Torkom Pailevanian
;
;                 Function: Queue
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
;	              SI - address of the queue (a)
;                     BL - element size (s)
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
;
;Pseudo Code
;       Set Headpointer at first element location
;       Set tailpointer at first element location
;       put value of element size (s) in Structure
;       put length of structure (l) in Structure
   
QueueInit             PROC        NEAR                 
                      PUBLIC      QueueInit
        
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

QueueEmpty	      
                      PROC        NEAR                 
                      PUBLIC      QueueEmpty
        
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
; Algorithms:         None.
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
;
;  Pseudo Code
;       If(head pointer == ((tail pointer + 1)AND ArraySize - 1 ))
;               set ZF
;       else
;               reset ZF

QueueFull            
                      PROC        NEAR                 
                      PUBLIC      QueueFull
        
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

Dequeue            
                      PROC        NEAR                 
                      PUBLIC      Dequeue
        
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

Enqueue            
                      PROC        NEAR                 
                      PUBLIC      Enqueue
        
Enqueue      ENDP

CODE	ENDS            



	END
