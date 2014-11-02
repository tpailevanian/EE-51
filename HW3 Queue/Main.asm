


NAME MAIN

$INCLUDE (queue.inc)

DGROUP  GROUP   DATA, STACK
CGROUP  GROUP   CODE   

CODE	SEGMENT PUBLIC 'CODE'           

	ASSUME  CS:CGROUP, DS:DGROUP
	


;external function declarations

        EXTRN   QueueTest:NEAR         ;Test file for the queue
		EXTRN 	QueueInit:NEAR		   ;Initializes the pointers in the queue
        EXTRN   QueueEmpty:NEAR        ;Checks if queue is Empty
        EXTRN   QueueFull:NEAR         ;Checks if queue is Full
        EXTRN   Dequeue:NEAR           ;Takes one element from the queue
        EXTRN   Enqueue:NEAR           ;Puts one element in the queue


START:                                  ;start the program

        MOV     AX, DGROUP              ;initialize the stack pointer
        MOV     SS, AX
        MOV     SP, OFFSET(DGROUP:TopOfStack)

        MOV     AX, DGROUP              ;initialize the data segment
        MOV     DS, AX
		
		;initialize queue
		LEA		SI, queue
		MOV     CX, 254
        CALl    QueueTest

;        MOV     BL, 0
;        CALL    QueueInit
        
;        MOV AX, 0
;        MOV CX, 0
;EnqueueLoop:
;        CALL Enqueue
;        INC  AX
;        INC  CX
;        CMP  CX, 253
;        JBE   EnqueueLoop
        
;Enqueue253:
;        CALL Enqueue
        
checkRegisters:
		JMP     START
		
CODE    ENDS

DATA    SEGMENT PUBLIC  'DATA'

queue			QUEUESTRUC <>		;queue structure initialization

DATA    ENDS

STACK   SEGMENT STACK  'STACK'

                DB      80 DUP ('Stack ')       ;240 words

TopOfStack      LABEL   WORD

STACK   ENDS

END  START   