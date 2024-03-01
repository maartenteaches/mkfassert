*! version 1.0.0 MLB 03Mar2024
program define files_equal
	syntax, file1(string) file2(string)
	
	tempname totest true
	file open `totest' using `file1', read
	file open `true'   using `file2', read
	
	file read `totest' line
	local testeof = r(eof)
	file read `true'   tline
	assert r(eof)==`testeof'
	while r(eof) == 0 {
		assert `"`macval(line)'"' == `"`macval(tline)'"'
		file read `totest' line
		local testeof = r(eof)
		file read `true'   tline
		assert r(eof)==`testeof'
	}
end
