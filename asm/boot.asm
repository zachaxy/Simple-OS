org  0x7c00 ; 告诉编译器,加载到内存的 07c00h处

jmp  entry  ; 直接跳转(goto)到 entry 定义出,因此下面的一堆代码其实是没有什么作用的.
DB  0x90   ;jmp entry 对应的机器码，长度是3字节;那么接下来将ox7c03处赋值为 0x90
DB   "OSKERNEL" ;strcpy(memory + 0x7c00 + 3 + 1, “OSKERNEL”); 
DW   512; 将0x7c00+3+1+1 出赋值为512,占用两个字节
DB   1  ;接下来的都是赋值操作,DB是赋值一个字节,DW是赋值两个字节
DW   1  ;并且赋值完之后,索引自增到下一个内存字节出
DB   2
DW   224
DW   2880
DB   0xf0
DW   9
DW   18
DW   2
DD   0
DD   2880
DB   0,0,0x29
DD   0xFFFFFFFF
DB   "MYFIRSTOS  "
DB   "FAT12   "
RESB  18 ; 把接下来的18个字节初始化为0

entry:  ; 该方法先初始化寄存器,对其进行赋值
    mov  ax, 0  ; ax 是一个2byte长的寄存器
    mov  ss, ax ; 接下来把ss,ds,es 中的数据全部赋值为 ax 中的数据--0
    mov  ds, ax ;
    mov  es, ax ;
    mov  si, msg    ;msg是下面定义的一段内存,把msg内存处地址放在si中  char* si = msg

putloop:    ;循环功能,将si指代的字符串逐个打印到屏幕上
    mov  al, [si]   ;取 *si 指向的字符,放到al处;  ax两个字节,低字节al,高字节ah
    add  si, 1      ; *si ++
    cmp  al, 0      ; 判断al 是否等于0
    je   fin        ;jump if equal --> goto fin
    mov  ah, 0x0e   ;ah 赋值为 0x0e
    mov  bx, 15     ;bx 赋值为 15
    int  0x10       ;此处为函数调用,调用的是系统库函数,均放在一个数组里面,这里调用的是 0x10 编号的函数--打印
    jmp  putloop    ; 循环,继续执行 putloop

fin:
    HLT         ;htl 表述halt,让cpu进入休眠状态,此时如果点击下键盘或者鼠标,则cpu被唤醒
    jmp  fin    ;此时继续进入fin,让cpu进入休眠,死循环

msg:
    DB    0x0a,  0x0a
    db    "hello, world"
    db    0x0a
    db    0