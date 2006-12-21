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

package com.adobe.utils.tests
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