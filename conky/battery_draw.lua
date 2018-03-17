PI = 3.14159265359
settings_table = {

    {
        name='battery_percent',
        arg='BAT1',
        max= 100,
        bg_colour=0xcacccb,
        bg_alpha=1,
        bg_crit = 0xe84c3d,
        fg_colour=0x00FF00,
        fg_alpha=0.8,
        fg_crit = 0xe84c3d,
        x=0, y=263,
        width = 90,
        height = 300,
        angle = PI/2,
        padding = 5,
        panes = 15,
    },
    {
        name='battery_percent',
        arg='BAT0',
        max= 100,
        bg_colour=0xcacccb,
        bg_alpha=1,
        bg_crit = 0xe84c3d,
        fg_colour=0xffffff,
        fg_crit = 0xe84c3d,
        fg_alpha=0.8,
        x=120, y=187,
        width = 90, height = 150,
        angle = PI/2,
        padding = 5,
        panes = 7,
    },
}

require 'cairo'

function rgb_to_r_g_b(colour,alpha)
	return ((colour / 0x10000) % 0x100) / 255., ((colour / 0x100) % 0x100) / 255., (colour % 0x100) / 255., alpha
end

function draw_rect(cr, pct, pt)
    local w,h=conky_window.width,conky_window.height
    local bgc, bga, fgc, fga, fgcr, bgcr = pt['bg_colour'], pt['bg_alpha'], pt['fg_colour'], pt['fg_alpha'], pt['fg_crit'], pt['bg_crit']
    local xc, yc, width, height, angle, padding, panes = pt['x'], pt['y'], pt['width'], pt['height'], pt['angle'], pt['padding'], pt['panes']
    cairo_translate(cr, w / 2.0, h / 2.0)
    cairo_rotate(cr, angle)
    cairo_translate(cr, - w / 2.0, - h / 2.0)
    cairo_set_source_rgba(cr,rgb_to_r_g_b(bgc,bga))
    local panel_y = (height-padding*(panes-1))/panes
    local panel_y_mid = yc - height/2 + panel_y/2

    for i=1, panes, 1
    do
        if(panel_y*panes*pct > panel_y * i)
        -- if a pane is full
        then
            cairo_rectangle(cr, xc, panel_y_mid, width, panel_y)
            cairo_fill(cr)
            panel_y_mid = panel_y_mid + padding + panel_y
        else
        --if a pane is not full
            if(i == 1 and pct < .20)
            then
                cairo_set_source_rgba(cr,rgb_to_r_g_b(bgcr,bga))
            end
            if(i==panes and pct > .90)
            then
                cairo_rectangle(cr, xc+width/4, panel_y_mid, width/2, panel_y/3)
                cairo_fill(cr)
                break
            else --does not work
                -- + padding + 1/2(smaller panel width)
                local partial_panel_y = panel_y*(panes*pct - (i-1))
                if(i==1)
                then
                    panel_y_mid = partial_panel_y / 2 - height/2 + yc + padding

                else
                    panel_y_mid = panel_y_mid - panel_y/2 + partial_panel_y/2 + padding/2
                end
                cairo_rectangle(cr, xc, panel_y_mid, width, partial_panel_y)
                cairo_fill(cr)
                break
            end
        end
    end
    --panel_y_mid = panel_y_mid + panel_y/2

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
        --pct = .5
        draw_rect(cr, pct, pt)
    end
        if conky_window==nil then return end
    	--local cs=cairo_xlib_surface_create(conky_window.display,conky_window.drawable,conky_window.visual, conky_window.width,conky_window.height)

    	--local cr=cairo_create(cs)
        local cr = {}
    	local updates=conky_parse('${updates}')
    	update_num=tonumber(updates)

    	if update_num>5 then
    		for i in pairs(settings_table) do
                local cs=cairo_xlib_surface_create(conky_window.display,conky_window.drawable,conky_window.visual, conky_window.width,conky_window.height)
                cr[i]=cairo_create(cs)
    			setup_rects(cr[i],settings_table[i])
    		end
    	end
end
