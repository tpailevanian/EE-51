; Converts.inc
; Include file for converts functions

; This file contains the values for the ASCII characters used in converts
;
; Revision History:
;     10/25/14  Torkom Pailevanian      initial revision

; ASCII Characters

;STRUC CONSTANTS
emptyQueueOffset	EQU     0			;The value of the head and tail pointer when there is no data in the queue
emptyBuffer         EQU     2           ;There is a two byte empty space between tail ptr and head ptr when full

;Size Byte Types
BYTE_TYPE			EQU		0			;Size byte value if elements are bytes
WORD_TYPE			EQU		1 			;Size byte value if elements are words

;Stuc size
QUEUE_SIZE			EQU		256			;Stores the number of elements that can be stored in the queue
MAX_QUEUE_SIZE		EQU		1024		;the maximum space to allocate for the queue

;Struc definition
QUEUESTRUC      STRUC           ;structure containing the queue
    headPtr     DB      ?       ;stores the head pointer for the queue
    tailPtr     DB      ?       ;stores the tail pointer for the queue
    elemSize    DB      ?       ;stores the size of each element, i.e. byte or word
    queueData   DB      MAX_QUEUE_SIZE	DUP(?)	;allocates space for the queue 
QueueStruc      ENDS

