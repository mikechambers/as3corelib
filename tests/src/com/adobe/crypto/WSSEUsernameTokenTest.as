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

package com.adobe.crypto
{

	import com.adobe.crypto.WSSEUsernameToken;
	
	import flexunit.framework.TestCase;
	import flexunit.framework.TestSuite;
	
	public class WSSEUsernameTokenTest extends TestCase {
		
	    public function WSSEUsernameTokenTest( methodName:String = null ) {
			super( methodName );
        }
		
		public function testWSSEUsernameToken():void {
		
			// Results generated from stripped-down version of Claude
			// Montpetit's WSSE-enabled Atom API client (see
			// http://www.montpetit.net/en/2004/06/06/11h32/index.html).
			//
			
			var date:Date = new Date(Date.parse("05/09/2006 13:43:21 GMT-0700"));
			assertWSSEUsernameToken( "abc", "abc", "0123456789", date,
				 "UsernameToken Username=\"abc\", PasswordDigest=\"" 
				 + WSSEUsernameToken.getBase64Digest( WSSEUsernameToken.base64Encode( "0123456789" ),
				 									WSSEUsernameToken.generateTimestamp( date ),
				 									"abc" ) 
				 + "\", Nonce=\"MDEyMzQ1Njc4OQ==\", Created=\"2006-05-09T" + ( date.hours < 10 ? "0" + date.hours : date.hours ) + ":43:21Z\"" );
			
			date = new Date(Date.parse("05/09/2006 16:11:46 GMT-0700"));
			assertWSSEUsernameToken( "fe31_449", "168fqo4659", "1147216300992", date,
				 "UsernameToken Username=\"fe31_449\", PasswordDigest=\"" 
				 + WSSEUsernameToken.getBase64Digest( WSSEUsernameToken.base64Encode( "1147216300992" ), 
				 									WSSEUsernameToken.generateTimestamp( date ), 
				 									"168fqo4659" ) 
				 + "\", Nonce=\"MTE0NzIxNjMwMDk5Mg==\", Created=\"2006-05-09T" + ( date.hours < 10 ? "0" + date.hours : date.hours ) + ":11:46Z\"" );
				 
			date = new Date(Date.parse("08/16/2006 01:48:28 GMT-0700"));
			assertWSSEUsernameToken( "candy", "dandy", "2018558572", date,
				 "UsernameToken Username=\"candy\", PasswordDigest=\"" 
				 + WSSEUsernameToken.getBase64Digest( WSSEUsernameToken.base64Encode( "2018558572" ), 
				 									WSSEUsernameToken.generateTimestamp( date ), 
				 									"dandy" )
				 + "\", Nonce=\"MjAxODU1ODU3Mg==\", Created=\"2006-08-16T" + ( date.hours < 10 ? "0" + date.hours : date.hours ) + ":48:28Z\"" );
		}
		
		private function assertWSSEUsernameToken( username:String, password:String, nonce:String,
				timestamp:Date, expected:String ):void {
			var result:String = WSSEUsernameToken.getUsernameToken( username, password, nonce, timestamp );
			
			assertTrue( "WSSEUsernameToken returned wrong value ('" + result + "')" + expected,
						result == expected );
		}		
	}
}