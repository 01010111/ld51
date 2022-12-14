package shaders;

import flixel.system.FlxAssets;

class Grain extends FlxShader {
	@:glFragmentSource('
		#pragma header
		/*
			Film Grain post-process shader v1.1
			Martins Upitis (martinsh) devlog-martinsh.blogspot.com
			2013
			--------------------------
			This work is licensed under a Creative Commons Attribution 3.0 Unported License.
			So you are free to share, modify and adapt it for your needs, and even use it for commercial use.
			I would also love to hear about a project you are using it.
			Have fun,
			Martins
			--------------------------
			Perlin noise shader by toneburst:
			http://machinesdontcare.wordpress.com/2009/06/25/3d-perlin-noise-sphere-vertex-shader-sourcecode/
		*/
		
		uniform float uTime;
		uniform float uAmount;
		
		varying vec2 vTexCoord;
		
		const float permTexUnit = 1.0/256.0;
		const float permTexUnitHalf = 0.5/256.0;
		
		float width = openfl_TextureSize.x;
		float height = openfl_TextureSize.y;
		
		bool colored = false;
		float coloramount = 0.6;
		float grainsize = 2.5;
		float lumamount = 1.0;
		
		vec4 rnm(in vec2 tc) {
			float noise =  sin(dot(tc + vec2(uTime,uTime),vec2(12.9898,78.233))) * 43758.5453;
		
			float noiseR =  fract(noise)*2.0-1.0;
			float noiseG =  fract(noise*1.2154)*2.0-1.0;
			float noiseB =  fract(noise*1.3453)*2.0-1.0;
			float noiseA =  fract(noise*1.3647)*2.0-1.0;
		
			return vec4(noiseR,noiseG,noiseB,noiseA);
		}
		
		float fade(in float t) {
			return t*t*t*(t*(t*6.0-15.0)+10.0);
		}
		
		float pnoise3D(in vec3 p) {
			vec3 pi = permTexUnit*floor(p)+permTexUnitHalf;
			vec3 pf = fract(p);	
		
			float perm00 = rnm(pi.xy).a ;
			vec3  grad000 = rnm(vec2(perm00, pi.z)).rgb * 4.0 - 1.0;
			float n000 = dot(grad000, pf);
			vec3  grad001 = rnm(vec2(perm00, pi.z + permTexUnit)).rgb * 4.0 - 1.0;
			float n001 = dot(grad001, pf - vec3(0.0, 0.0, 1.0));
		
			float perm01 = rnm(pi.xy + vec2(0.0, permTexUnit)).a ;
			vec3  grad010 = rnm(vec2(perm01, pi.z)).rgb * 4.0 - 1.0;
			float n010 = dot(grad010, pf - vec3(0.0, 1.0, 0.0));
			vec3  grad011 = rnm(vec2(perm01, pi.z + permTexUnit)).rgb * 4.0 - 1.0;
			float n011 = dot(grad011, pf - vec3(0.0, 1.0, 1.0));
		
			float perm10 = rnm(pi.xy + vec2(permTexUnit, 0.0)).a ;
			vec3  grad100 = rnm(vec2(perm10, pi.z)).rgb * 4.0 - 1.0;
			float n100 = dot(grad100, pf - vec3(1.0, 0.0, 0.0));
			vec3  grad101 = rnm(vec2(perm10, pi.z + permTexUnit)).rgb * 4.0 - 1.0;
			float n101 = dot(grad101, pf - vec3(1.0, 0.0, 1.0));
		
			float perm11 = rnm(pi.xy + vec2(permTexUnit, permTexUnit)).a ;
			vec3  grad110 = rnm(vec2(perm11, pi.z)).rgb * 4.0 - 1.0;
			float n110 = dot(grad110, pf - vec3(1.0, 1.0, 0.0));
			vec3  grad111 = rnm(vec2(perm11, pi.z + permTexUnit)).rgb * 4.0 - 1.0;
			float n111 = dot(grad111, pf - vec3(1.0, 1.0, 1.0));
		
			vec4 n_x = mix(vec4(n000, n001, n010, n011), vec4(n100, n101, n110, n111), fade(pf.x));
			vec2 n_xy = mix(n_x.xy, n_x.zw, fade(pf.y));
			float n_xyz = mix(n_xy.x, n_xy.y, fade(pf.z));
		
			return n_xyz;
		}
		
		vec2 coordRot(in vec2 tc, in float angle) {
			float aspect = width/height;
			float rotX = ((tc.x*2.0-1.0)*aspect*cos(angle)) - ((tc.y*2.0-1.0)*sin(angle));
			float rotY = ((tc.y*2.0-1.0)*cos(angle)) + ((tc.x*2.0-1.0)*aspect*sin(angle));
			rotX = ((rotX/aspect)*0.5+0.5);
			rotY = rotY*0.5+0.5;
			return vec2(rotX,rotY);
		}
		
		void main() {
			vec2 texCoord = openfl_TextureCoordv.st;
		
			vec3 rotOffset = vec3(1.425,3.892,5.835);
			vec2 rotCoordsR = coordRot(texCoord, uTime + rotOffset.x);
			vec3 noise = vec3(pnoise3D(vec3(rotCoordsR*vec2(width/grainsize,height/grainsize),0.0)));
		
			if (colored) {
				vec2 rotCoordsG = coordRot(texCoord, uTime + rotOffset.y);
				vec2 rotCoordsB = coordRot(texCoord, uTime + rotOffset.z);
				noise.g = mix(noise.r,pnoise3D(vec3(rotCoordsG*vec2(width/grainsize,height/grainsize),1.0)),coloramount);
				noise.b = mix(noise.r,pnoise3D(vec3(rotCoordsB*vec2(width/grainsize,height/grainsize),2.0)),coloramount);
			}
		
			vec3 col = texture2D(bitmap, texCoord).rgb;
		
			vec3 lumcoeff = vec3(0.299,0.587,0.114);
			float luminance = mix(0.0,dot(col, lumcoeff),lumamount);
			float lum = smoothstep(0.2,0.0,luminance);
			lum += luminance;
		
			noise = mix(noise,vec3(0.0),pow(lum,4.0));
			col = col+noise*uAmount;
		
			gl_FragColor =  vec4(col,1.0);
		}	
	')

	var amount(default, set):Float;
	function set_amount(v:Float) {
		uAmount.value = [v];
		return amount = v;
	}

	var time(default, set):Float = 0;
	function set_time(v:Float) {
		uTime.value = [v];
		return time = v;
	}

	public function new(amt:Float = 0.015) {
		super();
		amount = amt;
	}

	public function update(?dt:Dynamic) {
		time = (time + dt) % 60;
	}
	
}