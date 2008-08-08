/*
  Copyright (c) 2008, Adobe Systems Incorporated
  All rights reserved.

  Redistribution and use in source and binary forms, with or without 
  modification, are permitted provided that the following conditions are
  met:

  * Redistributions of source code must retain the above copyright notice, 
    this list of conditions and the following disclaimer.
  
  * Redistributions in binary form must reproduce the above copyright
    notice, this list of conditions and the following disclaimer in the 
    documentation and/or other materials provided with the distribution.
  
  * Neither the name of Adobe Systems Incorporated nor the names of its 
    contributors may be used to endorse or promote products derived from 
    this software without specific prior written permission.

  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS
  IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO,
  THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
  PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR 
  CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
  EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
  PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
  PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
  LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
  NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
  SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
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