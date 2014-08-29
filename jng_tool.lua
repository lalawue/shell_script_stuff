-- by sucha in suchaaa@gmail.com
--
-- generate JNG/JPNG file using in game.
-- require ImageMagick's convert, lua and bash
--
-- jng data format [JPG .. PNG .. JPG_LEN .. 'JNG'], PNG was 
-- convert to 8bit grayscale, JPG_LEN was 16bit
--

local cmd, file, jpg_quality = ...

local _FILE_MARKER = "JNG"

local function _banner()
	print "jng_tool [pack PNG jpg_quality | unpack JPG | check JPG]"
	os.exit()
end

if not cmd or not file then
	_banner()
end

--

local function _writeFile(name, buf)
	local f = io.open(name, "wb")
	if f then
		f:write(buf);
		f:close()
		return true
	end
	return false
end

local function _readFile(name)
	local f = io.open(name, "rb")
	if f then
		local buf = f:read("*a")
		f:close()
		return buf
	end
	return nil
end

local function _checkJNG(file)
	local jbuf = _readFile(file)
	local mark = jbuf:sub(jbuf:len() - 2)
	return mark == _FILE_MARKER, jbuf
end

local function _printFileType( file, is )
	if is then
		print(string.format("file %s was %s", file, _FILE_MARKER))
	else
		print(string.format("file %s was not %s", file, _FILE_MARKER))
	end
end

-- get param
jpg_quality = jpg_quality or 80

local fname = file:match("(%w+)%.+")
--print(name)

local jpg_name = fname .. ".jpg"
local alpha_name = fname .. "_alpha.png"

if cmd == "pack" then

	local cmdstr_convert_to_jpg_fmt = "convert %s -quality %d %s"
	local cmdstr_convert_to_alpha_png_fmt = "convert %s -channel A -separate %s"

	local function _runCmd(cmdstr, ...)
		assert(os.execute(string.format(cmdstr, ...)))
	end

	-- convert to jpg and alpha png
	_runCmd(cmdstr_convert_to_jpg_fmt, file, jpg_quality, jpg_name)
	_runCmd(cmdstr_convert_to_alpha_png_fmt, file, alpha_name)

	-- combine jpg and alpha png
	local jbuf = _readFile( jpg_name )
	local abuf = _readFile( alpha_name )

	-- rm jpg
	--_runCmd("rm -f %s %s", jpg_name, alpha_name)

	local jbuf_len = jbuf:len()

	local footer = string.char(
	bit32.extract(jbuf_len, 8, 8),
	bit32.band(jbuf_len, 0xff)) .. _FILE_MARKER

	_writeFile(fname .. "." .. string.lower(_FILE_MARKER), jbuf .. abuf .. footer)
elseif cmd == "unpack" then
	local isJNG, buf = _checkJNG(file)
	if not isJNG then
		_printFileType( file, false )
		return
	end
	local len = buf:len()
	local j1, j2 = buf:byte(len - 4, len - 3)
	local jlen = bit32.lshift(j1, 8) + j2
	local jbuf = buf:sub(1, jlen)
	local abuf = buf:sub(jlen + 1)
	_writeFile(jpg_name, jbuf)
	_writeFile(alpha_name, abuf:sub(1, abuf:len() - 5))
elseif cmd == "check" then
	_printFileType( file, _checkJNG(file) )
else
	_banner()
end
