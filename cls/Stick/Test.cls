Class Stick.Test Extends %UnitTest.TestCase
{

ClassMethod Test2()
{
	set mock = ##class(Stick.Mock).Create()
	do mock.Expects("%Save").ToBeCalledOnce().ToUseArguments(1,2,3).ToReturn(1)
	do mock.Expects("%Saved").ToBeCalledOnce()
	
	do mock.%Save(1,2,3)
	do mock.%Saved()
	
	set sc = mock.Verify()
	zw sc
	//do $$$AssertStatusOK(mock.Verify(), "should have a working mock")
}

}

