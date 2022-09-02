Class Stick.Helper [ Abstract ]
{

ClassMethod ArgumentCompare(ByRef input = "", ByRef expectation = "") As %Boolean
{
	if input '= expectation return 0
	if $data(input) < 2 return 0
	
	for i=1:1:input  if input(i) '= expectation(i) return 0
	
	return 1
}

}

