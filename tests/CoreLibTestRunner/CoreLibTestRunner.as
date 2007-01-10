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

import com.adobe.crypto.tests.MD5Test;
import com.adobe.crypto.tests.SHA1Test;
import com.adobe.crypto.tests.WSSEUsernameTokenTest;
import com.adobe.net.tests.URITest;
import com.adobe.serialization.json.tests.JSONTest;
import com.adobe.utils.tests.ArrayUtilTest;
import com.adobe.utils.tests.DateUtilTest;
import com.adobe.utils.tests.IntUtilTest;
import com.adobe.utils.tests.NumberFormatterTest;
import com.adobe.utils.tests.StringUtilTest;
import com.adobe.utils.tests.XMLUtilTest;
import com.adobe.utils.tests.DictionaryUtilTest;

import flexunit.framework.TestSuite;
			
private function onCreationComplete():void
{
	testRunner.test = createSuite();
	testRunner.startTest();	
}

private function createSuite():TestSuite
{
	var ts:TestSuite = new TestSuite();

		ts.addTestSuite(StringUtilTest);
		ts.addTestSuite(NumberFormatterTest);
		ts.addTestSuite(ArrayUtilTest);
		ts.addTestSuite(DateUtilTest);
		ts.addTestSuite(URITest);
		ts.addTestSuite(MD5Test);
		ts.addTestSuite(IntUtilTest);
		ts.addTestSuite(JSONTest);		
		ts.addTestSuite(XMLUtilTest);
		ts.addTestSuite(SHA1Test);
		ts.addTestSuite(WSSEUsernameTokenTest);
		ts.addTestSuite(DictionaryUtilTest);
	
	return ts;
}
