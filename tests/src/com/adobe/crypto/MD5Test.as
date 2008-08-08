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

	import flexunit.framework.TestCase;
	import flexunit.framework.TestSuite;
	
	import com.adobe.crypto.MD5;
	
	public class MD5Test extends TestCase {
		
	    public function MD5Test( methodName:String = null) {
			super( methodName );
        }
		
		public function testEmpty():void {
			assertMD5( "", "d41d8cd98f00b204e9800998ecf8427e" );
		}
		
		public function testA():void {
			assertMD5( "a", "0cc175b9c0f1b6a831c399e269772661" );
		}
		
		public function testABC():void {
			assertMD5( "abc", "900150983cd24fb0d6963f7d28e17f72" );
		}
		
		public function testMD():void {
			assertMD5( "message digest", "f96b697d7cb7938d525a2f31aaf161d0" );
		}
		
		public function testAlphabet():void {
			assertMD5( "abcdefghijklmnopqrstuvwxyz", "c3fcd3d76192e4007dfb496cca67e13b" );
		}
		
		public function testAlphaNumeric():void {
			assertMD5( "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789", "d174ab98d277d9f5a5611c2c9f419d9f" );
		}
		
		public function testRepeatingNumeric():void {
			assertMD5( "12345678901234567890123456789012345678901234567890123456789012345678901234567890", "57edf4a22be3c955ac49da2e2107b67a" );
		}
			
		private function assertMD5( value:String, expected:String ):void {
			assertTrue( "Hash of '" + value + "' returned wrong value ('" + MD5.hash( value ) + " ')",
						MD5.hash( value ) == expected );
		};
		
	}
		
}