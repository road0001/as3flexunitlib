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

import flash.events.*;
import flash.utils.*;

public class AsyncTestHelper
{

    public function AsyncTestHelper(testCase : TestCase, testResult : TestResult)
    {
        this.testCase = testCase;
        this.testResult = testResult;
        timer = new Timer(100);
        timer.addEventListener("timer", timerHandler);
    }

//------------------------------------------------------------------------------

    public function startAsync() : void
    {
        loadAsync();
        if (eventHandlerQueue.length > 0)
        {
        	
            testResult.continueRun(testCase);
        }
        else
        {
            timer.start();
        }
    }

//------------------------------------------------------------------------------

    public function loadAsync() : void
    {
      
           
        /* set the timer to max timeout among all async methods.
           This would be worst case scenario when none of the event handlers is triggered.
           
        */ 
        //BUG 114824 WORKAROUND
        var maxTimeout : int = testCase.getMaxAsyncTimeout();
        timer = new Timer(maxTimeout , 1);
        timer.addEventListener("timer", timerHandler);
        //END WORKAROUND
        timer.delay = maxTimeout;
        
    }

//------------------------------------------------------------------------------

    public function runNext() : void
    {
        if (shouldFail)
        {
            if (failFunc != null)
            {
                failFunc(extraData);
            }
            else
            {
                var msg : String = "Asynchronous function did not fire after " + timer.delay + " ms";
                Assert.fail(msg);
            }
        }
        else
        {
           /* FIFO */
           var obj : Object = eventHandlerQueue.shift();
           /* remove the async method before we do anything */
           testCase.removeAsyncMethod(obj.asyncMethod);
           /* adjust the timer to amount of timeout for this method */
                     
           timer.stop();
           timer = new Timer( 1);
           timer.addEventListener("timer", timerHandler);
           timer.delay = obj.asyncMethod.timeout;
            if (obj.asyncMethod.extraData != null)
            {
                obj.asyncMethod.func(obj.event, obj.asyncMethod.extraData);
            }
            else
            {
                obj.asyncMethod.func(obj.event);
            }
            func = null;
            extraData = null;
           
         }
        
    }



//------------------------------------------------------------------------------

    public function timerHandler(event : TimerEvent) : void
    {
        timer.stop();
        shouldFail = true;
        testCase.removeAllAsyncMethod();
        testResult.continueRun(testCase);
    }

//------------------------------------------------------------------------------

    public function handleEvent(event : Event, asyncMethod : AsyncMethodObject) : void
    {
        var wasReallyAsync : Boolean = timer.running;
        timer.stop();
        //if we already failed don't do anything
        if (shouldFail)
            return;
        
        
        /* Queue up the event and associated asyncMethod information */
        eventHandlerQueue.push({event : event, asyncMethod: asyncMethod});
        
        
        if (wasReallyAsync)
        {
  			testResult.continueRun(testCase);
        }
    }

//------------------------------------------------------------------------------

    //IResponder methods here (they'd look similar to handleEvent) ...

//------------------------------------------------------------------------------

    private var testCase : TestCase;
    private var func : Function;
    private var extraData : Object;
    private var failFunc : Function;
    private var testResult : TestResult;

    private var shouldFail : Boolean = false;
  
    private var eventHandlerQueue : Array = new Array();
    private var timer : Timer;

}

}
