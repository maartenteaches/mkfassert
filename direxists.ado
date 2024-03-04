*! version 1.0.0 MLB 03Mar2024
program define direxists
	syntax anything, [dir(string)]
	
	if `"`dir'"' == "" {
		local dir = c(pwd)
	}
	
	local base : dir "`dir'" dirs `anything'
	assert(`"`base'"' != "")
end
