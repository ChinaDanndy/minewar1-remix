shader_type canvas_item;
uniform float u_size = 0.1;
uniform vec4 glowColor : source_color;

vec4 replaceOrBlend(vec4 offsettedColor, vec4 origColor)
{
    if(origColor.a > 0.0)
        return origColor;
    else
        return offsettedColor;
}

vec4 replaceIfAlpha(vec4 orig, vec4 replacer)
{
    if(replacer.a == 0.0)
        return vec4(0.0,0.0,0.0,0.0);
    else
        return vec4(replacer.rgb, orig.a);
}

vec4 textureIfInRange(sampler2D tex, vec2 pos)
{
    if(pos.x >= 0.0 && pos.y >= 0.0 && pos.x <= 1.0 && pos.y <= 1.0)
        return texture(tex,pos);
    return vec4(0.0,0.0,0.0,0.0);
}

void fragment() 
{
    float size = u_size / 100.0;
    vec4 finalColor;
    vec4 offsettedColor;
    vec4 origHere = textureIfInRange(TEXTURE, UV);
    vec4 tColor;
    
    
    offsettedColor = replaceIfAlpha(textureIfInRange(TEXTURE, UV + vec2(-size,-size)), glowColor);
    finalColor = replaceOrBlend(offsettedColor, origHere);
    origHere = finalColor;

    offsettedColor = replaceIfAlpha(textureIfInRange(TEXTURE, UV + vec2(-size,size)), glowColor);
    finalColor = replaceOrBlend(offsettedColor, origHere);
    origHere = finalColor;

    offsettedColor = replaceIfAlpha(textureIfInRange(TEXTURE, UV + vec2(size,-size)), glowColor);
    finalColor = replaceOrBlend(offsettedColor, origHere);
    origHere = finalColor;

    offsettedColor = replaceIfAlpha(textureIfInRange(TEXTURE, UV + vec2(size,size)), glowColor);
    finalColor = replaceOrBlend(offsettedColor, origHere);
    
    COLOR = finalColor;
}