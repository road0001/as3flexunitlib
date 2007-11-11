/*
	Adobe Systems Incorporated(r) Source Code License Agreement
	Copyright(c) 2005 Adobe Systems Incorporated. All rights reserved.
	
	Please read this Source Code License Agreement carefully before using
	the source code.
	
	Adobe Systems Incorporated grants to you a perpetual, worldwide, non-exclusive, 
	no-charge, royalty-free, irrevocable copyright license, to reproduce,
	prepare derivative works of, publicly display, publicly perform, and
	distribute this source code and such derivative works in source or 
	object code form without any attribution requirements.  
	
	The name "Adobe Systems Incorporated" must not be used to endorse or promote products
	derived from the source code without prior written permission.
	
	You agree to indemnify, hold harmless and defend Adobe Systems Incorporated from and
	against any loss, damage, claims or lawsuits, including attorney's 
	fees that arise or result from your use or distribution of the source 
	code.
	
	THIS SOURCE CODE IS PROVIDED "AS IS" AND "WITH ALL FAULTS", WITHOUT 
	ANY TECHNICAL SUPPORT OR ANY EXPRESSED OR IMPLIED WARRANTIES, INCLUDING,
	BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
	FOR A PARTICULAR PURPOSE ARE DISCLAIMED.  ALSO, THERE IS NO WARRANTY OF 
	NON-INFRINGEMENT, TITLE OR QUIET ENJOYMENT.  IN NO EVENT SHALL MACROMEDIA
	OR ITS SUPPLIERS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
	EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, 
	PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS;
	OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, 
	WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR 
	OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOURCE CODE, EVEN IF
	ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/
package flexunit.framework
{

/** 
 * Base class containing static assert methods.
 */
public class Assert
{
	public function Assert()
	{
	}

//------------------------------------------------------------------------------

	public static function assertEquals(... args):void
	{
		normalizeTo3AndTest(args, failNotEquals);
	}

//------------------------------------------------------------------------------

	private static function failNotEquals( message:String, expected:Object, actual:Object ):void
	{
		if ( expected != actual )
		{
			fail( message, "expected:<" + expected + "> but was:<" + actual + ">" );
		}
	}

//------------------------------------------------------------------------------

	public static function assertStrictlyEquals(... args):void
	{
		normalizeTo3AndTest(args, failNotStrictlyEquals);
	}

//------------------------------------------------------------------------------

	private static function failNotStrictlyEquals( message:String, expected:Object, actual:Object ):void
	{
		if ( expected !== actual )
		{
			fail( message, "expected:<" + expected + "> but was:<" + actual + ">" );
		}
	}

//------------------------------------------------------------------------------

	public static function assertTrue(... args):void
	{
		normalizeTo2AndTest(args, failNotTrue);
	}

//------------------------------------------------------------------------------

	private static function failNotTrue( message:String, condition:Boolean ):void
	{
		if ( !condition )
		{
			fail( message, "expected true but was false" );
		}
	}

//------------------------------------------------------------------------------

	public static function assertFalse(... args):void
	{
		normalizeTo2AndTest(args, failTrue);
	}

//------------------------------------------------------------------------------

	private static function failTrue( message:String, condition:Boolean ):void
	{
		if ( condition )
		{
			fail( message, "expected false but was true" );
		}
	}

//------------------------------------------------------------------------------

	public static function assertNull(... args):void
	{
		normalizeTo2AndTest(args, failNotNull);
	}

//------------------------------------------------------------------------------

	private static function failNotNull( message:String, object:Object ):void
	{
		if ( object != null )
		{
			fail( message, "object was not null: " + object );
		}
	}

//------------------------------------------------------------------------------

	public static function assertNotNull(... args):void
	{
		normalizeTo2AndTest(args, failNull);
	}

//------------------------------------------------------------------------------

	private static function failNull( message:String, object:Object ):void
	{
		if ( object == null )
		{
			fail( message, "object was null: " + object );
		}
	}

//------------------------------------------------------------------------------

	//TODO: undefined has lost most of its meaning in AS3, we could probably just use the null test
	public static function assertUndefined(... rest):void
	{
		normalizeTo2AndTest(rest, failNotUndefined);
	}

//------------------------------------------------------------------------------

	private static function failNotUndefined( message:String, object:Object ):void
	{
		if ( object != null )
		{
			fail( message, "object was not undefined: " + object );
		}
	}

//------------------------------------------------------------------------------

	//TODO: undefined has lost most of its meaning in AS3, we could probably just use the null test
	public static function assertNotUndefined(... rest):void
	{
		normalizeTo2AndTest(rest, failUndefined);
	}

	private static function failUndefined( message:String, object:Object ):void
	{
		if ( object == null )
		{
			fail( message, "object was undefined: " + object );
		}
	}

//------------------------------------------------------------------------------

	public static function fail(userMessage:String = null, assertMessage:String = null):void {
		var finalMessage:String;

		if (userMessage && assertMessage)
		{
			finalMessage = userMessage + "-" + assertMessage;
		}
		else if (userMessage)
		{
			finalMessage = userMessage;
		}
		else if (assertMessage)
		{
			finalMessage = assertMessage;
		}
		else
		{
			finalMessage = "";
		}

		throw new AssertionFailedError(finalMessage);
	}

//-------------------------------------------------------------------------------

	public static function cancel(cancelMessage:String = "") : void
	{
		throw new AssertionCanceledError(cancelMessage);
	}

	private static function normalizeTo3AndTest(args:Array, testFunction:Function):void
	{
		var message:String = "";
		if (args.length == 3)
		{
			message = args.shift();
		}

		var expected:* = args.shift();
		var actual:* = args.shift();

		testFunction(message, expected, actual);
	}

	private static function normalizeTo2AndTest(args:Array, testFunction:Function):void
	{
		var message:String = "";
		if (args.length == 2)
		{
			message = args.shift();
		}

		var object:* = args.shift();

		testFunction(message, object);
	}
}

}