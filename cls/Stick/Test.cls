Class Stick.Test Extends %UnitTest.TestCase
{

Method Test()
{
  
  set spy = ##class(Stick.Spy).%New()
  set spy.a.b = 1
  
  set person = ##class(Sample.Person).%OpenId(1)
  set mock = ##class(Stick.Mock).Create()
  
  do mock.Expects("%Save").ToReceiveArguments(2).ToBeCalledOnce().AndReturn(20)
  do mock.Expects("%Save").ToReceiveArguments(1).ToBeCalledTwice().AndReturn(10)
  do mock.Expects("%Save").ToReceiveArguments(3).ToBeCalledTwice().AndReturn(30)
    
  
  set ret = mock.%Save(2)
  set ret = mock.%Save(1)  
  set ret = mock.%Save(3)
  set ret = mock.%Save(3)
  set ret = mock.%Save(1,2)
  
  set sc = mock.Verify()
  
  zw sc
}

Method Spy()
{
  set spy = ##class(Stick.Spy).%New()
  do spy.TestMethod(1,2,2)
  
  do $$$AssertStatusEquals(spy.GetMethodSpy("TestMethod"))
   
  set obj = ##class(Stick.Mock).Create()
  do obj.Expects("%Save").ToReceiveArguments(1,2,3).AndReturn("Got a 10")
  do obj.Expects("%Save").ToReceiveArguments(1,2,4).AndReturn("Got a 30")
  
  w obj.%Save(1,2,3)
  w obj.%Save(1,2,7)
  
  do $$$AssertStatusOK(obj.Verify(), "tratou o objeto de usuario como esperado")
  
  set obj = ##class(Stick.Stub).%New(##class(Sample.Person).%OpenId(1))
  
  do obj.When("%Save").CallWithArguments(1,2,3).ThenReturn(10).ThenReturn(20)
  
  w obj.%Save(1,2,3)
  w obj.%Save(1,2,3)
  w obj.%Save(1,2,4)
  w obj.%Save()
}

}

