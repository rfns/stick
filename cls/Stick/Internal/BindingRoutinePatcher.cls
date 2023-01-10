Include stick

Class Stick.Internal.BindingRoutinePatcher Extends %RegisteredObject
{

Property Generator As Stick.Internal.BindingRoutineGenerator [ Private ];

Method %OnNew(generator As Stick.Internal.BindingRoutineGenerator) As %Status
{
  set ..Generator = generator
  return $$$OK
}

Method Apply(routine As %Routine, methodName As %String) As Stick.Internal.RoutineExecutionContext
{
  set includes = ..PatchIncludes()
  set signature = ..PatchArguments(methodName)
  
  do ..PatchImplementation(routine, methodName, signature, includes)
  
  return ##class(Stick.Internal.RoutineExecutionContext).%New(
    routine, 
    methodName, 
    signature, 
    ..Generator.GetMethodImplementationObject(methodName).GetDefaultArgumentValues()
  )
}

Method PatchImplementation(routine As %Routine, methodName As %String, signature As %String, includes As %String) [ Private ]
{
  
  set implementationObject = ..Generator.GetMethodImplementationObject(methodName)
  set implementation = implementationObject.GetContent()
  
  set regex = ##class(%Regex.Matcher).%New("(?:k|K|Kill|kill|KILL)?(\s?+(?:i%|\.\.)([\w\d]+))(,?)")
  
  if routine.Size > 0 {
    do routine.MoveToEnd()
    do routine.WriteLine("")
  } elseif includes '= "" {
    do routine.Write(includes)
    do routine.WriteLine("")   
  }
    
  do routine.WriteLine(methodName_signature)       
  
  while 'implementation.AtEnd {
    set line = implementation.ReadLine()
    set line = $replace(line, "..", "thisObject.")
    set line = $replace(line, "$this", "thisObject")
    set line = $replace(line, "%this", "thisObject")    
    
    set regex.Text = $zstrip(line, "<>W")
    
    if ($$$lcase(regex.Text) [ "kill ") || ($$$lcase(regex.Text) [ "k ") {
      set line = "  do "_regex.ReplaceAll("thisObject.""_KillMultiDimensional""(""$2"")$3")
    }
        
    set line = $replace(line, "i%", "thisObject.")
        
    do routine.WriteLine(line)
  }
  
  do routine.WriteLine("")
  do routine.WriteLine("  quit """"")
  do routine.WriteLine("")
}

Method PatchArguments(methodName As %String) As %String [ Private ]
{
  set args = ""       
  set methodImplementationObject = ..Generator.GetMethodImplementationObject(methodName)
  set thisObjectSignature = ",thisObject)"
  
  set arguments = methodImplementationObject.GetArgumentList()
  
  set expectedArgsCount = $ll(arguments)
  for i=1:1:expectedArgsCount {
    set parsedArgSpec = $listget(arguments, i)
    set $list(args, *+1) = $listget(parsedArgSpec, 1)
  }
  
  if args = "" set thisObjectSignature = "thisObject)"
  set args = "("_$lts(args)_thisObjectSignature
  
  return args
}

Method PatchIncludes() As %String
{
  set includeList = ""
  #dim targetClass As %Dictionary.CompiledClass = ..Generator.GetTargetClass()
  
  set includeName = ""   
  
  while 1 {
    set includeName = targetClass.IncludeCodeAll.Next(.includeName)
    quit:includeName=""
    set $list(includeList, *+1) = "#include "_includeName
  }
  
  set includeName = ""
  
  while 1 {
    set includeName = targetClass.IncludeMGenAll.Next(.includeName)
    quit:includeName=""
    
    if '$listfind(includeList, includeName) {
      set $list(includeList, *+1) = "#include "_includeName
    }
  }  
  
  if $listlength(includeList) = 0 return ""
  
  return $listtostring(includeList, $$$NEWLINE)_$$$NEWLINE
}

}

