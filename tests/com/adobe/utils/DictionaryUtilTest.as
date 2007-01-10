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
FOR A PARTICULAR PURPOSE ARE DISCLAIMED. ALSO, THERE IS NO WARRANTY OF
NON-INFRINGEMENT, TITLE OR QUIET ENJOYMENT. IN NO EVENT SHALL MACROMEDIA
OR ITS SUPPLIERS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS;
OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR
OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOURCE CODE, EVEN IF
ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/

package com.adobe.utils
{

	import flexunit.framework.TestCase;
	import flexunit.framework.TestSuite;
	
	import com.adobe.utils.DictionaryUtil;
	import flash.utils.Dictionary;
	import com.adobe.utils.ArrayUtil;
	
	public class DictionaryUtilTest extends TestCase {
		
		private var d:Dictionary;
		private var objectKey:Object = {};
		private var objectValue:Object = {};
		
	    public function DictionaryUtilTest( methodName:String = null) {
			super( methodName );
			
			d = new Dictionary();
			d.keyA = "valueA";
			d.keyB = "valueB";
			d[1] = 2;
			d[objectKey] = objectValue;
			
        }
		
		public function testGetKeys():void {
			
			var keys:Array = DictionaryUtil.getKeys(d);
			
			assertTrue( "keys.length == 4", keys.length == 4 );
			assertTrue("ArrayUtil.arrayContainsValue(keys, \"keyA\")",
									 ArrayUtil.arrayContainsValue(keys, "keyA"));
			assertTrue("ArrayUtil.arrayContainsValue(keys, \"keyB\")",
									 ArrayUtil.arrayContainsValue(keys, "keyB"));
			assertTrue("ArrayUtil.arrayContainsValue(keys, 1)", 
											ArrayUtil.arrayContainsValue(keys, 1));
			assertTrue("ArrayUtil.arrayContainsValue(keys, objectKey)",
									 ArrayUtil.arrayContainsValue(keys, objectKey));


		}

		public function testGetValues():void {
			var values:Array = DictionaryUtil.getValues(d);
			
			assertTrue( "values.length == 4", values.length == 4 );

			assertTrue("ArrayUtil.arrayContainsValue(values, \"valueA\")",
									 ArrayUtil.arrayContainsValue(values, "valueA"));
			assertTrue("ArrayUtil.arrayContainsValue(values, \"keyB\")",
									 ArrayUtil.arrayContainsValue(values, "valueB"));
			assertTrue("ArrayUtil.arrayContainsValue(values, 2)", 
											ArrayUtil.arrayContainsValue(values, 2));
			assertTrue("ArrayUtil.arrayContainsValue(values, objectValue)",
									 ArrayUtil.arrayContainsValue(values, objectValue));
		}

	}
}