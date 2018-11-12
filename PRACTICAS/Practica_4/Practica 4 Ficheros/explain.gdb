# Practica 4.

#ejecutar con : gdb -q -x explain.gdb

#compilar la bomba con :
# gcc -Og bomba.c -o bomba -no-pie -fno-guess-branch-probability

# este script desactivara una vez la bomba, y posteriormente cambiara
#la contraseña y el pin por defecto



# CONTRASEÑA: 0x63f12
# PIN       : 3012

# MODIFICADA: ejemplo
# PIN       : 1234



file bomba



br main

run < <(echo -e ejemplo\\n1234\\n)

# Primer strncmp

br *0x4013e8  

cont


# mostramos la contraseña: 0x63f12
p (char *) 0x404070 


#saltamos primer obstaculo, que coincida la contraseña
set $eax=0   



# br en la comprobacion del tiempo
br *0x40142a 
cont


# saltamos la comprobacion
set $rax=0 


# br en la comprobacion del PIN
br *0x401488
cont


# mostramos el pin correcto
p (int) $eax  


# cambiamos a nuestro PIN
set $eax=1234 



# segunda comprobacion de tiempo
br *0x4014b1
cont

set $rax=0


# llegamos a defused
c






#activamos la escritura en el binario
set write on

#cargamos bomba
file bomba


# cambiamos la contraseña
set {char[9]}0x404070="ejemplo\n" 

# cambiamos el PIN
set {int}0x404068=1234    

#comprobacion de los cambiamos

p (char[9]) stdio
p (int)     ecx


quit

#ahora, si ejecutamos hacemos
#./bomba
# y ponemos como clave: ejemplo
# y como pin: 1234
#la bomba se desactivara