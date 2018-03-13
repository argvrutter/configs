--[[void
cairo_rectangle (cairo_t *cr,
                 double x,
                 double y,
                 double width,
                 double height);]]
 --cairo_rotate(cr, M_PI/2);
settings_table = {

    {
        name='battery',
        arg='BAT0',
        max= 100,
        bg_colour=0xffffff,
        bg_alpha=0.2,
        fg_colour=0xe84c3d,
        fg_alpha=0.8,
        x=70, y=360,
        width = 100, height = 100
    },
    {
        name='battery',
        arg='BAT1',
        max= 100,
        bg_colour=0xffffff,
        bg_alpha=0.2,
        fg_colour=0xe84c3d,
        fg_alpha=0.8,
        x=70, y=360,
        width = 100, height = 100
    },
}

require 'cairo'

function rgb_to_r_g_b(colour,alpha)
	return ((colour / 0x10000) % 0x100) / 255., ((colour / 0x100) % 0x100) / 255., (colour % 0x100) / 255., alpha
end

function draw_rect(cr, pct, pt)
    local w,h=conky_window.width,conky_window.height
    local bgc, bga, fgc, fga = pt['bg_colour'], pt['bg_alpha'], pt['fg_colour'], pt['fg_alpha']
    local xc, yc, w, h = pt['x'], pt['y'], pt['width'], pt['height']

    cairo_rectangle(cr, xc, yc, w, h)
end

function conky_batt_stats()
    local function setup_rects(cr,pt)
		local str=''
		local value=0

		str=string.format('${%s %s}',pt['name'],pt['arg'])
		str=conky_parse(str)

		value=tonumber(str)
		if value == nil then value = 0 end
        -- percent usage
        pct=value/pt['max']

        draw_rect(cr, pct, pt)
    end
        if conky_window==nil then return end
    	local cs=cairo_xlib_surface_create(conky_window.display,conky_window.drawable,conky_window.visual, conky_window.width,conky_window.height)

    	local cr=cairo_create(cs)

    	local updates=conky_parse('${updates}')
    	update_num=tonumber(updates)

    	if update_num>5 then
    		for i in pairs(settings_table) do
    			setup_rects(cr,settings_table[i])
    		end
    	end
end
