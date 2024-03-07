clear all
cd "d:\mijn documenten\projecten\stata\mkfassert"
program mkdassert
	syntax, [dir(string) hidden bench(string)]

	if `"`dir'"' == "" {
		local dir = `"`c(pwd)'"'
	}
	mata: dir_chk(`"`dir'"', "`hidden'", "`bench'", 1)
end

mata:
void dir_chk(string scalar dir, string scalar hidden, string scalar bench, real scalar depth)
{
	string colvector dirs, files
	string scalar joined, part, cmd, newdir
	real scalar i

	if (!direxists(dir)) {
		errprintf("directory %s not found\n", dir)
		exit(170)
	}
	newdir = copydir(dir, bench, depth)
	files = dir(dir, "files", "*")
	for(i=1; i<=rows(files); i++) {
		if (hidden == "" & strmatch(files[i], ".*")) continue
		joined = pathjoin(dir, files[i])
		printf(`"confirm file ""' +subinstr(joined, "\t", "\\t")+`""\n"')
		if (bench != "") {
			cmd = `"mkfassert using ""' + joined + `"", dir(""' + newdir + `"")"'
			stata(cmd)
		}
	}
	
	dirs = dir(dir, "dirs", "*")
	depth = depth + 1
	for(i=1; i<=rows(dirs); i++) {
		if (hidden == "" & strmatch(dirs[i], ".*")) continue
		joined = pathjoin(dir, dirs[i])
		part = `"direxists ""' + dirs[i] + `"", dir(""' + dir + `"")"'
		printf(part +"\n")
		dir_chk(joined, hidden, bench, depth)
	}
	

}

string scalar copydir(string scalar dir, string scalar bench, real scalar depth)
{
	string scalar rest, result
	
	rest = dir
	result = ""
	for (i=depth ; i >= 1; i--){
		result = pathjoin(pathbasename(rest), result)
		rest = pathgetparent(rest)
	}
	result = pathjoin(bench, result)
	if (!direxists(result) {
		mkdir(result)
	}
	return(result)
}
end

mkdassert, dir(bench)