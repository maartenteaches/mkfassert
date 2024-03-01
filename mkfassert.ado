*! version 1.0.0 MLB 03Mar2024
program define mkfassert
	syntax using/, [replace erase dir(string)]
	
	mata:parseusing(`"`using'"', `"`dir'"')
	
	copy `"`using'"' `"`tfn'"', `replace'
	di as txt `"files_equal, file1(`"`using'"'  ) ///"'
	di as txt `"             file2(`"`tfn'"')"'
	if "`erase'" != "" {
		di as txt `"erase "`using'""'
	}
end

mata:
void parseusing(string scalar path, string scalar dir)
{
	string scalar parent, fn
	
    if (!fileexists(path)) {
        errprintf("file %s not found\n", path)
        exit(601)
    }

	parent = pathgetparent(path)
	fn = pathbasename(path)
	if (dir == "") {
		dir = parent
	}
	else {
		if (!direxists(dir)) {
			errprintf("directory %s not found\n", dir)
			exit(170)
		}
	}
	st_local("tfn", pathjoin(dir, "T_"+fn))
}
end
