clear all
cd "d:\mijn documenten\projecten\stata\mkfassert"
program mkdassert
	syntax, [dir(string) hidden bench(string)]

	if `"`dir'"' == "" {
		local dir = `"`c(pwd)'"'
	}
	mata: dir_chk(`"`dir'"', "`hidden'", "`bench'")
end

mata:
void dir_chk(string scalar dir, string scalar hidden, string scalar bench)
{
	string colvector dirs, files
	string scalar joined, part, cmd
	real scalar i

	if (!direxists(dir)) {
		errprintf("directory %s not found\n", dir)
		exit(170)
	}
	
	files = dir(dir, "files", "*")
	for(i=1; i<=rows(files); i++) {
		if (hidden == "" & strmatch(files[i], ".*")) continue
		joined = pathjoin(dir, files[i])
		printf(`"confirm file ""' +subinstr(joined, "\t", "\\t")+`""\n"')
		if (bench != "") {
			cmd = `"mkfassert using ""' + joined + `"", dir(""' + bench + `"")"'
		}
	}
	
	dirs = dir(dir, "dirs", "*")
	for(i=1; i<=rows(dirs); i++) {
		if (hidden == "" & strmatch(dirs[i], ".*")) continue
		joined = pathjoin(dir, dirs[i])
		part = `"direxists ""' + dirs[i] + `"", dir(""' + dir + `"")"'
		printf(part +"\n")
		dir_chk(joined, hidden)
	}
	

}
end

mkdassert