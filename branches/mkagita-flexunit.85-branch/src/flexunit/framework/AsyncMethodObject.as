/*
	Adobe Systems Incorporated(r) Source Code License Agreement
	Copyright(c) 2007 Adobe Systems Incorporated. All rights reserved.
	
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
	import flash.events.Event;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	
	
	//func: func, timeout: timeout, extraData: passThroughData, failFunc: failFunc};
	dynamic public class AsyncMethodObject 
	{
		private var  mFunc : Function ;
		private var  mTimeout : int;
		private var  mExtraData : Object;
		private var  mFailFunc : Function;
		private var  asyncTestHelper : AsyncTestHelper;
		
		private var  isDead : Boolean = false;
		
		public function setDead() : void {
			isDead = true;
		}
	
		
		public function get failFunc ()  : Function { 
			return mFailFunc;	
		}
		
		public function get timeout ()  : int { 
			return mTimeout;	
		}
		
		public function get extraData ()  : Object { 
			return mExtraData;	
		}
		public function get func ()  : Function { 
			return mFunc;	
		}
		public function AsyncMethodObject(parentAsyncTestHelper : AsyncTestHelper , func : Function, timeout : int, extraData : Object, failFunc : Function) {
			mFunc = func;
			mTimeout = timeout;
			mExtraData = extraData;
			mFailFunc = failFunc;
			asyncTestHelper = parentAsyncTestHelper;
		}
	
		
		public function handleEvent(event : Event) : void
		{
			//trace(timeout + " and " + event.type + " and " + this.asyncTestHelper.testCase.methodName);
			/* remove the event handler as AsyncMethods are one shot. 
			  I think I might miss the cases where chain adds listener to multiple event type, but
			  that would require lot of changes. At least this will make sure we remove the 
			  event listener for the event that was being fired */;
			  
			event.currentTarget.removeEventListener(event.type, this.handleEvent);
			if(!isDead) {
				// The isDead flag will cover the above case along with others (see setDead() callers).
				isDead = true;
			 	asyncTestHelper.handleEvent(event, this);
			}
		};
	}
	
	
	
}