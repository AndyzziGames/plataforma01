//checando se ainda estou no ar e acabei de tocar no chão

var temp = place_meeting(x,y+1,obj_plat);

if (temp && !chao)
{
	xscale = 1.6;
	yscale = .5;
	
	//criando poeira de rastro ao tocar no chão
	
	for (var i=0;i<random_range(4,10);i++)
	{
		var xx = random_range(x-sprite_width,x+sprite_width);
		
		instance_create_depth(xx,y,depth-1000,obj_rastro);
	}
}