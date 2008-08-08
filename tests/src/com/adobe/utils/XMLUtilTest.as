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
	
	import com.adobe.utils.XMLUtil;

	public class XMLUtilTest extends TestCase
	{	
		
		private var validXML:XML = 
							<cross-domain-policy>
					   			<allow-access-from domain="*" />
							</cross-domain-policy>
							
		private var nonvalidXML:String = "<div /><div />";
			
		private var simpleString:String = "a";
		
		private var element:String = "<div />";
		
	    public function XMLUtilTest(methodName:String = null)
        {
            super(methodName);
        }
        


		public function testStringsAreEqual():void
		{			
			assertTrue("XMLUtil.isValidXML(String(validXML))",XMLUtil.isValidXML(String(validXML)));
			assertTrue("!XMLUtil.isValidXML(simpleString)", !XMLUtil.isValidXML(simpleString));
			assertTrue("XMLUtil.isValidXML(element)", XMLUtil.isValidXML(element));
			assertTrue("!XMLUtil.isValidXML(element)", !XMLUtil.isValidXML(nonvalidXML));
				
		}
		
		private var xml:XML = 
			<xml>
				<top>
					<a>foo</a>
					<b>bar</b>
					<c>bam</c>
				</top>
			</xml>
		
		public function testgetNextSibling():void
		{
			
			var s:Number = (new Date()).getTime();
			assertTrue("XMLUtil.getNextSibling(xml.top[0].b[0]) == xml.top[0].c[0]", 
									XMLUtil.getNextSibling(xml.top[0].b[0]) == xml.top[0].c[0]);
			assertTrue("XMLUtil.getNextSibling(xml.top[0].c[0]) == null", 
									XMLUtil.getNextSibling(xml.top[0].c[0]) == null);		
			assertTrue("XMLUtil.getNextSibling(xml.top[0]) == null", 
									XMLUtil.getNextSibling(xml.top[0]) == null);																
		}
		
		public function testgetPreviousSibling():void
		{
			assertTrue("XMLUtil.getPreviousSibling(xml.top[0].b[0]) == xml.top[0].a[0]", 
									XMLUtil.getPreviousSibling(xml.top[0].b[0]) == xml.top[0].a[0]);
			assertTrue("XMLUtil.getPreviousSibling(xml.top[0].a[0]) == null", 
									XMLUtil.getPreviousSibling(xml.top[0].a[0]) == null);		
			assertTrue("XMLUtil.getPreviousSibling(xml.top[0]) == null", 
									XMLUtil.getPreviousSibling(xml.top[0]) == null);	
		}		
	}
}