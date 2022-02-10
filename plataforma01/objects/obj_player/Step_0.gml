/// @description Insert description here
// You can write your code in this editor

//colisão
chao = place_meeting(x,y+1,obj_plat);
parede_dir = place_meeting(x+1,y,obj_plat);
parede_esq = place_meeting(x-1,y,obj_plat);

if (chao)
{
	limite_pulo = timer_pulo;
	carga = 1;
}
else
{
	if (limite_pulo > 0)limite_pulo--;
}

//timer do wall jump
if (parede_dir or parede_esq)
{
	if (parede_dir)ultima_parede = 0;else
	ultima_parede = 1;
	
	timer_parede = limite_parede;
}
else
{
	if (timer_parede > 0)timer_parede--;
}

var right,left,up,down,jump,jump_s,avanco_h,dash;

right = keyboard_check(ord("D"));
left = keyboard_check(ord("A"));
up = keyboard_check(ord("W"));
down = keyboard_check(ord("S"));
jump = keyboard_check_pressed(ord("K"));
jump_s = keyboard_check_released(ord("K"));
dash = keyboard_check_pressed(ord("L"));

avanco_h = (right - left) * max_velh;

if (chao)acel = acel_chao;else
acel = acel_ar;

switch(estado)
{
	case state.parado:
		
		//parado
		velh = 0;
		velv = 0;
		
		//posso mudar minha velocidade
		//pulando
		if (chao && jump)
		{
			velv = -max_velv;
			
			//esticando quando esta pulando
			xscale = .5;
			yscale = 1.5;
			
			for (var i=0;i<random_range(4,10);i++)
			{
				var xx = random_range(x-sprite_width,x+sprite_width);
		
				instance_create_depth(xx,y,depth-1000,obj_rastro);
			}
		}
		
		//gravidade
		if (!chao)velv += grav;
		
		//saindo do estado parado
		if (abs(velh > 0) or abs(velv > 0) or right or left or jump)
		{
			estado = state.movendo;
		}
		
		//entrando no estado de dash
		if (dash && carga > 0)
		{
			dir = point_direction(0,0,(right - left),(down - up));
			
			estado = state.dash;
			carga--;
		}
		
		break;
		
	case state.movendo:
		
		//andando
		velh = lerp(velh,avanco_h,acel);
		
		//criando poeira quando estiver andando
		var chance = random(100);
		if (chance > 80)
		{
			if (abs(velh) > max_velh -.5 && chao)
			{
				for (var i=0;i<random_range(4,6);i++)
				{
					var xx = random_range(x-sprite_width/2,x+sprite_width/2);
		
					instance_create_depth(xx,y,depth-1000,obj_rastro);
				}
			}
		}
		
		//pulando
		if (jump && (chao or limite_pulo))
		{
			velv = -max_velv;
			
			//esticando quando esta pulando
			xscale = .5;
			yscale = 1.5;
			
			for (var i=0;i<random_range(4,10);i++)
			{
				var xx = random_range(x-sprite_width,x+sprite_width);
		
				instance_create_depth(xx,y,depth-1000,obj_rastro);
			}
		}
		
		if (jump)timer_queda = limite_buffer;
		
		if (timer_queda > 0)buffer_pulo = true;
		else buffer_pulo = false;
		
		if (buffer_pulo)
		{
			if (chao or limite_pulo)//posso pular!
			{
				velv = -max_velv;
				
				//esticando quando esta pulando
				xscale = .5;
				yscale = 1.5;
				
				timer_pulo = 0;
				timer_queda = 0;
				
			}
			
			timer_queda--;
		}
		
		//controle da velcidade do pulo
		if (jump_s && velv < 0)velv*= .7;
		
		//gravidade & wall jump
		if (!chao && (parede_dir or parede_esq or timer_parede))
		{
			//não estou no chão e tocando na parede
			if (velv > 0)//esta na parede e caindo
			{
				velv = lerp(velv,deslize,acel);
				
				//criando poeira deslizando na parede
				var chance = random(100);
				if (chance > 90)
				{
					for (var i=0;i<random_range(4,6);i++)
					{
						var onde = parede_dir - parede_esq;
						var xx = x + onde * sprite_width/2;
						var yy = y + random_range(-sprite_height/4,0);
		
						instance_create_depth(xx,yy,depth-1000,obj_rastro);
					}
				}
			}
			else
			{
				//estou subindo
				velv += grav; 
			}
			
			//wall jump
			if (!ultima_parede && jump)
			{
				velv = -max_velv;
				velh = -max_velh;
				xscale = .5;
				yscale = 1.5;
				
				for (var i=0;i<random_range(4,6);i++)
				{
					var xx = x + sprite_width/2;
					var yy = y + random_range(-sprite_height/4,0);
		
					instance_create_depth(xx,yy,depth-1000,obj_rastro);
				}
			}
			else
			if (ultima_parede && jump)
			{
				velv = -max_velv;
				velh = max_velh;
				xscale = .5;
				yscale = 1.5;
				
				for (var i=0;i<random_range(4,6);i++)
				{
					var xx = x - sprite_width/2;
					var yy = y + random_range(-sprite_height/4,0);
		
					instance_create_depth(xx,yy,depth-1000,obj_rastro);
				}
			}
		}
		else
		if (!chao)
		{
			velv += grav;
		}
		
		//entrando no estado de dash
		if (dash && carga > 0)
		{
			dir = point_direction(0,0,(right - left),(down - up));
			
			estado = state.dash;
			carga--;
		}
		
		//limitando a gravidade/velocidade vertical
		velv = clamp(velv,-max_velv,max_velv);
		
		break;
		
	case state.dash:
		
		//dando o dash
		dura--;
		
		velh = lengthdir_x(len,dir);
		velv = lengthdir_y(len,dir);
		
		if (dir == 90 or dir == 270)
		{
			xscale = .5;
			yscale = 1.5;
		}
		else
		{
			xscale = 1.6;
			yscale = .5;
		}
		
		var rastro = instance_create_layer(x,y,layer,obj_player_vest);
		rastro.xscale = xscale;
		rastro.yscale = yscale;
	
		//saindo do estado de dash
		
		if (dura <= 0)
		{
			estado = state.movendo;
			dura = room_speed/4;
			
			velh = (max_velh * sign(velh) * .5);
			velv = (max_velv * sign(velv) * .5);
		}
		
	
		break;
}

show_debug_message(estado);

switch(carga)
{
	case 0:
		sat = lerp(sat,50,.05);
		break;
	case 1:
		sat = lerp(sat,255,.05);
		break;
}

image_blend = make_color_hsv(20,sat,255);

//volta para a escala normal
xscale = lerp(xscale,1,.15);
yscale = lerp(yscale,1,.15);
