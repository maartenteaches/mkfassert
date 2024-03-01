cd "D:\Mijn documenten\projecten\stata\mkfassert"
cscript

mkfassert using bench\test_text.do, replace


files_equal, file1(`"bench\test_text.do"'  ) ///
             file2(`"bench\T_test_text.do"')

rcof `"mkfassert using bench\test_text.do, replace dir("foo")"' == 170

mkfassert using bench\test_text.do, replace dir(bench\test)