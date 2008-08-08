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
	
	import com.adobe.utils.StringUtil;

	public class StringUtilTest extends TestCase
	{	
	    public function StringUtilTest(methodName:String = null)
        {
            super(methodName);
        }

		public function testStringsAreEqual():void
		{
			var s1:String = "a";
			var s2:String = "5";
			var s3:String = new String("a");
			var s4:String = "a";
			var s5:String = "A";
			
			assertTrue("StringUtil.stringsAreEqual(s1, s1, true)",
											StringUtil.stringsAreEqual(s1, s1, true));
				
			assertTrue("StringUtil.stringsAreEqual(s1, \"a\", true)",
											StringUtil.stringsAreEqual(s1, s1, true));
											
			assertTrue("StringUtil.stringsAreEqual(s1, \"A\", true)",
											StringUtil.stringsAreEqual(s1, s1, true));															
											
			assertTrue("!StringUtil.stringsAreEqual(s1, s2, true)",
											!StringUtil.stringsAreEqual(s1, s2, true));
											
			assertTrue("StringUtil.stringsAreEqual(s1, s3, true)",
											StringUtil.stringsAreEqual(s1, s3, true));
											
			assertTrue("StringUtil.stringsAreEqual(s1, s5, false)",
											StringUtil.stringsAreEqual(s1, s5, false));
											
			assertTrue("!StringUtil.stringsAreEqual(s1, s5, true)",
											!StringUtil.stringsAreEqual(s1, s5, true));
											
			assertTrue("StringUtil.stringsAreEqual(s3, s5, false)",
											StringUtil.stringsAreEqual(s1, s5, false));
		}

		public function testEndsWith():void
		{
			assertTrue(
				"StringUtil.endsWith(\"AAAX\", \"X\") == true",
				StringUtil.endsWith("AAAX", "X") == true
				);
				
			assertTrue(
				"StringUtil.endsWith(\"XAAA\", \"O\") == false",
				StringUtil.endsWith("XAAA", "0") == false
				);
				
			assertTrue(
				"StringUtil.endsWith(\"AAXX\", \"XX\") == true",
				StringUtil.endsWith("AAXX", "XX") == true
				);
				
			assertTrue(
				"StringUtil.endsWith(\"AAXXX\", \"XX\") == true",
				StringUtil.endsWith("AAXXX", "XX") == true
				);
				
			assertTrue(
				"StringUtil.endsWith(\"\", \"XX\") == false",
				StringUtil.endsWith("", "XX") == false
				);

			//TODO : Should this return true or false?
			assertTrue(
				"StringUtil.endsWith(\"XX\", \"\") == true",
				StringUtil.endsWith("XX", "") == true
				);
				
			assertTrue(
				"StringUtil.endsWith(\"\", \"\") == true",
				StringUtil.endsWith("", "") == true
				);
		}		
		
		public function testBeginsWith():void
		{
			assertTrue(
				"StringUtil.beginsWith(\"XAAA\", \"X\") == true",
				StringUtil.beginsWith("XAAA", "X") == true
				);
				
			assertTrue(
				"StringUtil.beginsWith(\"XAAA\", \"O\") == false",
				StringUtil.beginsWith("XAAA", "0") == false
				);
				
			assertTrue(
				"StringUtil.beginsWith(\"XXAA\", \"XX\") == true",
				StringUtil.beginsWith("XXAA", "XX") == true
				);
				
			assertTrue(
				"StringUtil.beginsWith(\"XXXAA\", \"XX\") == true",
				StringUtil.beginsWith("XXXAA", "XX") == true
				);
				
			assertTrue(
				"StringUtil.beginsWith(\"\", \"XX\") == false",
				StringUtil.beginsWith("", "XX") == false
				);

			//TODO : Should this return true or false?
			assertTrue(
				"StringUtil.beginsWith(\"XX\", \"\") == true",
				StringUtil.beginsWith("XX", "") == true
				);
				
			assertTrue(
				"StringUtil.beginsWith(\"\", \"\") == true",
				StringUtil.beginsWith("", "") == true
				);
		}
		
		public function testRemove():void
		{
			assertTrue(
				"StringUtil.remove(\"AXXA\", \"X\") == \"AA\"",
				StringUtil.remove("AXXA", "X") == "AA"
				);
				
			assertTrue(
				"StringUtil.remove(\"AXXAXAXXA\", \"X\") == \"AAAA\"",
				StringUtil.remove("AXXAXAXXA", "X") == "AAAA"
				);				
				
			assertTrue(
				"StringUtil.remove(\"AXXXXA\", \"XX\") == \"AA\"",
				StringUtil.remove("AXXXXA", "XX") == "AA"
				);				
				
			assertTrue(
				"StringUtil.remove(\"AXXXA\", \"XX\") == \"AXA\"",
				StringUtil.remove("AXXXA", "XX") == "AXA"
				);
				
			assertTrue(
				"StringUtil.remove(\"AXXXA\", \"-\") == \"AXXXA\"",
				StringUtil.remove("AXXXA", "-") == "AXXXA"
				);
				
			assertTrue(
				"StringUtil.remove(\"X\", \"\") == \"X\"",
				StringUtil.remove("X", "") == "X"
				);
				
			assertTrue(
				"StringUtil.remove(\"\", \"\") == \"\"",
				StringUtil.remove("", "") == ""
				);
		}
		
		public function testReplace():void
		{
			assertTrue(
						"StringUtil.replace(\"AXXA\", \"X\", \"-\") == \"A--A\"",
						StringUtil.replace("AXXA", "X", "-") == "A--A"
						);
						
			assertTrue(
						"StringUtil.replace(\"AXXA\", \"B\", \"-\") == \"AXXA\"",
						StringUtil.replace("AXXA", "B", "-") == "AXXA"
						);	
						
			assertTrue(
						"StringUtil.replace(\"AXXA\", \"XX\", \"-\") == \"A-A\"",
						StringUtil.replace("AXXA", "XX", "-") == "A-A"
						);						
						
			assertTrue(
						"StringUtil.replace(\"AXXA\", \"XX\", \"----\") == \"A----A\"",
						StringUtil.replace("AXXA", "XX", "----") == "A----A"
						);						
						
			assertTrue(
						"StringUtil.replace(\"X\", \"X\", \"-\") == \"-\"",
						StringUtil.replace("X", "X", "-") == "-"
						);
						
			assertTrue(
						"StringUtil.replace(\"AXXA\", \"X\", \"X\") == \"AXXA\"",
						StringUtil.replace("AXXA", "X", "X") == "AXXA"
						);
						
			assertTrue(
						"StringUtil.replace(\"AXXXXA\", \"XXXX\", \"-\") == \"A-A\"",
						StringUtil.replace("AXXXXA", "XXXX", "-") == "A-A"
						);						
						
		}
		
		public function testTrim():void
		{
			assertTrue("StringUtil.trim(\" XXX \") == \"XXX\"",
											StringUtil.trim(" XXX ") == "XXX");
											
			assertTrue("StringUtil.trim(\" \") == \"\"",
											StringUtil.trim(" ") == "");
											
			assertTrue("StringUtil.trim(\"XX\") == \"XX\"",
											StringUtil.trim("XX") == "XX");
											
			assertTrue("StringUtil.trim(\"X\") == \"X\"",
											StringUtil.trim("X") == "X");
											
			assertTrue("StringUtil.trim(\" XX\") == \"XX\"",
											StringUtil.trim(" XX") == "XX");
											
			assertTrue("StringUtil.trim(\"XX \") == \"XX\"",
											StringUtil.trim("XX ") == "XX");
		}
		
		public function testRTrim():void
		{
			assertTrue("StringUtil.rtrim(\" XXX \") == \" XXX\"",
											StringUtil.rtrim(" XXX ") == " XXX");
											
			assertTrue("StringUtil.rtrim(\" \") == \"\"",
											StringUtil.rtrim(" ") == "");
											
			assertTrue("StringUtil.rtrim(\"XX\") == \"XX\"",
											StringUtil.rtrim("XX") == "XX");
											
			assertTrue("StringUtil.rTrim(\"X\") == \"X\"",
											StringUtil.rtrim("X") == "X");
											
			assertTrue("StringUtil.rtrim(\"X \") == \"X\"",
											StringUtil.rtrim("X ") == "X");
											
			assertTrue("StringUtil.rtrim(\" XX\") == \" XX\"",
											StringUtil.rtrim(" XX") == " XX");
											
			assertTrue("StringUtil.rtrim(\"XX \") == \"XX\"",
											StringUtil.rtrim("XX ") == "XX");
		}
		
		public function testLTrim():void
		{
			assertTrue("StringUtil.ltrim(\" XXX \") == \"XXX \"",
											StringUtil.ltrim(" XXX ") == "XXX ");
											
			assertTrue("StringUtil.ltrim(\" \") == \"\"",
											StringUtil.ltrim(" ") == "");
											
			assertTrue("StringUtil.ltrim(\"XX\") == \"XX\"",
											StringUtil.ltrim("XX") == "XX");
											
			assertTrue("StringUtil.rTrim(\"X\") == \"X\"",
											StringUtil.ltrim("X") == "X");
											
			assertTrue("StringUtil.ltrim(\" X\") == \"X\"",
											StringUtil.ltrim(" X") == "X");
											
			assertTrue("StringUtil.ltrim(\"XX \") == \"XX \"",
											StringUtil.ltrim("XX ") == "XX ");
											
			assertTrue("StringUtil.ltrim(\" XX\") == \"XX\"",
											StringUtil.ltrim(" XX") == "XX");
		}
	}
}