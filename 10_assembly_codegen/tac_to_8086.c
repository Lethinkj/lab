/* compile: cc -o tac_to_8086 tac_to_8086.c
   run: ./tac_to_8086 < tac_input.txt > out.asm
*/
#include <stdio.h>
#include <string.h>
#include <stdlib.h>

int main(){
    char line[256];
    printf("; 8086-like assembly generated from TAC\n");
    printf("section .data\n");
    // First pass: collect variables
    fpos_t pos;
    FILE *in = stdin;
    fgetpos(in, &pos);
    char vars[1024][32]; int vcount=0;
    while(fgets(line,sizeof(line),in)){
        char a[64],b[64],op[8],c[64];
        if(sscanf(line,"%s = %s %s %s", a,b,op,c)>=2){
            // dest a
            int found=0;
            for(int i=0;i<vcount;i++) if(strcmp(vars[i],a)==0) found=1;
            if(!found) strcpy(vars[vcount++], a);
            // operands b,c if identifiers
            if(isalpha(b[0])){
                found=0; for(int i=0;i<vcount;i++) if(strcmp(vars[i],b)==0) found=1;
                if(!found) strcpy(vars[vcount++], b);
            }
            if(isalpha(c[0])){
                found=0; for(int i=0;i<vcount;i++) if(strcmp(vars[i],c)==0) found=1;
                if(!found) strcpy(vars[vcount++], c);
            }
        } else if(sscanf(line,"%s = %s", a,b)==2){
            int found=0; for(int i=0;i<vcount;i++) if(strcmp(vars[i],a)==0) found=1;
            if(!found) strcpy(vars[vcount++], a);
            if(isalpha(b[0])){
                found=0; for(int i=0;i<vcount;i++) if(strcmp(vars[i],b)==0) found=1;
                if(!found) strcpy(vars[vcount++], b);
            }
        }
    }
    for(int i=0;i<vcount;i++) printf("%s dw 0\n", vars[i]);
    // second pass: translate
    printf("section .text\nglobal _start\n_start:\n");
    rewind(in);
    while(fgets(line,sizeof(line),in)){
        char dest[64], lhs[64], op[8], rhs[64];
        if(sscanf(line,"%s = %s %s %s", dest, lhs, op, rhs)==4){
            // binary op: dest = lhs op rhs
            // load lhs -> ax, perform op with rhs, store to dest
            if(isdigit(lhs[0])) printf("    mov ax, %s\n", lhs);
            else printf("    mov ax, [%s]\n", lhs);
            if(isdigit(rhs[0])){
                if(strcmp(op,"+")==0) printf("    add ax, %s\n", rhs);
                else if(strcmp(op,"-")==0) printf("    sub ax, %s\n", rhs);
                else if(strcmp(op,"*")==0) {
                    printf("    mov bx, %s\n", rhs);
                    printf("    mul bx\n");
                } else if(strcmp(op,"/")==0){
                    printf("    mov bx, %s\n", rhs);
                    printf("    div bx\n");
                } else printf("    ; unknown op %s\n", op);
            } else {
                if(strcmp(op,"+")==0) printf("    add ax, [%s]\n", rhs);
                else if(strcmp(op,"-")==0) printf("    sub ax, [%s]\n", rhs);
                else if(strcmp(op,"*")==0) {
                    printf("    mov bx, [%s]\n    mul bx\n", rhs);
                } else if(strcmp(op,"/")==0){
                    printf("    mov bx, [%s]\n    div bx\n", rhs);
                } else printf("    ; unknown op %s\n", op);
            }
            printf("    mov [%s], ax\n", dest);
        } else if(sscanf(line,"%s = %s", dest, lhs)==2){
            // assignment dest = lhs
            if(isdigit(lhs[0])) printf("    mov ax, %s\n", lhs);
            else printf("    mov ax, [%s]\n", lhs);
            printf("    mov [%s], ax\n", dest);
        } else {
            printf("    ; cannot parse: %s", line);
        }
    }
    printf("    ; program end\n    mov ax, 0x4c00\n    int 0x21\n");
    return 0;
}
