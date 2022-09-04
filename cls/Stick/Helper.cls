Class Stick.Helper [ Abstract ]
{

ClassMethod ArgumentCompare(ByRef input = "", ByRef expectation = "") As %Boolean
{
  if input '= expectation return 0
  if $data(input) < 2 return 0
  
  for i=1:1:input  if input(i) '= expectation(i) return 0
  
  return 1
}

ClassMethod CopyProperties(object As %RegisteredObject, stub As Stick.Stub)
{
     
  set properties = ""
  do ##class(%Studio.General).DumpObjectExecute(.properties, object)
  
  set key = ""
  for {
    set key = $order(properties(key))
    quit:key=""
    
    set name = key
    if name [ "[r%]" set name = $replace(key, "[r%]", "")
    
    set $property(stub, name)= properties(key)
  }
}

}

