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
  if '$isobject(object) return  
  
  set properties = ""
  do ##class(%Studio.General).DumpObjectExecute(.properties, object)
  
  set key = ""
  for {
    set key = $order(properties(key))
    quit:key=""
    
    set useXecute = 0
    
    set name = key
    if name [ "[r%]" set name = $replace(key, "[r%]", "")
    if name [ "(" set useXecute = 1
   
    set value = properties(key)
    set isObject = $data(properties(name_"[r%]"))
    if value = "<UNDEFINED>" set value = ""
    if isObject && (value = "") continue
    
    try {
      if 'useXecute {
        set $property(stub, name) = value
      } else {
        xecute ($$$FormatText("(thisObject) set thisObject.%1 = ""%2""", name, value), stub)
      }
    } catch ex {
      set errorText = $System.OBJ.GetErrorText(ex.AsStatus())
      $$$ThrowStatus($$$ERROR($$$GeneralError, "Failed to copy property %1. Reason: %2", name, errorText))
    }      
  }
}

ClassMethod SerializeArguments(ByRef args = "") As %String
{
  set key = ""
  set argsList = ""
  
  for  set key=$order(args(key))  quit:key=""  set $list(argsList, *+1) = args(key)
  return $lts(argsList)
}

ClassMethod RunMethodWithThisRebinded(receiver As %RegisteredObject, originalClass As %RegisteredObject, methodName As %String, args... As %String)
{
 
  set method = ##class(%Dictionary.CompiledMethod).%OpenId(originalClass_"||"_methodName)
  
  do GetArgsFromParsedFormalSpec(.methodSignature, .patchedArgs)
  
  if $data(^||Stick.CodePatches(originalClass, methodName)) {
    return $$DoXecute(.patchedArgs)
  }  
  
  set routineName = ##class(%RoutineMgr).GetOther(originalClass, "CLS")
  set implementation = ##class(%RoutineMgr).%New(routineName).Code
  
  set regex = ##class(%Regex.Matcher).%New("^\%?\w+(:?\([\w=,""]+\))?\spublic\s\{\s(.*?)\s\}$")  
  
  
  if '$data(args) set args = 0
  
  set str = ""
  set labelFound = 0
  set name = $select($extract(methodName) = "%" : methodName, 1: "z"_methodName)
  set returnValue = ""             
  
  while 'implementation.AtEnd {
    set line = $translate(implementation.ReadLine(), $c(9), " ")
    if (labelFound = 1) && (line [ "public {") {
      quit
    }    
    if ($extract(line, 1, $length(name)) = name) {
      set labelFound = 1
    }
    if labelFound = 1 {
      set str = str_line      
    }
  }
    
  if str [ "public" {
    set regex.Text = str
    set str = regex.ReplaceAll("$2")
  }
  
  if str = "" set str = "return """""
  
  set str = $replace(str, "..", "thisObject.")
  set str = $replace(str, "i%", "thisObject.")
  set str = $replace(str, "$this", "thisObject.")
  
  set ^||Stick.CodePatches(originalClass, methodName) = methodSignature_" "_str
  
  return $$DoXecute(.patchedArgs)
  
GetArgsFromParsedFormalSpec(xecuteArgs="",argsList=0)
  set thisObjectSignature = ",thisObject)"
  set expectedArgsCount = $ll(method.FormalSpecParsed)
  for i=1:1:expectedArgsCount {
    set parsedArgSpec = $listget(method.FormalSpecParsed, i)
    set defaultValue = $listget(parsedArgSpec, 4)
    set $list(xecuteArgs, *+1) = $listget(parsedArgSpec, 1)    
    set argsList(i) = $get(args(i), defaultValue)
  }
  
  set argsList = expectedArgsCount + 1
  set argsList(argsList) = receiver
  
  if xecuteArgs = "" set thisObjectSignature = "thisObject)"
  set xecuteArgs = "("_$lts(xecuteArgs)_thisObjectSignature
  quit
  
DoXecute( argsList)
  set returnValue = ""
  try {
    set returnValue = $xecute(^||Stick.CodePatches(originalClass, methodName), argsList...)
  } catch ex {
    if ex.Name '= "<COMMAND>" throw ex
  }
  
  return returnValue
}

}

