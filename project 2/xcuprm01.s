; Autor reseni: Marek Čupr (xcuprm01)
; Pocet cyklu k serazeni puvodniho retezce: 3432
; Pocet cyklu razeni sestupne serazeneho retezce: 4236
; Pocet cyklu razeni vzestupne serazeneho retezce: 406
; Pocet cyklu razeni retezce s vasim loginem: 876
; Implementovany radici algoritmus: Bubble Sort
; ------------------------------------------------

; DATA SEGMENT
                .data
; login:          .asciiz "vitejte-v-inp-2023"    ; puvodni uvitaci retezec
; login:          .asciiz "vvttpnjiiee3220---"    ; sestupne serazeny retezec
; login:          .asciiz "---0223eeiijnpttvv"    ; vzestupne serazeny retezec
login:          .asciiz "xcuprm01"                ; SEM DOPLNTE VLASTNI LOGIN
                                                  ; A POUZE S TIMTO ODEVZDEJTE

params_sys5:    .space  8   ; misto pro ulozeni adresy pocatku
                            ; retezce pro vypis pomoci syscall 5
                            ; (viz nize - "funkce" print_string)

; CODE SEGMENT
                .text
main:
        ; BUBBLE SORT IMPLEMENTED IN C (OPTIMIZED VERSION)
        ;
        ; int i, j;
        ; for (i = 0; i < n - 1; i++) {  
        ;    bool swapped = false;
        ;    for (j = 0; j < n - i - 1; j++) {  
        ;       if (arr[j] > arr[j + 1]) {  
        ;          int temp = arr[j];  
        ;          arr[j] = arr[j + 1];  
        ;          arr[j + 1] = temp;  
        ;          swapped = true;
        ;       }  
        ;    }

        ;    if (swapped == false)
        ;       break
        ; } 

        daddi   r4, r0, login   ; Save the string start adress to r4

        ; Helping 'variables'
        daddi   r8, r0, 0       ; r8 ~  N (array length)        
        daddi   r9, r0, 0       ; r9 ~  i (for outer loop indexing)
        daddi   r11, r0, 0      ; r11 ~ swapped = false; | (0 - false, 1 - true)

        jal string_length       ; Get the array length 

        daddi   r4, r0, login   ; Save the string start adress to r4 | because we've altered the adress previously in string_length

        jal bubble_sort         ; Sort the array

        daddi   r4, r0, login   ; Save the string start adress to r4 | because we've altered the adress previously in bubble_sort

        jal print_string        ; Print the string

        syscall 0   ; halt


; GET THE ARRAY LENGTH
string_length:
        lbu r6, 0(r4) ; Get the first elemnt of the aray
        beqz r6, string_length_end ; End the loop as soon as we reach the end of the string | '\0'
        daddi r8, r8, 1 ; Increase the string length | N++
        daddi r4, r4, 1 ; Move to the next character in the string | login++
        j string_length ; Loop until we reach the end of the string | '\0'

string_length_end:
        jr      r31 ; return - r31 | return address


; SORT THE ARRAY
bubble_sort:
         lbu r5, 0(r4) ; Get the login[0]
         lbu r6, 1(r4) ; Get the login[1]

         beqz r6, string_end ; End the loop as soon as we reach the end of the string | '\0'

         sltu r7, r6, r5   ; Compare login[0] and login[1] | r7 = (r6 < r5 ? 1 : 0)
         beqz r7, no_swap  ; Don't swap the characters if login[0] <= login[1]

        ; Otherwise swap the characters
        sb r5, 1(r4)  ; Save login[0] ~ r5 to the adress of login[1] ~ 1(r4)
        sb r6, 0(r4)  ; Save login[1] ~ r6 to the adress of login[0] ~ 0(r4)
        daddi r11, r11, 1 ; Set swapped to be 'true' ~ swapped > 0

no_swap:
        daddi r4, r4, 1 ; Move to the next character in the string | login++
        j bubble_sort   ; Loop until we reach the end of the string | '\0'

string_end:
        beqz r11, sort_end      ; End the algorithm if we didn't swap any characters (array is sorted)
        daddi r9, r9, 1         ; r9 ~  i (for outer loop indexing) | i++

        ; RESET 'VARIABLES' TO DEFAULT
        daddi   r11, r0, 0      ; bool swapped = false;
        daddi   r4, r0, login   ; Save the string start adress to r4 | because we've altered the adress previously in bubble_sort
        sltu r10, r9, r8        ; Compare the index of the outer lopp and the length of the array | r10 = (i < N ? 1 : 0)
        bgez r10, bubble_sort   ; Loop until the index of the outer loop is equal to the length of the string | i == N

sort_end:
        jr      r31 ; return - r31 | return address


; PRINT THE STRING
print_string:   ; adresa retezce se ocekava v r4
                sw      r4, params_sys5(r0)
                daddi   r14, r0, params_sys5    ; adr pro syscall 5 musi do r14
                syscall 5   ; systemova procedura - vypis retezce na terminal
                jr      r31 ; return - r31 je urcen na return address
