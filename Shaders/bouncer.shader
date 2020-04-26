shader_type canvas_item;

uniform float time_factor = 1.5;
uniform bool playing = false;

void vertex(){
	if(playing){
		VERTEX.x += cos(TIME * time_factor + VERTEX.x + VERTEX.y) * 10.0;
		VERTEX.y += sin(TIME * time_factor + VERTEX.x) * 0.10;		
	}
}