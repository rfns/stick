#define MultiAsSerial(%subs, %out) set%out = ""  for i=1:1:%subs { set $list(%out, *+1) = """"_%subs(i)_"""" }
#define RealMethodName(%methodName) $select($extract(%methodName) = "_" : $extract(%methodName, 2, *), 1: %methodName)
#define SubstituteMethodName(%methodName) $select($extract(%methodName) = "%" : "_"_%methodName, 2: %methodName)