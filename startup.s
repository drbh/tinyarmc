.section .vectors, "a", %progbits
.word _stack_top        /* Initial stack pointer */
.word Reset_Handler     /* Reset handler */

.section .text.Reset_Handler, "ax", %progbits
.global Reset_Handler
Reset_Handler:
    ldr r0, =_stack_top  /* Load address of stack pointer into r0 */
    mov sp, r0           /* Set stack pointer */
    bl main              /* Call main function */
    b .                  /* Infinite loop if main returns */
