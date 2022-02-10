grav = .3;
acel_chao = .1;
acel_ar = .07;
acel = acel_chao;
deslize = 2;
ultima_parede = 0;

//velocidades
velh = 0;
velv = 0;
//limite da velocidade
max_velh = 6;
max_velv = 8;
//velocidade do dash
len = 10;

//variáveis de controle
//limite de quando o player pode pular
limite_pulo = 6;
timer_pulo = 0;
//limite de quando o player pode pular outra vez 
limite_buffer = 6;
timer_queda = 0;
buffer_pulo = false;

limite_parede = 6;
timer_parede = 0;

//tempo do dash
dura = room_speed/4;
//direção do dash
dir = 0;
carga = 1;
//saturação da cor
sat = 255;


//colisão
chao = false;

xscale = 1;
yscale = 1;

//máquina de estado

enum state
{
	parado, movendo, dash
}

estado = state.parado;